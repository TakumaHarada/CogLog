#!/usr/bin/env python3
"""ATX Markdown の見出し TOC（行範囲付き）と、範囲単位の本文抽出。

コードフェンス内の `#` 行は見出しとして扱わない。
終端は「同レベル以上の次見出しの直前」。既定で末尾空行を trim する。
同一内容（SHA-256）のファイルは、先に現れた 1 件だけを対象にする。
"""

from __future__ import annotations

import argparse
import hashlib
import re
import sys
from pathlib import Path

HEADING = re.compile(r"^(#{1,6}) (.+)$")
FENCE = re.compile(r"^(`{3,}|~{3,})")


def content_digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def collect_files(paths: list[str], *, pattern: str = "*.md") -> list[Path]:
    """ファイルはそのまま、ディレクトリは pattern で再帰収集（パス順）。"""
    out: list[Path] = []
    seen_path: set[Path] = set()
    for raw in paths:
        path = Path(raw)
        if path.is_file():
            resolved = path.resolve()
            if resolved not in seen_path:
                seen_path.add(resolved)
                out.append(path)
            continue
        if path.is_dir():
            for child in sorted(path.rglob(pattern)):
                if not child.is_file():
                    continue
                resolved = child.resolve()
                if resolved in seen_path:
                    continue
                seen_path.add(resolved)
                out.append(child)
            continue
        print(f"skip (not found): {path}", file=sys.stderr)
    return out


def filter_unique_by_digest(
    paths: list[Path],
    *,
    report_skips: bool,
) -> list[Path]:
    """内容ハッシュが同一なら先頭の 1 ファイルだけ残す。"""
    unique: list[Path] = []
    seen_digest: set[str] = set()
    for path in paths:
        try:
            digest = content_digest(path.read_bytes())
        except OSError as exc:
            print(f"skip (unreadable): {path}: {exc}", file=sys.stderr)
            continue
        if digest in seen_digest:
            if report_skips:
                print(f"skip (duplicate content): {path}", file=sys.stderr)
            continue
        seen_digest.add(digest)
        unique.append(path)
    return unique


def parse_headings(lines: list[str]) -> list[dict]:
    headings: list[dict] = []
    in_fence = False
    fence_char = ""
    fence_len = 0

    for i, line in enumerate(lines, start=1):
        fm = FENCE.match(line)
        if fm:
            mark = fm.group(1)
            if not in_fence:
                in_fence = True
                fence_char = mark[0]
                fence_len = len(mark)
            elif (
                mark[0] == fence_char
                and len(mark) >= fence_len
                and line.strip(fence_char) == ""
            ):
                in_fence = False
            continue
        if in_fence:
            continue
        hm = HEADING.match(line)
        if hm:
            headings.append(
                {
                    "start": i,
                    "level": len(hm.group(1)),
                    "title": line,
                }
            )
    return headings


def assign_ends(
    headings: list[dict],
    lines: list[str],
    *,
    trim: bool,
) -> list[dict]:
    n = len(lines)
    for i, h in enumerate(headings):
        end = n
        for nxt in headings[i + 1 :]:
            if nxt["level"] <= h["level"]:
                end = nxt["start"] - 1
                break
        if trim:
            while end > h["start"] and not lines[end - 1].strip():
                end -= 1
        h["end"] = end
    return headings


def load(path: Path) -> tuple[list[str], list[dict]]:
    data = path.read_bytes()
    text = data.decode("utf-8")
    lines = text.splitlines()
    return lines, parse_headings(lines)


def cmd_toc(args: argparse.Namespace) -> int:
    files = collect_files(args.paths, pattern=args.glob)
    if not args.keep_duplicates:
        files = filter_unique_by_digest(files, report_skips=True)
    for path in files:
        if not path.is_file():
            print(f"skip (not a file): {path}", file=sys.stderr)
            continue
        lines, headings = load(path)
        assign_ends(headings, lines, trim=not args.no_trim)
        for h in headings:
            if args.max_level is not None and h["level"] > args.max_level:
                continue
            if args.grep and args.grep not in h["title"]:
                continue
            print(f'{path}:{h["start"]}-{h["end"]}\t{h["title"]}')
    return 0


