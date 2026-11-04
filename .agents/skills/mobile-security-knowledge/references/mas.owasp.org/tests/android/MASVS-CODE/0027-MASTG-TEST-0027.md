---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0027/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - code
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0027
masvs_category: MASVS-CODE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0027: Testing for URL Loading in WebViews

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing for URL Loading in WebViews」（Android / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: In order to test for URL loading in WebViews you need to carefully analyze handling page navigation, especially when users might be able to navigate away from a trusted environment. The default and safest behavior on Android is to let the default web browser open any link that the user might click inside the WebView. However, this default logic can be modified by configuring a WebViewClient which allows navigation requests to be handled by the...
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0398, MASTG-TEST-0399, MASTG-TEST-0400; deprecation_note: "New version available in MASTG V2"
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0027/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing for URL Loading in WebViewsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing for URL Loading in WebViewsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing for URL Loading in WebViewsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] To test if the app is overriding the default page navigation logic by configuring a WebViewClient you should search for and inspect the following interception callback functions:
* [Static] shouldOverrideUrlLoading allows your application to either abort loading WebViews with suspicious content by returning true or allow the WebView to load the URL by returning false. Considerations:
* [Static] This method is not called for POST requests.
* [Static] This method is not called for XmlHttpRequests, iFrames, "src" attributes included in HTML or tags. Instead, shouldInterceptRequest should take care of this.
* [Static] shouldInterceptRequest allows the application to return the data from resource requests. If the return value is null, the WebView will continue to load the resource as usual. Otherwise, the data returned by t...
* [Dynamic] A convenient way to dynamically test deep linking is to use Frida or frida-trace and hook the shouldOverrideUrlLoading, shouldInterceptRequest methods while using the app and clicking on links within the Web...
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 後継: MASTG-TEST-0398, MASTG-TEST-0399, MASTG-TEST-0400
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: ビルド設定を見ずにコードレビューだけで完了する

* 理由: MASVS-CODE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- ビルド設定を見ずにコードレビューだけで完了する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0027 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0027/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
