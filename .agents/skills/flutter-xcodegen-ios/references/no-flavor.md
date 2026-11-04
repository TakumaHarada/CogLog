# Flavor なし構成

ユーザーが Flavor を指定していないときの既定。

## 作るもの

1. `Configurations/app.xcconfig`
2. `Configurations/Debug|Profile|Release/flavor.xcconfig`（各 Bundle ID / Profile を埋める）
3. `xcodegen/base.yml`（assets からコピー）
4. `xcodegen/default.yml`（assets からコピー）
5. `xcodegen/scripts/postGenCommand.sh` + workspace テンプレ
6. `project.yml` — `include` に `xcodegen/base.yml` と `xcodegen/default.yml`
7. `Exports/...` — Team ID / Bundle ID / Profile を埋める

## Scheme

`default.yml` の scheme 名は `Runner`。run/test は `Debug`、archive は `Release`。

## 後から Flavor を足す

[flavor.md](./flavor.md) に従い、`default.yml` を外して `{flavor}.yml` を追加し、Configuration ディレクトリを `{Type}-{flavor}` に移す。
