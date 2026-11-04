---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0032/
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
mastg_test_id: MASTG-TEST-0032
masvs_category: MASVS-PLATFORM
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0032: Testing WebView Protocol Handlers

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing WebView Protocol Handlers」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: To test for WebView protocol handlers (or resource access) check the app for WebView usage and evaluate whether or not the WebView should have resource access. If resource access is necessary you need to verify that it's implemented following best practices.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0250, MASTG-TEST-0251, MASTG-TEST-0252, MASTG-TEST-0253; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0032/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing WebView Protocol Handlersのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing WebView Protocol Handlersのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing WebView Protocol Handlersのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Check the source code for WebView usage. The following WebView settings control resource access:
* [Static] setAllowContentAccess: Content URL access allows WebViews to load content from a content provider installed on the system, which is enabled by default .
* [Static] setAllowFileAccess: Enables and disables file access within a WebView. The default value is true when targeting Android 10 (API level 29) and below and false for Android 11 (API level 30) and above. Note that...
* [Static] setAllowFileAccessFromFileURLs: Does or does not allow JavaScript running in the context of a file scheme URL to access content from other file scheme URLs. The default value is true for Android 4.0.3 - 4.0.4...
* [Static] setAllowUniversalAccessFromFileURLs: Does or does not allow JavaScript running in the context of a file scheme URL to access content from any origin. The default value is true for Android 4.0.3 - 4.0.4 (API l...
* [Dynamic] To identify the usage of protocol handlers, look for ways to trigger phone calls and ways to access files from the file system while you're using the app.
合否（Evaluation）の要点:
* To test for WebView protocol handlers (or resource access) check the app for WebView usage and evaluate whether or not the WebView should have resource access. If resource access is necessary you need to verify that i...
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0250, MASTG-TEST-0251, MASTG-TEST-0252, MASTG-TEST-0253
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
- MASTG-TEST-0032 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0032/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
