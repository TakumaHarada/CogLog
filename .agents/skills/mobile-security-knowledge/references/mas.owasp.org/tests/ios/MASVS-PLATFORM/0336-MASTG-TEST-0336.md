---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0336/
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
mastg_test_id: MASTG-TEST-0336
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0336: Runtime Setting of Relaxed WebView File Origin Policies

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Setting of Relaxed WebView File Origin Policies」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test is the dynamic counterpart to MASTG-TEST-0335.
* メタ: type: dynamic, hooks, manual; profiles: L1, L2; weakness: MASWE-0034; knowledge: MASTG-KNOW-0076
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0336/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Setting of Relaxed WebView File Origin Policiesのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Setting of Relaxed WebView File Origin Policiesのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Setting of Relaxed WebView File Origin Policiesのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0056 to install the app.
* Use MASTG-TECH-0095 to hook the relevant APIs.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
合否（Evaluation）の要点:
* The test case fails if the application enables allowFileAccessFromFileURLs or allowUniversalAccessFromFileURLs for a WKWebView that loads local file:// content.
* Further Validation Required:
* Using the backtraces from the hook output, inspect the code locations using MASTG-TECH-0076:
* Determine whether allowFileAccessFromFileURLs or allowUniversalAccessFromFileURLs is explicitly used and set to true.
* Determine which WKWebView instance receives the configuration and whether it handles sensitive information or functionality.
* Determine whether that WKWebView loads local file:// content, for example using APIs such as loadFileURL(_:allowingReadAccessTo:) or loadHTMLString(_:baseURL:) with a file:// base URL.
* 観測期待: The output should show any uses of functions setting allowFileAccessFromFileURLs or allowUniversalAccessFromFileURLs, loading local file:// content, as well as the backtraces of each relevant call.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0034 の有無をチケットへ併記する
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
- MASTG-TEST-0336 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0336/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
