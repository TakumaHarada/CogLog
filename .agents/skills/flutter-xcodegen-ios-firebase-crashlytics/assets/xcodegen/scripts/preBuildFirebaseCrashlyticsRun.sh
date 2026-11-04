#! /bin/bash -eu

# Flutter CLI は SPM を build/ios/SourcePackages に置く。
# Xcode IDE ビルドは DerivedData 配下を使うため、両方を探索する。
CANDIDATES=(
  "${PROJECT_DIR}/../build/ios/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"
  "${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"
)

RUN_SCRIPT=""
for candidate in "${CANDIDATES[@]}"; do
  if [[ -x "${candidate}" ]] || [[ -f "${candidate}" ]]; then
    RUN_SCRIPT="${candidate}"
    break
  fi
done

if [[ -z "${RUN_SCRIPT}" ]]; then
  echo "error: Firebase Crashlytics run script not found. Tried:" >&2
  for candidate in "${CANDIDATES[@]}"; do
    echo "  - ${candidate}" >&2
  done
  exit 1
fi

echo "Using Crashlytics run script: ${RUN_SCRIPT}"
"${RUN_SCRIPT}"
