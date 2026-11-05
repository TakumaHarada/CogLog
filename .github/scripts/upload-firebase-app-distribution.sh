#!/usr/bin/env bash
# Firebase App Distribution へ APK または IPA をアップロードする。
# 必須の環境変数: FIREBASE_SERVICE_ACCOUNT_JSON, FIREBASE_APP_ID,
# TESTER_GROUPS, FLAVOR, FIREBASE_TOOLS_VERSION
set -euo pipefail

artifact="${1:?成果物のパスを指定してください}"

if [ ! -f "$artifact" ]; then
  echo "成果物がありません: ${artifact}" >&2
  exit 1
fi

if [ -z "${FIREBASE_SERVICE_ACCOUNT_JSON:-}" ]; then
  echo "FIREBASE_SERVICE_ACCOUNT_JSON が空です。" >&2
  exit 1
fi

if [ -z "${FIREBASE_APP_ID:-}" ]; then
  echo "FIREBASE_APP_ID が空です。" >&2
  exit 1
fi

if [ -z "${TESTER_GROUPS:-}" ]; then
  echo "TESTER_GROUPS が空です。" >&2
  exit 1
fi

node -e 'const major = Number(process.versions.node.split(".")[0]); if (major < 20) { console.error("Node.js 20 以降が必要です"); process.exit(1); }'

umask 077
credentials="${RUNNER_TEMP:-/tmp}/firebase-service-account.json"
printf '%s\n' "$FIREBASE_SERVICE_ACCOUNT_JSON" > "$credentials"
export GOOGLE_APPLICATION_CREDENTIALS="$credentials"

notes="${RUNNER_TEMP:-/tmp}/firebase-release-notes.txt"
{
  echo "flavor: ${FLAVOR}"
  echo "commit: $(git rev-parse HEAD)"
  echo
  git log -1 --pretty=format:'%s'
  echo
  echo
  echo "${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}"
} > "$notes"

tool_dir="${RUNNER_TEMP:-/tmp}/firebase-tools"
mkdir -p "$tool_dir"
npm install --prefix "$tool_dir" --no-fund --no-audit "firebase-tools@${FIREBASE_TOOLS_VERSION}"
"${tool_dir}/node_modules/.bin/firebase" appdistribution:distribute "$artifact" \
  --app "$FIREBASE_APP_ID" \
  --groups "$TESTER_GROUPS" \
  --release-notes-file "$notes"

rm -f "$credentials"
