---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0078/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0078
masvs_category: MASVS-PLATFORM
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0078: Determining Whether Native Methods Are Exposed Through WebViews

## 概要

* 本ドキュメントは OWASP MASTG Test「Determining Whether Native Methods Are Exposed Through WebViews」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Search for code that maps native objects to the JSContext associated with a WebView and analyze what functionality it exposes, for example no sensitive data should be accessible and exposed to WebViews.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0376, MASTG-TEST-0377, MASTG-TEST-0378, MASTG-TEST-0379, MASTG-TEST-0380; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0078/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Determining Whether Native Methods Are Exposed Through WebViewsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Determining Whether Native Methods Are Exposed Through WebViewsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Determining Whether Native Methods Are Exposed Through WebViewsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Search for code that maps native objects to the JSContext associated with a WebView and analyze what functionality it exposes, for example no sensitive data should be accessible and exposed to WebViews.
* [Static] In Objective-C, the JSContext associated with a UIWebView is obtained as follows:
* [Static] [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]
* [Static] Verify if a JavaScript to native bridge exists by searching for WKScriptMessageHandler and check all exposed methods. Then verify how the methods are called.
* [Static] The following example from "Where's My Browser?" demonstrates this.
* [Dynamic] At this point you've surely identified all potentially interesting WebViews in the iOS app and got an overview of the potential attack surface (via static analysis, the dynamic analysis techniques that we ha...
* [Dynamic] Further dynamic analysis can help you exploit those functions and get sensitive data that they might be exposing. As we have seen in the static analysis, in the previous example it was trivial to get the sec...
* [Dynamic] The procedure for exploiting the functions starts with producing a JavaScript payload and injecting it into the file that the app is requesting. The injection can be accomplished via various techniques, for ...
合否（Evaluation）の要点:
* Search for code that maps native objects to the JSContext associated with a WebView and analyze what functionality it exposes, for example no sensitive data should be accessible and exposed to WebViews.
* Verify if a JavaScript to native bridge exists by searching for WKScriptMessageHandler and check all exposed methods. Then verify how the methods are called.
* The following example from "Where's My Browser?" demonstrates this.
* Adding a script message handler with name "name" (or "javaScriptBridge" in the example above) causes the JavaScript function window.webkit.messageHandlers.myJavaScriptMessageHandler.postMessage to be defined in all fr...
* The called function resides in JavaScriptBridgeMessageHandler.swift:
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0376, MASTG-TEST-0377, MASTG-TEST-0378, MASTG-TEST-0379, MASTG-TEST-0380
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
- MASTG-TEST-0078 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0078/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
