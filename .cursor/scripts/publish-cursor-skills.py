#!/usr/bin/env python3
"""Copy APM skills and commands into ~/.cursor/skills without committing them.

Only directories recorded in this repository's manifest are replaced or
removed. Skills owned by another repository stay in place. A matching marker
is how `python3 .cursor/scripts/publish-cursor-skills.py --check` decides that
the current repository's commands are ready.
"""

from __future__ import annotations

import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


def yaml_quote(value: str) -> str:
    collapsed = " ".join(value.split())
    escaped = collapsed.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{escaped}"'


def frontmatter(text: str) -> tuple[str, str] | None:
    if not text.startswith("---\n"):
        return None
    end = text.find("\n---\n", 4)
    if end < 0:
        return None
    return text[4:end], text[end + 5 :]


def field(fm: str, key: str) -> str | None:
    lines = fm.splitlines()
    for index, line in enumerate(lines):
        if not line.startswith(f"{key}:"):
            continue
        rest = line.split(":", 1)[1].strip()
        chunks: list[str] = []
        if rest not in {">", ">-", "|", "|-"} and rest:
            chunks.append(rest.strip("\"'"))
        for follower in lines[index + 1 :]:
            if follower.startswith((" ", "\t")):
                chunks.append(follower.strip())
                continue
            break
        return " ".join(chunks)
    return None


def skill_name(raw: str) -> str:
    return re.sub(r"[^a-z0-9-]+", "-", raw.lower()).strip("-")


def set_name(fm: str, name: str) -> str:
    if re.search(r"(?m)^name:", fm):
        return re.sub(r"(?m)^name:.*$", f"name: {name}", fm, count=1)
    return f"name: {name}\n{fm}"


