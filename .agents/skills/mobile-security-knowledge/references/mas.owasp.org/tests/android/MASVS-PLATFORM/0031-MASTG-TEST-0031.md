---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0031/
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
mastg_test_id: MASTG-TEST-0031
masvs_category: MASVS-PLATFORM
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0031: Testing JavaScript Execution in WebViews

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing JavaScript Execution in WebViews」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: To test for JavaScript execution in WebViews check the app for WebView usage and evaluate whether or not each WebView should allow JavaScript execution. If JavaScript execution is required for the app to function normally, then you need to ensure that the app follows the all best practices.
* メタ: profiles: L1, L2; deprecation_note: Having JavaScript enabled is not considered a vulnerability by itself, but it can lead to security issues in combination with other weaknesses, such as local file access in WebViews, which are covered by other tests in the MASTG v2. This test is therefore not considered a standalone test anymore.
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0031/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing JavaScript Execution in WebViewsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing JavaScript Execution in WebViewsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing JavaScript Execution in WebViewsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] To create and use a WebView, an app must create an instance of the WebView class.
* [Static] WebView webview = new WebView(this);
* [Static] setContentView(webview);
* [Static] webview.loadUrl("https://www.owasp.org/");
* [Static] Various settings can be applied to the WebView (activating/deactivating JavaScript is one example). JavaScript is disabled by default for WebViews and must be explicitly enabled. Look for the method setJavaSc...
* [Dynamic] Dynamic Analysis depends on operating conditions. There are several ways to inject JavaScript into an app's WebView:
* [Dynamic] Stored Cross-Site Scripting vulnerabilities in an endpoint; the exploit will be sent to the mobile app's WebView when the user navigates to the vulnerable function.
* [Dynamic] Attacker takes a Machine-in-the-Middle (MITM) position and tampers with the response by injecting JavaScript.
合否（Evaluation）の要点:
* To test for JavaScript execution in WebViews check the app for WebView usage and evaluate whether or not each WebView should allow JavaScript execution. If JavaScript execution is required for the app to function norm...
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする

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
- MASTG-TEST-0031 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0031/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
