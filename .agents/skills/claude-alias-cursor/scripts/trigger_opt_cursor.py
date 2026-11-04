#!/usr/bin/env python3
"""Skill description trigger optimization using Cursor Agent CLI instead of `claude -p`.

Part of the claude-alias-cursor skill (scripts/trigger_opt_cursor.py).
Replaces skill-creator's `python -m scripts.run_loop` when Claude Code is unavailable.

Classification eval: for each query, ask the model TRIGGER or SKIP given only
name+description (mirrors description-based skill loading). Then propose improved
descriptions from failed cases and re-score with a train/test holdout.
"""

from __future__ import annotations

import argparse
import json
import os
import random
import re
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone
from pathlib import Path


def agent_argv() -> list[str]:
    """Return argv prefix for Cursor Agent CLI.

    - CURSOR_AGENT_BIN unset or `cursor` → `cursor agent …`
    - CURSOR_AGENT_BIN=`agent` (or path ending with agent) → `agent …`
    """
    binary = os.environ.get("CURSOR_AGENT_BIN", "cursor")
    name = Path(binary).name
    if name == "agent":
        return [binary]
    return [binary, "agent"]


def parse_skill_md(skill_path: Path) -> tuple[str, str, str]:
    text = (skill_path / "SKILL.md").read_text(encoding="utf-8")
    if not text.startswith("---"):
        raise ValueError("SKILL.md missing frontmatter")
    end = text.find("\n---", 3)
    if end < 0:
        raise ValueError("SKILL.md frontmatter not closed")
    fm = text[3:end]
    body = text[end + 4 :]
    name = ""
    desc_lines: list[str] = []
    in_desc = False
    for line in fm.splitlines():
        if line.startswith("name:"):
            name = line.split(":", 1)[1].strip().strip("\"'")
            in_desc = False
        elif line.startswith("description:"):
            rest = line.split(":", 1)[1].strip()
            if rest in (">-", "|", ">"):
                in_desc = True
                desc_lines = []
            else:
                in_desc = False
                desc_lines = [rest.strip("\"'")]
        elif in_desc:
            if line.startswith("  ") or line.startswith("\t") or line.strip() == "":
                desc_lines.append(line.strip())
            else:
                in_desc = False
    description = " ".join(x for x in desc_lines if x).strip()
    return name, description, body


def set_description(skill_path: Path, new_description: str) -> None:
    path = skill_path / "SKILL.md"
    text = path.read_text(encoding="utf-8")
    end = text.find("\n---", 3)
    fm = text[3:end]
    body = text[end + 4 :]
    # Rebuild frontmatter keeping other fields
    lines = fm.splitlines()
    out: list[str] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith("description:"):
            out.append("description: >-")
            # wrap description into YAML folded lines
            words = new_description.split()
            buf = ""
            for w in words:
                trial = (buf + " " + w).strip()
                if len(trial) > 88 and buf:
                    out.append("  " + buf)
                    buf = w
                else:
                    buf = trial
            if buf:
                out.append("  " + buf)
            i += 1
            # skip old description block
            while i < len(lines):
                nxt = lines[i]
                if nxt.startswith("  ") or nxt.strip() == "":
                    i += 1
                    continue
                if nxt.startswith("name:") or nxt.startswith("license:") or nxt.startswith("metadata:") or re.match(r"^[a-zA-Z0-9_]+:", nxt):
                    break
                i += 1
            continue
        out.append(line)
        i += 1
    path.write_text("---\n" + "\n".join(line for line in out if line is not None).lstrip("\n") + "\n---" + body, encoding="utf-8")


def run_cursor_agent(prompt: str, *, mode: str = "ask", timeout: int = 120, model: str | None = None) -> str:
    cmd = [
        *agent_argv(),
        "-p",
        "-f",
        "--trust",
        "--mode",
        mode,
        "--output-format",
        "text",
        "--sandbox",
        "disabled",
    ]
    if model:
        cmd.extend(["--model", model])
    cmd.append(prompt)
    env = os.environ.copy()
    proc = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        timeout=timeout,
        env=env,
    )
    if proc.returncode != 0:
        raise RuntimeError(f"cursor agent failed ({proc.returncode}): {proc.stderr[-500:]}")
    return proc.stdout.strip()


