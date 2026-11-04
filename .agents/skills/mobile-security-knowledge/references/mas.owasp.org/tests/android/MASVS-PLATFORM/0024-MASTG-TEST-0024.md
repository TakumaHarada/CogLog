---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0024/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0024
masvs_category: MASVS-PLATFORM
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0024: Testing for App Permissions

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing for App Permissions」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: When testing app permissions the goal is to try and reduce the amount of permissions used by your app to the absolute minimum. While going through each permission, remember that it is best practice first to try and evaluate whether your app needs to use this permission because many functionalities such as taking a photo can be done without, limiting the amount of access to sensitive data. If permissions are required you will then make sure tha...
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0254; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0024/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing for App Permissionsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing for App Permissionsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing for App Permissionsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Check permissions to make sure that the app really needs them and remove unnecessary permissions. For example, the INTERNET permission in the AndroidManifest.xml file is necessary for an Activity to load a we...
* [Static] Go through the permissions with the developer to identify the purpose of every permission set and remove unnecessary permissions.
* [Static] Besides going through the AndroidManifest.xml file manually, you can also use the Android Asset Packaging tool (aapt) to examine the permissions of an APK file.
* [Static] > aapt comes with the Android SDK within the build-tools folder. It requires an APK file as input. You may list the APKs in the device by running adb shell pm list packages -f | grep -i as seen in MASTG-TECH-...
* [Static] $ aapt d permissions app-x86-debug.apk
* [Dynamic] Permissions for installed applications can be retrieved with adb. The following extract demonstrates how to examine the permissions used by an application.
* [Dynamic] $ adb shell dumpsys package com.google.android.youtube
* [Dynamic] declared permissions:
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0254
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 未使用入口をテスト対象外のまま放置する

* 理由: MASVS-PLATFORM の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 未使用入口をテスト対象外のまま放置する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0024 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0024/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
