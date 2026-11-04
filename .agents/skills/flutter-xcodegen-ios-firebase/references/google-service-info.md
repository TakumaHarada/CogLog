# GoogleService-Info.plist 配置

## パス規則

```text
ios/Configurations/<CONFIGURATION>/GoogleService-Info.plist
```

`<CONFIGURATION>` は Xcode の Configuration 名そのもの。

| 構成 | 例 |
| --- | --- |
| Flavor なし | `Debug` / `Profile` / `Release` |
| Flavor あり | `Debug-development` / `Release-production` など |

## pre-build スクリプト

`xcodegen/scripts/preBuildInstallGoogleServiceInfoPlist.sh` がビルド時に次を行う。

* コピー元: `${PROJECT_DIR}/Configurations/${CONFIGURATION}/GoogleService-Info.plist`
* コピー先: アプリバンドル内の `GoogleService-Info.plist`

ファイルが無い場合は **ビルド失敗**（exit 1）。欠けた Configuration を残さない。

## project.yml

```yaml
preBuildScripts:
  - name: "[APP] Install GoogleService-Info.plist"
    script: "${PROJECT_DIR}/xcodegen/scripts/preBuildInstallGoogleServiceInfoPlist.sh"
    basedOnDependencyAnalysis: false
```

Flutter Run Script より前に置くと失敗時に分かりやすい。
