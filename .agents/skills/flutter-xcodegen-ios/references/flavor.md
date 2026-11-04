# Flavor あり構成

## 作るもの（Flavor ごと）

1. `Configurations/{flavor}.xcconfig`（`app.xcconfig` を include）
2. `Configurations/Debug-{flavor}/flavor.xcconfig` ほか Profile / Release
3. `xcodegen/{flavor}.yml` — assets の `flavor.yml` で `__FLAVOR__` を置換
4. `project.yml` の `include` に `xcodegen/{flavor}.yml` を列挙（`default.yml` は使わない）

## CODE_SIGN_IDENTITY の目安

| Build Type | よく使う値 |
| --- | --- |
| Debug / Profile | `iPhone Developer` |
| Release | `iPhone Distribution` |

ユーザー指定があればそれに従う。

## Scheme

scheme 名 = Flavor 名。archive の config は `Release-{flavor}`。

## Flavor 追加

既存の `{flavor}.yml` と同型で新しい Flavor を複製し、xcconfig・Exports（必要なら）・`project.yml` の include を更新する。Bundle ID / Profile が無ければエラーで止める。
