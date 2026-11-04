#!/usr/bin/env python3
"""ワークスペースの Cursor 向けベースライン/SKILL トークン量を概算する。

正確なモデルトークナイザと一致しない場合がある。可能なときは tiktoken(o200k_base)
を使い、無いときは chars/4 の概算にフォールバックする。
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import asdict, dataclass, field
from pathlib import Path

SKIP_DIR_NAMES = {
    ".git",
    "node_modules",
    ".dart_tool",
    "build",
    ".ai-agent",
    "iteration-1",
    "iteration-2",
    "iteration-3",
    "iteration-4",
    "iteration-5",
    "eval-viewer",
    "__pycache__",
    ".tox",
    "vendor",
}

FRONTMATTER_RE = re.compile(r"^---\r?\n(.*?)\r?\n---\r?\n?", re.S)


@dataclass
class TableRow:
    """assets/report.md の表1行: ファイル名 | トークン量 | 内容 | ファイルパス"""

    filename: str
    tokens: int
    content: str
    path: str
    chars: int = 0


@dataclass
class FileTokenRow:
    category: str
    path: str
    chars: int
    tokens: int
    note: str = ""
    filename: str = ""


@dataclass
class SkillRow:
    name: str
    path: str
    description_chars: int
    description_tokens: int
    body_chars: int
    body_tokens: int
    total_chars: int
    total_tokens: int


@dataclass
class Report:
    tokenizer: str
    accuracy_note: str
    roots: list[str]
    baseline: list[FileTokenRow] = field(default_factory=list)
    skills: list[SkillRow] = field(default_factory=list)
    documents: list[TableRow] = field(default_factory=list)
    baseline_tokens: int = 0
    skill_catalog_tokens: int = 0
    skill_body_max_tokens_sum: int = 0
    display_limit: int = 0
    suggested_commands: list[str] = field(default_factory=list)


def try_tiktoken():
    try:
        import tiktoken  # type: ignore

        enc = tiktoken.get_encoding("o200k_base")
        return "tiktoken:o200k_base", lambda text: len(enc.encode(text))
    except Exception:
        return "approx:chars/4", lambda text: max(1, (len(text) + 3) // 4) if text else 0


def parse_frontmatter(text: str) -> tuple[dict[str, str], str]:
    m = FRONTMATTER_RE.match(text)
    if not m:
        return {}, text
    raw = m.group(1)
    body = text[m.end() :]
    data: dict[str, str] = {}

    # description: >- / | folded block
    dm = re.search(r"^description:\s*>-?\s*\n((?:[ \t]+.+\n?)+)", raw, re.M)
    if dm:
        data["description"] = " ".join(
            line.strip() for line in dm.group(1).splitlines() if line.strip()
        )
    else:
        dm2 = re.search(r"^description:\s*(.+)$", raw, re.M)
        if dm2:
            data["description"] = dm2.group(1).strip().strip('"').strip("'")

    for key in ("name", "alwaysApply", "globs"):
        km = re.search(rf"^{key}:\s*(.+)$", raw, re.M)
        if km:
            data[key] = km.group(1).strip().strip('"').strip("'")

    return data, body


def should_skip_dir(path: Path) -> bool:
    return path.name in SKIP_DIR_NAMES or path.name.startswith("iteration-")


def iter_files(root: Path, patterns: list[str]) -> list[Path]:
    found: list[Path] = []
    for pattern in patterns:
        for p in root.glob(pattern):
            if not p.is_file():
                continue
            if any(should_skip_dir(parent) for parent in p.parents):
                continue
            found.append(p)
    return sorted(set(found))


def discover_agents_md(root: Path) -> list[Path]:
    """ルート直下と、浅いサブツリーの AGENTS.md（深掘りしすぎない）。"""
    hits: list[Path] = []
    direct = root / "AGENTS.md"
    if direct.is_file():
        hits.append(direct)
    # multi-package: */AGENTS.md, */*/AGENTS.md 程度
    for pattern in ("*/AGENTS.md", "*/*/AGENTS.md"):
        for p in root.glob(pattern):
            if p.is_file() and not any(should_skip_dir(x) for x in p.parents):
                hits.append(p)
    return sorted(set(hits))


def discover_rules(root: Path) -> list[tuple[Path, dict[str, str], str]]:
    rows: list[tuple[Path, dict[str, str], str]] = []
    for p in iter_files(root, [".cursor/rules/**/*.mdc", ".cursor/rules/**/*.md"]):
        text = p.read_text(encoding="utf-8", errors="replace")
        fm, body = parse_frontmatter(text)
        rows.append((p, fm, text))
    legacy = root / ".cursorrules"
    if legacy.is_file():
        text = legacy.read_text(encoding="utf-8", errors="replace")
        rows.append((legacy, {"alwaysApply": "true"}, text))
    return rows


def discover_skills(roots: list[Path], include_user_skills: bool) -> list[Path]:
    skill_files: list[Path] = []
    search_roots = list(roots)
    if include_user_skills:
        home = Path.home()
        search_roots.extend(
            [
                home / ".cursor" / "skills",
                home / ".cursor" / "skills-cursor",
            ]
        )
    for root in search_roots:
        if not root.exists():
            continue
        # project skills
        for p in root.rglob("SKILL.md"):
            s = str(p)
            if any(
                part in s
                for part in (
                    "/iteration-",
                    "/eval-",
                    "/outputs/",
                    "/skill-snapshot/",
                    "/agent-skills-eval",
                )
            ):
                continue
            if any(should_skip_dir(x) for x in p.parents):
                continue
            # Prefer paths under .cursor/skills or installed-skills / .agents/skills
            skill_files.append(p)

        # also .cursor/skills relative to root
        cursor_skills = root / ".cursor" / "skills"
        if cursor_skills.is_dir():
            for p in cursor_skills.rglob("SKILL.md"):
                if "skill-snapshot" in str(p) or "iteration-" in str(p):
                    continue
                skill_files.append(p)

    # unique by resolved path; prefer non-snapshot already filtered
    uniq: dict[str, Path] = {}
    for p in skill_files:
        key = str(p.resolve())
        uniq[key] = p
    return sorted(uniq.values(), key=lambda x: str(x))


def dedupe_skills_by_name(skill_paths: list[Path]) -> list[tuple[str, Path, str, str]]:
    """name が同じなら短いパス／プロジェクト側を優先して1つにまとめる。"""
    by_name: dict[str, tuple[Path, str, str, dict]] = {}
    for p in skill_paths:
        text = p.read_text(encoding="utf-8", errors="replace")
        fm, body = parse_frontmatter(text)
        name = fm.get("name") or p.parent.name
        score = 0
        s = str(p)
        if "/.cursor/skills/" in s:
            score += 10
        if "skill-snapshot" in s:
            score -= 50
        prev = by_name.get(name)
        if prev is None or score > prev[3].get("score", 0):
            by_name[name] = (p, text, body, {"score": score, **fm})
    out = []
    for name, (p, text, body, fm) in sorted(by_name.items()):
        out.append((name, p, text, body))
    return out


def discover_documents(roots: list[Path]) -> list[Path]:
    """動的ロードされうるドキュメント（docs/ / doc/ / SKILL references）。"""
    found: list[Path] = []
    patterns = (
        "docs/**/*.md",
        "doc/**/*.md",
        ".cursor/skills/**/references/**/*.md",
        "**/docs/**/*.md",
        "**/doc/**/*.md",
    )
    for root in roots:
        if not root.exists():
            continue
        for pattern in patterns:
            for p in root.glob(pattern):
                if not p.is_file():
                    continue
                s = str(p)
                if any(
                    part in s
                    for part in (
                        "/iteration-",
                        "/eval-",
                        "/outputs/",
                        "/skill-snapshot/",
                        "/agent-skills-eval",
                        "/node_modules/",
                    )
                ):
                    continue
                if any(should_skip_dir(x) for x in p.parents):
                    continue
                found.append(p)
    uniq: dict[str, Path] = {}
    for p in found:
        uniq[str(p.resolve())] = p
    return sorted(uniq.values(), key=lambda x: str(x))


def build_report(
    roots: list[Path],
    include_user_skills: bool,
    top_skills: int,
) -> Report:
    tokenizer_name, count_tokens = try_tiktoken()
    suggested: list[str] = []
    if tokenizer_name.startswith("approx"):
        suggested.append(
            "python3 -m pip install tiktoken  # より良い概算（o200k_base）のため推奨"
        )
        suggested.append(
            "または: python3 -m venv /tmp/tokencount && "
            "/tmp/tokencount/bin/pip install tiktoken"
        )

    report = Report(
        tokenizer=tokenizer_name,
        accuracy_note=(
            "モデル固有トークナイザとは一致しない可能性がある。"
            "追加ロード無しのベースラインと、各 SKILL をフルロードした最大量の概算である。"
            "User Rules（Cursor Settings）やシステムプロンプト、ツール定義は含めない。"
        ),
        roots=[str(r.resolve()) for r in roots],
        suggested_commands=suggested,
    )

    # --- baseline: AGENTS.md + always-apply rules ---
    for root in roots:
        for agents in discover_agents_md(root):
            text = agents.read_text(encoding="utf-8", errors="replace")
            report.baseline.append(
                FileTokenRow(
                    category="AGENTS.md",
                    path=str(agents),
                    chars=len(text),
                    tokens=count_tokens(text),
                    note="Project Rules 全文",
                    filename=agents.name,
                )
            )
        for path, fm, text in discover_rules(root):
            always = fm.get("alwaysApply", "").lower()
            # .cursorrules は常時。mdc は alwaysApply: true のみベースライン。
            # alwaysApply 未指定の .mdc は Cursor 既定では常時でないことが多いが、
            # description だけがカタログに載るケースもある → body は常時扱いにしない。
            is_legacy = path.name == ".cursorrules"
            if is_legacy or always == "true":
                report.baseline.append(
                    FileTokenRow(
                        category="rule.always",
                        path=str(path),
                        chars=len(text),
                        tokens=count_tokens(text),
                        note="alwaysApply rule 全文",
                        filename=path.name,
                    )
                )
            else:
                desc = fm.get("description", "")
                if desc:
                    report.baseline.append(
                        FileTokenRow(
                            category="rule.catalog",
                            path=str(path),
                            chars=len(desc),
                            tokens=count_tokens(desc),
                            note="rule description のみ",
                            filename=path.name,
                        )
                    )

    report.baseline_tokens = sum(r.tokens for r in report.baseline)

    # --- skills ---
    skill_paths = discover_skills(roots, include_user_skills=include_user_skills)
    for name, path, text, body in dedupe_skills_by_name(skill_paths):
        fm, _ = parse_frontmatter(text)
        desc = fm.get("description", "")
        d_tok = count_tokens(desc)
        # 最大: frontmatter 含む SKILL.md 全体（トリガー時ロード想定）
        b_tok = count_tokens(text)
        report.skills.append(
            SkillRow(
                name=name,
                path=str(path),
                description_chars=len(desc),
                description_tokens=d_tok,
                body_chars=len(text),
                body_tokens=b_tok,
                total_chars=len(text),
                total_tokens=b_tok,
            )
        )

    report.skills.sort(key=lambda s: s.body_tokens, reverse=True)
    report.skill_catalog_tokens = sum(s.description_tokens for s in report.skills)
    report.skill_body_max_tokens_sum = sum(s.body_tokens for s in report.skills)

    # --- documents (docs / references) ---
    for doc_path in discover_documents(roots):
        text = doc_path.read_text(encoding="utf-8", errors="replace")
        path_norm = str(doc_path).replace("\\", "/")
        if "/references/" in path_norm:
            kind = "SKILL references"
        elif "/docs/" in path_norm:
            kind = "docs"
        elif "/doc/" in path_norm:
            kind = "doc"
        else:
            kind = "document"
        report.documents.append(
            TableRow(
                filename=doc_path.name,
                tokens=count_tokens(text),
                content=f"{kind} 全文（動的ロード時の最大）",
                path=str(doc_path),
                chars=len(text),
            )
        )
    report.documents.sort(key=lambda r: -r.tokens)

    # top_skills は動的セクションの表示件数のみ制限（デフォルトの description 一覧は全件）
    report.display_limit = top_skills if top_skills > 0 else 0

    report.suggested_commands.append(
        "python3 <SKILL_DIR>/scripts/count_workspace_tokens.py --root ."
    )
    report.suggested_commands.append(
        "python3 <SKILL_DIR>/scripts/count_workspace_tokens.py --root /path/to/repo --json"
    )
    return report


def _table_block(rows: list[TableRow]) -> list[str]:
    lines = [
        "| ファイル名 | トークン量 | 内容 | ファイルパス |",
        "| --- | ---: | --- | --- |",
    ]
    if not rows:
        lines.append("| （該当なし） | 0 | - | - |")
        return lines
    for row in rows:
        content = row.content.replace("|", "\\|")
        lines.append(
            f"| `{row.filename}` | {row.tokens} | {content} | `{row.path}` |"
        )
    return lines


def format_token_amount(tokens: int) -> str:
    """常にキロトークン表記（小数点以下第1位）。例: 698 -> 0.7K Tokens。"""
    n = max(0, int(tokens))
    return f"{n / 1_000:.1f}K Tokens"


def _section_stats(file_count: int, token_sum: int) -> list[str]:
    """assets/report.md の統計行。"""
    return [
        f"* ファイル数合計: {file_count}",
        f"* トークン量合計: {format_token_amount(token_sum)}",
        "",
    ]


def format_markdown(report: Report) -> str:
    """assets/report.md テンプレートに沿った Markdown を生成する。"""
    default_rows: list[TableRow] = []
    for row in sorted(report.baseline, key=lambda r: -r.tokens):
        default_rows.append(
            TableRow(
                filename=row.filename or Path(row.path).name,
                tokens=row.tokens,
                content=row.note or row.category,
                path=row.path,
                chars=row.chars,
            )
        )
    for s in sorted(report.skills, key=lambda x: -x.description_tokens):
        if s.description_tokens <= 0:
            continue
        default_rows.append(
            TableRow(
                filename=f"{s.name} (description)",
                tokens=s.description_tokens,
                content="SKILL description（常時カタログ）",
                path=s.path,
                chars=s.description_chars,
            )
        )
    default_rows.sort(key=lambda r: -r.tokens)

    skill_rows_all = [
        TableRow(
            filename=s.name,
            tokens=s.body_tokens,
            content="SKILL.md 全文（トリガー時の最大。他 SKILL からの追加ロードは含まない）",
            path=s.path,
            chars=s.body_chars,
        )
        for s in report.skills
    ]
    doc_rows_all = list(report.documents)

    skill_rows = skill_rows_all
    doc_rows = doc_rows_all
    if report.display_limit > 0:
        skill_rows = skill_rows_all[: report.display_limit]
        doc_rows = doc_rows_all[: report.display_limit]

    default_token_sum = report.baseline_tokens + report.skill_catalog_tokens
    skill_token_sum = report.skill_body_max_tokens_sum
    doc_token_sum = sum(r.tokens for r in doc_rows_all)

    lines: list[str] = []
    lines.append("# トークンレポート")
    lines.append("")
    lines.append(f"- tokenizer: `{report.tokenizer}`")
    lines.append(f"- note: {report.accuracy_note}")
    lines.append(f"- roots: {', '.join(f'`{r}`' for r in report.roots)}")
    lines.append("")
    lines.append("## システムトークン")
    lines.append("")
    lines.extend(_section_stats(len(default_rows), default_token_sum))
    lines.extend(_table_block(default_rows))
    lines.append("")
    lines.append("## 動的トークン / SKILL")
    lines.append("")
    lines.extend(_section_stats(len(skill_rows_all), skill_token_sum))
    if report.display_limit > 0 and len(skill_rows_all) > report.display_limit:
        lines.append(
            f"（表は上位 {report.display_limit} 件のみ。合計は全 {len(skill_rows_all)} 件）"
        )
        lines.append("")
    lines.extend(_table_block(skill_rows))
    lines.append("")
    lines.append("## 動的トークン / ドキュメント")
    lines.append("")
    lines.extend(_section_stats(len(doc_rows_all), doc_token_sum))
    if report.display_limit > 0 and len(doc_rows_all) > report.display_limit:
        lines.append(
            f"（表は上位 {report.display_limit} 件のみ。合計は全 {len(doc_rows_all)} 件）"
        )
        lines.append("")
    lines.extend(_table_block(doc_rows))
    lines.append("")
    if report.suggested_commands:
        lines.append("## 推奨コマンド")
        lines.append("")
        for cmd in report.suggested_commands:
            lines.append(f"- `{cmd}`")
        lines.append("")
    return "\n".join(lines)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Estimate Cursor workspace baseline / skill token usage."
    )
    parser.add_argument(
        "--root",
        action="append",
        default=[],
        help="Workspace root to scan (repeatable). Default: cwd",
    )
    parser.add_argument(
        "--include-user-skills",
        action="store_true",
        help="Also scan ~/.cursor/skills and ~/.cursor/skills-cursor",
    )
    parser.add_argument(
        "--top-skills",
        type=int,
        default=0,
        help="Only show top N skills by body tokens (0 = all)",
    )
    parser.add_argument("--json", action="store_true", help="Emit JSON instead of Markdown")
    args = parser.parse_args(argv)

    roots = [Path(r).resolve() for r in args.root] if args.root else [Path.cwd().resolve()]
    for r in roots:
        if not r.is_dir():
            print(f"error: not a directory: {r}", file=sys.stderr)
            return 2

    report = build_report(
        roots=roots,
        include_user_skills=args.include_user_skills,
        top_skills=args.top_skills,
    )

    if args.json:
        default_total = report.baseline_tokens + report.skill_catalog_tokens
        doc_total = sum(d.tokens for d in report.documents)
        payload = {
            "tokenizer": report.tokenizer,
            "accuracy_note": report.accuracy_note,
            "roots": report.roots,
            "baseline_tokens": report.baseline_tokens,
            "skill_catalog_tokens": report.skill_catalog_tokens,
            "baseline_total_tokens": default_total,
            "baseline_total_tokens_display": format_token_amount(default_total),
            "skill_body_max_tokens_sum": report.skill_body_max_tokens_sum,
            "skill_body_max_tokens_display": format_token_amount(
                report.skill_body_max_tokens_sum
            ),
            "documents_total_tokens": doc_total,
            "documents_total_tokens_display": format_token_amount(doc_total),
            "baseline": [asdict(x) for x in report.baseline],
            "skills": [asdict(x) for x in report.skills],
            "documents": [asdict(x) for x in report.documents],
            "suggested_commands": report.suggested_commands,
        }
        print(json.dumps(payload, ensure_ascii=False, indent=2))
    else:
        print(format_markdown(report))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
