---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0332/
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
  - profile-p
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0332
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0332: Attacker-Controlled URI in WebViews

## 概要

* 本ドキュメントは OWASP MASTG Test「Attacker-Controlled URI in WebViews」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: iOS apps can dynamically load content into a WKWebView using various URL load methods. These methods can render both remote web content and locally stored files.
* メタ: type: static, code, manual; profiles: L1, L2, P; weakness: MASWE-0035; knowledge: MASTG-KNOW-0076
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0332/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Attacker-Controlled URI in WebViewsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Attacker-Controlled URI in WebViewsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Attacker-Controlled URI in WebViewsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
合否（Evaluation）の要点:
* The test case fails if any call to WKWebView URL load APIs is found where the URL is derived from attacker-controlled input without proper validation.
* Further Validation Required:
* Inspect each reported code location using MASTG-TECH-0076:
* Trace where the URL originates.
* Determine whether it is derived from attacker-controlled input, for example a custom URL scheme parameter, a deep link component, or unsanitized user input from the UI.
* Verify that the URL is adequately validated before being passed to WKWebView URL load APIs.
* 観測期待: The output should contain a list of locations in the binary where WKWebView URL load APIs are called.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0035 の有無をチケットへ併記する
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
- MASTG-TEST-0332 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0332/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
