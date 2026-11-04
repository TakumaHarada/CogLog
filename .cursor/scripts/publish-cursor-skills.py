#!/usr/bin/env python3
"""Copy APM skills and commands into ~/.cursor/skills without committing them.

Cloud Agents read this home directory at chat start. The repository copies stay
gitignored. Command files become explicit slash skills.
"""

from __future__ import annotations

import re
import shutil
import sys
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


def main() -> int:
    root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path.cwd()
    dest = Path.home() / ".cursor" / "skills"
    count = publish(root, dest)
    print(f"published {count} skills to {dest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
