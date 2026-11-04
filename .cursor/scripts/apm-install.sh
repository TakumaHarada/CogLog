#!/usr/bin/env bash
# Install the APM CLI if needed, then materialize Cursor skills from apm.yml.
# Generated trees (.agents, apm_modules, apm.lock.yaml, .cursor agents/commands)
# stay untracked. Safe to run on every VM boot.
set -euo pipefail

log() {
  printf '%s\n' "$*"
}

install_apm_cli() {
  local launcher="${HOME}/.local/bin/apm"
  if [[ ! -x "${launcher}" && ! -x /usr/local/bin/apm ]]; then
    curl -fsSL https://aka.ms/apm-unix | APM_NO_MODIFY_PATH=1 sh
  fi
  if [[ -x "${launcher}" && ! -e /usr/local/bin/apm ]]; then
    if [[ -w /usr/local/bin ]]; then
      ln -sfn "${launcher}" /usr/local/bin/apm
    else
      sudo ln -sfn "${launcher}" /usr/local/bin/apm
    fi
  fi
  # Login shells on this image do not load ~/.local/bin.
  export PATH="/usr/local/bin:${HOME}/.local/bin:${PATH}"
  if ! command -v apm >/dev/null 2>&1; then
    log "apm is not on PATH after install"
    exit 1
  fi
}

# Cloud Agent git config rewrites GitHub URLs to credentialed https:// URLs.
# APM refuses those url.*.insteadOf rules. This copy is process-local.
sanitize_git_config() {
  local src="${GIT_CONFIG_GLOBAL:-${HOME}/.gitconfig}"
  local dst
  dst="$(mktemp)"
  python3 - "${src}" "${dst}" <<'PY'
import sys
from pathlib import Path

src, dst = sys.argv[1], sys.argv[2]
text = Path(src).read_text() if Path(src).is_file() else ""
lines = text.splitlines(keepends=True)
out = []
i = 0
while i < len(lines):
    line = lines[i]
    if line.startswith("[url "):
        header = line
        i += 1
        body = []
        while i < len(lines) and not lines[i].startswith("["):
            body.append(lines[i])
            i += 1
        # Drop replacements that embed credentials (userinfo@host).
        if "://" in header and "@" in header.split("://", 1)[-1]:
            continue
        out.append(header)
        out.extend(body)
        continue
    out.append(line)
    i += 1
Path(dst).write_text("".join(out))
PY
  export GIT_CONFIG_GLOBAL="${dst}"
  unset GIT_CONFIG_COUNT || true
}

install_apm_cli

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${root}"

if [[ ! -f apm.yml ]]; then
  log "apm.yml is absent; skipping apm install"
  exit 0
fi

sanitize_git_config
apm install --target cursor --https

# Cloud Agents load ~/.cursor/skills at chat start. Repository copies stay gitignored.
python3 "${root}/.cursor/scripts/publish-cursor-skills.py" "${root}"
