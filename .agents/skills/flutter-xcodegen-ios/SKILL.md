---
name: flutter-xcodegen-ios
description: >-
  Flutter 標準の ios/ を XcodeGen 構成へ移行・整備する SKILL。Configurations（xcconfig）と
  xcodegen/*.yml・project.yml・Exports（export-options-plist）をテンプレから生成・追加する。
  「xcodegen に移行」「iOS Flavor を xcodegen で」「Bundle ID / Provisioning を xcconfig に」
  「flutter build ipa の --export-options-plist」「Flavor なしの Debug/Profile/Release だけ」
  「Flavor を増やす」では必ず使う。Firebase / Crashlytics / Google Sign-In は
  flutter-xcodegen-ios-firebase 系に譲る。Pods は扱わない。Runner/ ソースの新規作成は対象外
  （flutter create 後の移行が前提）。
---
# Flutter iOS / XcodeGen 移行

`flutter create` 等でできた標準 `ios/` を、**XcodeGen 管理**へ移す。
`Runner/` のアプリソースは触らず、`Configurations/`・`xcodegen/`・`project.yml`・`Exports/` を整備する。

## いつ使うか

* 標準 `ios/` を XcodeGen に移行する
* Flavor なし（`Debug` / `Profile` / `Release`）または Flavor あり構成を作る
* Flavor を後から追加する
* Bundle Identifier / Provisioning Profile / export-options-plist を揃える

## 前提と必須入力

ユーザーは先に Flutter 標準機能で `ios/` を用意している前提。

次が **指示に無い場合は推測せずエラーで止める**:

* 各 Configuration（または Flavor × Debug/Profile/Release）の **Bundle Identifier**
* 各 Configuration の **Provisioning Profile**（`PROVISIONING_PROFILE_SPECIFIER`）
* IPA 出力時に使う **Team ID**（`Exports/*.plist` の `teamID`）と、プロファイル対応表

任意（無ければ質問する）:

* Flavor 名の一覧（無指定 → **Flavor なし**）
* `PRODUCT_NAME` / 表示名
* iOS deployment target（テンプレの `__IOS_DEPLOYMENT_TARGET__`）
* `DEVELOPMENT_TEAM`（`xcodegen` 実行時の環境変数 `${DEVELOPMENT_TEAM}`）

## 作業手順

1. 必須入力が揃っているか確認する。欠けていれば不足項目を列挙して停止する
2. Flavor 有無を確定する（無指定 → Flavor なし）
3. [references/directory-layout.md](./references/directory-layout.md) を読む
4. Flavor なしなら [references/no-flavor.md](./references/no-flavor.md)、ありなら [references/flavor.md](./references/flavor.md) を読む
5. `./assets/` のテンプレを `ios/` へコピーし、プレースホルダ（`__…__`）を実値に置換する
6. `project.yml` の `include` を Flavor 有無に合わせて直す
7. `postGenCommand.sh` に実行権限を付ける
8. `xcodegen` を `ios/` で実行する（`DEVELOPMENT_TEAM` を環境変数で渡す）
9. Release IPA は `flutter build ipa --export-options-plist <Exports の plist>` で出す旨をユーザーに伝える

コマンド実行時は、プロジェクト規定のツールチェイン（あれば）に従う。

```bash
# 例（ios/ で）
DEVELOPMENT_TEAM=__TEAM_ID__ xcodegen

# Release IPA
flutter build ipa --flavor __FLAVOR__ --release --export-options-plist ios/Exports/Production/appstore.plist
```

Flavor なしなら `--flavor` は付けない。Ad Hoc なら `Exports/Development/adhoc.plist` を使う。

## プレースホルダ

| 記号 | 意味 |
| --- | --- |
| `__PRODUCT_NAME__` | Xcode PRODUCT_NAME |
| `__BUNDLE_IDENTIFIER__` | Configuration ごとの Bundle ID |
| `__PROVISIONING_PROFILE_SPECIFIER__` | プロファイル名 |
| `__CODE_SIGN_IDENTITY__` | 例: `iPhone Developer` / `iPhone Distribution` |
| `__FLAVOR__` | Flavor 名（`development` 等） |
| `__TEAM_ID__` | Apple Team ID |
| `__IOS_DEPLOYMENT_TARGET__` | 例: `18.0` |

## SPM と CoreGraphics

`packages` に SPM を足したあと、実質依存が空に近いと解決に失敗することがある。
テンプレどおり **`CoreGraphics.framework` を `dependencies` に残す**。外さない。

## Pods

CocoaPods / `Pods_Runner` / Pods 用 Build Phase は **追加しない**（legacy）。

## 拡張 SKILL

| やりたいこと | SKILL |
| --- | --- |
| Firebase SPM + GoogleService-Info | `flutter-xcodegen-ios-firebase` |
| Crashlytics シンボルアップロード | `flutter-xcodegen-ios-firebase-crashlytics` |
| Google Sign-In（GID / URL Scheme） | `flutter-xcodegen-ios-google-sign-in` |

## アセット一覧

* [Configurations/](./assets/Configurations/) — xcconfig テンプレ
* [xcodegen/](./assets/xcodegen/) — `base.yml` / `default.yml` / `flavor.yml` / scripts / workspace
* [project.yml](./assets/project.yml)
* [Exports/](./assets/Exports/) — `appstore.plist` / `adhoc.plist`
