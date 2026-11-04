#! /bin/bash -eu

echo "Pre Build Script" > pre-build-google-service-info-plist.log
echo "ENV: $(env)" >> pre-build-google-service-info-plist.log

# CONFIGURATION に対応した GoogleService-Info.plist をアプリバンドルへコピー
SRC="${PROJECT_DIR}/Configurations/${CONFIGURATION}/GoogleService-Info.plist"
DEST="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/GoogleService-Info.plist"

if [[ ! -f "${SRC}" ]]; then
  echo "error: ${SRC} not found" >&2
  exit 1
fi

mkdir -p "$(dirname "${DEST}")"
cp -f "${SRC}" "${DEST}"
