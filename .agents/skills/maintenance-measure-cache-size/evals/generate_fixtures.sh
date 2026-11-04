#!/usr/bin/env bash
# Generate eval fixtures under evals/files/ (gitignored).
# Sparse files: almost no disk blocks, but du -Ah reports apparent GiB sizes.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
FILES="$ROOT/files"
TEMPLATES="$ROOT/templates"
HOME_ROOT="$FILES/fake-home"

rm -rf "$FILES"
mkdir -p \
  "$HOME_ROOT/.npm/_cacache" \
  "$HOME_ROOT/.gradle/caches" \
  "$HOME_ROOT/.pub-cache/hosted" \
  "$HOME_ROOT/.cache/tiny" \
  "$HOME_ROOT/Library/Caches/Homebrew" \
  "$HOME_ROOT/Library/Caches/com.apple.Safari" \
  "$HOME_ROOT/workspace/build" \
  "$HOME_ROOT/Documents/notes"

sparse() {
  local path="$1"
  local bytes="$2"
  mkdir -p "$(dirname "$path")"
  dd if=/dev/zero of="$path" bs=1 count=0 seek="$bytes" status=none 2>/dev/null \
    || dd if=/dev/zero of="$path" bs=1 count=0 seek="$bytes" 2>/dev/null
}

# Sizes chosen for 1GiB exclude + drill-down rules
sparse "$HOME_ROOT/.npm/_cacache/data.bin" $((2500 * 1024 * 1024))
sparse "$HOME_ROOT/.gradle/caches/modules.bin" $((1800 * 1024 * 1024))
sparse "$HOME_ROOT/.pub-cache/hosted/pkg.bin" $((1200 * 1024 * 1024))
sparse "$HOME_ROOT/Library/Caches/Homebrew/downloads.bin" $((400 * 1024 * 1024))
sparse "$HOME_ROOT/Library/Caches/com.apple.Safari/web.bin" $((50 * 1024 * 1024))
sparse "$HOME_ROOT/.cache/tiny/x.bin" $((10 * 1024 * 1024))
sparse "$HOME_ROOT/workspace/build/artifacts.bin" $((3500 * 1024 * 1024))
printf 'memo\n' > "$HOME_ROOT/Documents/notes/readme.txt"

cp "$TEMPLATES/docker-system-df.txt" "$FILES/docker-system-df.txt"

echo "Generated fixtures under: $FILES"
echo "  fake-home/  (use du -Ah for apparent size on macOS)"
echo "  docker-system-df.txt"
if command -v du >/dev/null 2>&1; then
  echo "--- du -Ah -d 1 fake-home ---"
  du -Ah -d 1 "$HOME_ROOT" 2>/dev/null | sort -hr | head -20 || true
fi
