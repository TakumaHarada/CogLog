---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0037/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0037
masvs_category: MASVS-PLATFORM
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0037: Testing WebViews Cleanup

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing WebViews Cleanup」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: To test for WebViews cleanup you should inspect all APIs related to WebView data deletion and try to fully track the data deletion process.
* メタ: profiles: L2; covered_by: MASTG-TEST-0320; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0037/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing WebViews Cleanupのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing WebViews Cleanupのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing WebViews Cleanupのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Start by identifying the usage of the following WebView APIs and carefully validate the mentioned best practices.
* [Static] Initialization: an app might be initializing the WebView in a way to avoid storing certain information by using setDomStorageEnabled, setAppCacheEnabled or setDatabaseEnabled from android.webkit.WebSettings. ...
* [Static] Cache: Android's WebView class offers the clearCache "clearCache in WebViews") method which can be used to clear the cache for all WebViews used by the app. It receives a boolean input parameter (includeDiskF...
* [Static] WebStorage APIs: WebStorage.deleteAllData can be also used to clear all storage currently being used by the JavaScript storage APIs, including the Web SQL Database and the HTML5 Web Storage APIs.
* [Static] > Some apps will _need_ to enable the DOM storage in order to display some HTML5 sites that use local storage. This should be carefully investigated as this might contain sensitive data.
* [Dynamic] Open a WebView accessing sensitive data and then log out of the application. Access the application's storage container and make sure all WebView related files are deleted. The following files and folders ar...
* [Dynamic] app_webview
* [Dynamic] Cookies
合否（Evaluation）の要点:
* To test for WebViews cleanup you should inspect all APIs related to WebView data deletion and try to fully track the data deletion process.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0320
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
- MASTG-TEST-0037 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0037/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