def repository_id(root: Path) -> str:
    try:
        url = subprocess.check_output(
            ["git", "-C", str(root), "remote", "get-url", "origin"],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        url = root.resolve().as_posix()
    url = re.sub(r"://[^/@]+@", "://", url)
    return re.sub(r"\.git$", "", url)


def apm_yml_sha256(root: Path) -> str:
    return hashlib.sha256((root / "apm.yml").read_bytes()).hexdigest()


def expected_commands(root: Path) -> list[str]:
    commands = root / ".cursor" / "commands"
    if not commands.is_dir():
        return []
    names: list[str] = []
    for path in sorted(commands.glob("*.md")):
        name = skill_name(path.stem)
        if name:
            names.append(name)
    return names


def manifest_path(repo: str) -> Path:
    digest = hashlib.sha256(repo.encode()).hexdigest()
    return Path.home() / ".cursor" / "apm-skill-manifests" / f"{digest}.json"


def load_manifest(path: Path) -> dict[str, object]:
    if not path.is_file():
        return {}
    try:
        loaded = json.loads(path.read_text())
    except json.JSONDecodeError:
        return {}
    return loaded if isinstance(loaded, dict) else {}


def owned_names(manifest: dict[str, object]) -> set[str]:
    raw = manifest.get("owned", [])
    if not isinstance(raw, list):
        return set()
    return {name for name in raw if isinstance(name, str) and name}


def publish(root: Path, dest: Path) -> int:
    skills = root / ".agents" / "skills"
    commands = root / ".cursor" / "commands"
    dest.mkdir(parents=True, exist_ok=True)
    for child in dest.iterdir():
        if child.is_dir():
            shutil.rmtree(child)
        else:
            child.unlink()

    if skills.is_dir():
        for child in skills.iterdir():
            target = dest / child.name
            if child.is_dir():
                shutil.copytree(child, target)
            else:
                shutil.copy2(child, target)

    for skill_md in list(dest.glob("*/SKILL.md")):
        parsed = frontmatter(skill_md.read_text())
        if parsed is None:
            continue
        fm, body = parsed
        current = field(fm, "name") or skill_md.parent.name
        fixed = skill_name(current)
        if not fixed:
            continue
        if fixed == skill_md.parent.name and current == fixed:
            continue
        rewritten = f"---\n{set_name(fm, fixed)}\n---\n{body}"
        target = dest / fixed
        if target.resolve() != skill_md.parent.resolve():
            if target.exists():
                shutil.rmtree(target)
            target.mkdir()
            for child in skill_md.parent.iterdir():
                if child.name == "SKILL.md":
                    continue
                shutil.move(str(child), target / child.name)
            (target / "SKILL.md").write_text(rewritten)
            shutil.rmtree(skill_md.parent)
        else:
            skill_md.write_text(rewritten)

    if commands.is_dir():
        for path in sorted(commands.glob("*.md")):
            text = path.read_text()
            parsed = frontmatter(text)
            description = path.stem
            body = text
            if parsed is not None:
                fm, body = parsed
                description = field(fm, "description") or description
            name = skill_name(path.stem)
            if not name:
                continue
            out = dest / name
            out.mkdir(parents=True, exist_ok=True)
            (out / "SKILL.md").write_text(
                "---\n"
                f"name: {name}\n"
                f"description: {yaml_quote(description)}\n"
                "disable-model-invocation: true\n"
                "---\n"
                f"{body}"
            )

    return sum(1 for _ in dest.glob("*/SKILL.md"))


def replace_owned(source: Path, target: Path) -> None:
    if target.is_dir() and not target.is_symlink():
        shutil.rmtree(target)
    elif target.exists() or target.is_symlink():
        target.unlink()
    if source.is_dir():
        shutil.copytree(source, target)
    else:
        shutil.copy2(source, target)


def sync_home(root: Path) -> tuple[int, list[str]]:
    home = Path.home() / ".cursor" / "skills"
    home.mkdir(parents=True, exist_ok=True)
    repo = repository_id(root)
    marker = manifest_path(repo)
    previous = owned_names(load_manifest(marker))
    with tempfile.TemporaryDirectory(prefix="apm-skills-") as tmp:
        staged = Path(tmp) / "skills"
        count = publish(root, staged)
        new_names = {child.name for child in staged.iterdir()}
        for name in sorted(previous - new_names):
            target = home / name
            if target.is_dir() and not target.is_symlink():
                shutil.rmtree(target)
            elif target.exists() or target.is_symlink():
                target.unlink()
        for name in sorted(new_names):
            replace_owned(staged / name, home / name)
    commands = expected_commands(root)
    marker.parent.mkdir(parents=True, exist_ok=True)
    marker.write_text(
        json.dumps(
            {
                "repository": repo,
                "apm_yml_sha256": apm_yml_sha256(root),
                "commands": commands,
                "owned": sorted(new_names),
            },
            indent=2,
        )
        + "\n"
    )
    return count, commands


def is_ready(root: Path) -> bool:
    if not (root / "apm.yml").is_file():
        return False
    repo = repository_id(root)
    manifest = load_manifest(manifest_path(repo))
    if manifest.get("repository") != repo:
        return False
    if manifest.get("apm_yml_sha256") != apm_yml_sha256(root):
        return False
    commands = expected_commands(root)
    if manifest.get("commands") != commands:
        return False
    home = Path.home() / ".cursor" / "skills"
    for name in commands:
        if not (home / name / "SKILL.md").is_file():
            return False
    return all((home / name).exists() for name in owned_names(manifest))


def main() -> int:
    args = sys.argv[1:]
    check = False
    if args and args[0] == "--check":
        check = True
        args = args[1:]
    root = Path(args[0]).resolve() if args else Path.cwd()
    if check:
        if not is_ready(root):
            print("not-ready", file=sys.stderr)
            return 1
        print("ready")
        print("commands: " + " ".join(expected_commands(root)))
        return 0
    count, commands = sync_home(root)
    print(f"published {count} skills to {Path.home() / '.cursor' / 'skills'}")
    print("commands: " + " ".join(commands))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