def classify_trigger(skill_name: str, description: str, query: str, timeout: int, model: str | None) -> bool:
    prompt = f"""You are deciding whether to load a Cursor Agent skill before handling a user request.
You only see the skill name and description (not the skill body).

Skill name: {skill_name}
Skill description:
{description}

User request:
{query}

Should you load/read this skill for this request?
Answer with exactly one token: TRIGGER or SKIP
No other words."""
    out = run_cursor_agent(prompt, mode="ask", timeout=timeout, model=model)
    # Take last TRIGGER/SKIP occurrence to ignore preamble
    tokens = re.findall(r"\b(TRIGGER|SKIP)\b", out.upper())
    if not tokens:
        # ambiguous -> treat as SKIP (conservative for false positives on improve)
        return False
    return tokens[-1] == "TRIGGER"


def split_eval_set(eval_set: list[dict], holdout: float, seed: int = 42) -> tuple[list[dict], list[dict]]:
    random.seed(seed)
    trigger = [e for e in eval_set if e["should_trigger"]]
    no_trigger = [e for e in eval_set if not e["should_trigger"]]
    random.shuffle(trigger)
    random.shuffle(no_trigger)
    n_t = max(1, int(len(trigger) * holdout))
    n_n = max(1, int(len(no_trigger) * holdout))
    test_set = trigger[:n_t] + no_trigger[:n_n]
    train_set = trigger[n_t:] + no_trigger[n_n:]
    return train_set, test_set


def run_eval(
    eval_set: list[dict],
    skill_name: str,
    description: str,
    *,
    runs_per_query: int,
    trigger_threshold: float,
    timeout: int,
    model: str | None,
    workers: int,
    verbose: bool,
) -> dict:
    results = []

    def one(item: dict, run_idx: int) -> tuple[str, bool]:
        try:
            trig = classify_trigger(skill_name, description, item["query"], timeout, model)
        except Exception as e:
            if verbose:
                print(f"  error: {e}", file=sys.stderr)
            trig = False
        return item["query"], trig

    futures = []
    with ThreadPoolExecutor(max_workers=workers) as ex:
        for item in eval_set:
            for run_idx in range(runs_per_query):
                futures.append(ex.submit(one, item, run_idx))
        by_query: dict[str, list[bool]] = {}
        for fut in as_completed(futures):
            q, trig = fut.result()
            by_query.setdefault(q, []).append(trig)

    passed = 0
    for item in eval_set:
        triggers = by_query.get(item["query"], [])
        rate = sum(triggers) / len(triggers) if triggers else 0.0
        did = rate >= trigger_threshold
        ok = did == item["should_trigger"]
        if ok:
            passed += 1
        results.append(
            {
                "query": item["query"],
                "should_trigger": item["should_trigger"],
                "triggers": sum(triggers),
                "runs": len(triggers),
                "trigger_rate": rate,
                "pass": ok,
            }
        )
        if verbose:
            mark = "PASS" if ok else "FAIL"
            print(
                f"  [{mark}] should={item['should_trigger']} rate={rate:.2f} :: {item['query'][:80]}",
                file=sys.stderr,
            )

    return {
        "results": results,
        "summary": {"passed": passed, "total": len(eval_set), "pass_rate": passed / len(eval_set) if eval_set else 0},
    }


def improve_description(
    skill_name: str,
    skill_body: str,
    current_description: str,
    eval_results: dict,
    history: list[dict],
    model: str | None,
    timeout: int,
) -> str:
    failed = [r for r in eval_results["results"] if r["should_trigger"] and not r["pass"]]
    false_pos = [r for r in eval_results["results"] if not r["should_trigger"] and not r["pass"]]
    prompt = f"""You optimize Cursor Agent skill descriptions for triggering accuracy.
Skill name: {skill_name}

Current description:
{current_description}

Train score: {eval_results['summary']['passed']}/{eval_results['summary']['total']}

FAILED TO TRIGGER (should trigger):
"""
    for r in failed:
        prompt += f'- "{r["query"]}" (triggered {r["triggers"]}/{r["runs"]})\n'
    prompt += "\nFALSE TRIGGERS (should NOT trigger):\n"
    for r in false_pos:
        prompt += f'- "{r["query"]}" (triggered {r["triggers"]}/{r["runs"]})\n'
    prompt += f"""
Skill body excerpt (for intent only; do not paste long body into description):
{skill_body[:2500]}

Write an improved description that:
- Is pushy for true positives (relevant queries should TRIGGER)
- Explicitly excludes near-miss negatives
- Stays under ~500 characters if possible, Japanese OK
- Does not use markdown fences

Return ONLY the new description text."""
    out = run_cursor_agent(prompt, mode="ask", timeout=timeout, model=model)
    # Strip accidental quotes/fences
    out = re.sub(r"^```.*?\n|```$", "", out.strip(), flags=re.S).strip().strip('"').strip()
    if len(out) < 40:
        raise RuntimeError(f"improve_description returned too short: {out!r}")
    return out


