---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0029/
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
mastg_test_id: MASTG-TEST-0029
masvs_category: MASVS-PLATFORM
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0029: Testing for Sensitive Functionality Exposure Through IPC

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing for Sensitive Functionality Exposure Through IPC」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: To test for sensitive functionality exposure through IPC mechanisms you should first enumerate all the IPC mechanisms the app uses and then try to identify whether sensitive data is leaked when the mechanisms are used.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0364, MASTG-TEST-0365, MASTG-TEST-0366; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0029/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing for Sensitive Functionality Exposure Through IPCのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing for Sensitive Functionality Exposure Through IPCのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing for Sensitive Functionality Exposure Through IPCのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] We start by looking at the AndroidManifest.xml, where all activities, services, and content providers included in the app must be declared (otherwise the system won't recognize them and they won't run).
* [Dynamic] You can enumerate IPC components with MASTG-TOOL-0035. To list all exported IPC components, upload the APK file and the components collection will be displayed in the following screen:
* [Dynamic] The "Sieve" application implements a vulnerable content provider. To list the content providers exported by the Sieve app, execute the following command:
* [Dynamic] $ adb shell dumpsys package com.mwr.example.sieve | grep -Po "Provider{[\w\d\s\./]+}" | sort -u
* [Dynamic] Provider{34a20d5 com.mwr.example.sieve/.FileBackupProvider}
* [Dynamic] Provider{64f10ea com.mwr.example.sieve/.DBContentProvider}
合否（Evaluation）の要点:
* To test for sensitive functionality exposure through IPC mechanisms you should first enumerate all the IPC mechanisms the app uses and then try to identify whether sensitive data is leaked when the mechanisms are used.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0364, MASTG-TEST-0365, MASTG-TEST-0366
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
- MASTG-TEST-0029 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0029/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
