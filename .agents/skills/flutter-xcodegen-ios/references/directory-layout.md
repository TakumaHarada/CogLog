# ディレクトリ構成

`ios/` 直下の目標レイアウト（`Runner/` は Flutter 標準のまま）。

```text
ios/
├── Configurations/
│   ├── app.xcconfig                 # 共通
│   ├── {flavor}.xcconfig            # Flavor ありのときだけ
│   ├── Debug/                       # Flavor なし
│   │   └── flavor.xcconfig
│   ├── Profile/
│   │   └── flavor.xcconfig
│   ├── Release/
│   │   └── flavor.xcconfig
│   └── {Debug|Profile|Release}-{flavor}/   # Flavor あり
│       └── flavor.xcconfig
├── Exports/
│   ├── Production/
│   │   └── appstore.plist           # App Store / method=app-store
│   └── Development/
│       └── adhoc.plist              # Ad Hoc / method=ad-hoc
├── xcodegen/
│   ├── base.yml
│   ├── default.yml                  # Flavor なし
│   ├── {flavor}.yml                 # Flavor あり（Flavor ごと）
│   ├── scripts/
│   │   └── postGenCommand.sh
│   └── Runner.xcworkspace/
│       └── contents.xcworkspacedata
├── project.yml                      # XcodeGen エントリ
├── Runner/                          # 既存（本 SKILL では新規作成しない）
└── Flutter/                         # Flutter 生成物（触らない）
```

## Configuration 名の規則

| モード | Xcode Configuration 名 |
| --- | --- |
| Flavor なし | `Debug` / `Profile` / `Release` |
| Flavor あり | `Debug-{flavor}` / `Profile-{flavor}` / `Release-{flavor}` |

xcconfig の実体は常に `Configurations/<Configuration名>/flavor.xcconfig`。

## Exports と IPA

`flutter build ipa` の Release では `--export-options-plist` に Exports 配下を渡す。

* App Store: `Exports/Production/appstore.plist`（`method` = `app-store`）
* Ad Hoc: `Exports/Development/adhoc.plist`（`method` = `ad-hoc`）

`provisioningProfiles` のキーは **Bundle Identifier**、値は **プロファイル名**。`teamID` は必須入力の Team ID。ディレクトリ名（Production / Development）は配信チャネル用で、Flavor 名と一致させなくてよい（一致させてもよい）。
