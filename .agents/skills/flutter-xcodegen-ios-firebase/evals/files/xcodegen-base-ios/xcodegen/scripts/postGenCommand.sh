#!/bin/bash -eu

IOS_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

# Flutter SPM: ephemeral が無いと Xcode が SPM 解決に失敗する。
SPM_PACKAGE="${IOS_DIR}/Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage/Package.swift"
if [[ ! -f "${SPM_PACKAGE}" ]]; then
  echo "error: ${SPM_PACKAGE} does not exist." >&2
  exit 1
fi

# Pods なし workspace（Runner.xcodeproj のみ）
WORKSPACE_DIR="${IOS_DIR}/Runner.xcworkspace"
WORKSPACE_DATA="${WORKSPACE_DIR}/contents.xcworkspacedata"
TEMPLATE="${IOS_DIR}/xcodegen/Runner.xcworkspace/contents.xcworkspacedata"
mkdir -p "${WORKSPACE_DIR}"
cp "${TEMPLATE}" "${WORKSPACE_DATA}"