def cmd_unique(args: argparse.Namespace) -> int:
    files = collect_files(args.paths, pattern=args.glob)
    for path in filter_unique_by_digest(files, report_skips=args.verbose):
        print(path)
    return 0


def cmd_print(args: argparse.Namespace) -> int:
    path = Path(args.path)
    lines, headings = load(path)
    assign_ends(headings, lines, trim=not args.no_trim)

    start: int
    end: int

    if args.title is not None:
        hit = next((h for h in headings if args.title in h["title"]), None)
        if hit is None:
            print(f"heading not found: {args.title!r}", file=sys.stderr)
            return 1
        start, end = hit["start"], hit["end"]
    elif args.at is not None:
        hit = next((h for h in headings if h["start"] == args.at), None)
        if hit is None:
            print(f"no heading at line {args.at}", file=sys.stderr)
            return 1
        start, end = hit["start"], hit["end"]
    else:
        start = args.start
        if args.end is not None:
            end = args.end
        else:
            hit = next((h for h in headings if h["start"] == start), None)
            if hit is None:
                print(
                    f"no heading at line {start}; pass END or use --at/--title",
                    file=sys.stderr,
                )
                return 1
            end = hit["end"]

    if start < 1 or end < start or end > len(lines):
        print(f"invalid range: {start}-{end} (file has {len(lines)} lines)", file=sys.stderr)
        return 1

    sys.stdout.write("\n".join(lines[start - 1 : end]))
    if lines[start - 1 : end]:
        sys.stdout.write("\n")
    return 0


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="md_section.py",
        description="Markdown heading TOC with line ranges, and ranged section print.",
    )
    sub = p.add_subparsers(dest="command", required=True)

    toc = sub.add_parser("toc", help="List headings with path:start-end")
    toc.add_argument(
        "paths",
        nargs="+",
        help="Markdown files and/or directories (dirs are scanned with --glob)",
    )
    toc.add_argument(
        "--glob",
        default="*.md",
        help="When a path is a directory, collect matching files recursively (default: *.md)",
    )
    toc.add_argument(
        "--max-level",
        type=int,
        default=None,
        help="Include headings up to this level (1=# … 6=######)",
    )
    toc.add_argument(
        "--grep",
        default=None,
        help="Substring filter on heading title (e.g. 'DO NOT')",
    )
    toc.add_argument(
        "--no-trim",
        action="store_true",
        help="Keep trailing blank lines in ranges",
    )
    toc.add_argument(
        "--keep-duplicates",
        action="store_true",
        help="Do not skip files whose content SHA-256 matches an earlier file",
    )
    toc.set_defaults(func=cmd_toc)

    uniq = sub.add_parser(
        "unique",
        help="Print paths after dropping content-duplicate files (first wins)",
    )
    uniq.add_argument(
        "paths",
        nargs="+",
        help="Markdown files and/or directories (dirs are scanned with --glob)",
    )
    uniq.add_argument(
        "--glob",
        default="*.md",
        help="When a path is a directory, collect matching files recursively (default: *.md)",
    )
    uniq.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Report skipped duplicate-content paths on stderr",
    )
    uniq.set_defaults(func=cmd_unique)

    pr = sub.add_parser("print", help="Print a section by range or title")
    pr.add_argument("path", help="Markdown file")
    pr.add_argument(
        "start",
        nargs="?",
        type=int,
        default=None,
        help="Start line (heading line). END optional if start is a heading.",
    )
    pr.add_argument(
        "end",
        nargs="?",
        type=int,
        default=None,
        help="End line (inclusive)",
    )
    pr.add_argument("--at", type=int, default=None, help="Heading start line; auto end")
    pr.add_argument("--title", default=None, help="Substring match on heading title")
    pr.add_argument(
        "--no-trim",
        action="store_true",
        help="Keep trailing blank lines when resolving end from heading",
    )
    pr.set_defaults(func=cmd_print)

    return p


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    if args.command == "print":
        if args.title is None and args.at is None and args.start is None:
            parser.error("print requires START, --at, or --title")
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