def run_loop(
    eval_set: list[dict],
    skill_path: Path,
    *,
    max_iterations: int,
    holdout: float,
    runs_per_query: int,
    trigger_threshold: float,
    timeout: int,
    model: str | None,
    workers: int,
    verbose: bool,
    apply_best: bool,
) -> dict:
    name, original, body = parse_skill_md(skill_path)
    current = original
    train_set, test_set = split_eval_set(eval_set, holdout) if holdout > 0 else (eval_set, [])
    history = []
    exit_reason = "max_iterations"

    for iteration in range(1, max_iterations + 1):
        if verbose:
            print(f"\n=== Iteration {iteration} ===", file=sys.stderr)
            print(f"Description: {current[:160]}...", file=sys.stderr)
        train_results = run_eval(
            train_set,
            name,
            current,
            runs_per_query=runs_per_query,
            trigger_threshold=trigger_threshold,
            timeout=timeout,
            model=model,
            workers=workers,
            verbose=verbose,
        )
        test_results = None
        if test_set:
            test_results = run_eval(
                test_set,
                name,
                current,
                runs_per_query=runs_per_query,
                trigger_threshold=trigger_threshold,
                timeout=timeout,
                model=model,
                workers=workers,
                verbose=verbose,
            )
        entry = {
            "iteration": iteration,
            "description": current,
            "train_passed": train_results["summary"]["passed"],
            "train_total": train_results["summary"]["total"],
            "test_passed": test_results["summary"]["passed"] if test_results else None,
            "test_total": test_results["summary"]["total"] if test_results else None,
            "train_results": train_results,
            "test_results": test_results,
        }
        history.append(entry)
        if verbose:
            ts = f"train {entry['train_passed']}/{entry['train_total']}"
            if test_results:
                ts += f", test {entry['test_passed']}/{entry['test_total']}"
            print(ts, file=sys.stderr)

        perfect_train = entry["train_passed"] == entry["train_total"]
        perfect_test = (not test_set) or (entry["test_passed"] == entry["test_total"])
        if perfect_train and perfect_test:
            exit_reason = "perfect_score"
            break

        if iteration == max_iterations:
            break

        current = improve_description(
            name, body, current, train_results, history, model, timeout=max(timeout, 180)
        )

    if test_set:
        best = max(history, key=lambda h: (h["test_passed"] or 0, h["train_passed"]))
    else:
        best = max(history, key=lambda h: h["train_passed"])

    if apply_best:
        set_description(skill_path, best["description"])

    return {
        "skill_name": name,
        "exit_reason": exit_reason,
        "original_description": original,
        "best_description": best["description"],
        "best_train_score": f"{best['train_passed']}/{best['train_total']}",
        "best_test_score": (
            f"{best['test_passed']}/{best['test_total']}" if best["test_passed"] is not None else None
        ),
        "iterations_run": len(history),
        "history": [
            {
                "iteration": h["iteration"],
                "train": f"{h['train_passed']}/{h['train_total']}",
                "test": f"{h['test_passed']}/{h['test_total']}" if h["test_passed"] is not None else None,
                "description": h["description"],
            }
            for h in history
        ],
        "applied": apply_best,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--eval-set", required=True)
    ap.add_argument("--skill-path", required=True)
    ap.add_argument("--max-iterations", type=int, default=5)
    ap.add_argument("--holdout", type=float, default=0.4)
    ap.add_argument("--runs-per-query", type=int, default=3)
    ap.add_argument("--trigger-threshold", type=float, default=0.5)
    ap.add_argument("--timeout", type=int, default=90)
    ap.add_argument("--model", default=None)
    ap.add_argument("--workers", type=int, default=3)
    ap.add_argument("--verbose", action="store_true")
    ap.add_argument("--apply-best", action="store_true")
    ap.add_argument("--results-out", required=True)
    args = ap.parse_args()

    eval_set = json.loads(Path(args.eval_set).read_text(encoding="utf-8"))
    skill_path = Path(args.skill_path)
    out = run_loop(
        eval_set,
        skill_path,
        max_iterations=args.max_iterations,
        holdout=args.holdout,
        runs_per_query=args.runs_per_query,
        trigger_threshold=args.trigger_threshold,
        timeout=args.timeout,
        model=args.model,
        workers=args.workers,
        verbose=args.verbose,
        apply_best=args.apply_best,
    )
    Path(args.results_out).write_text(json.dumps(out, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({k: out[k] for k in out if k != "history"}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
