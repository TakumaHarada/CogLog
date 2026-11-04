---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0335/
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
mastg_test_id: MASTG-TEST-0335
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0335: WebView File Origin Access Relaxed by Configuration

## 概要

* 本ドキュメントは OWASP MASTG Test「WebView File Origin Access Relaxed by Configuration」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: WKWebView supports configuration that affects how JavaScript running from file:// origins can access other resources. In particular, allowFileAccessFromFileURLs allows JavaScript running in the context of a file:// URL to access content from other file:// URLs, while allowUniversalAccessFromFileURLs allows JavaScript running in the context of a file:// URL to access content from any origin. Both settings are considered dangerous when enabled b...
* メタ: type: static, code, manual; profiles: L1, L2; weakness: MASWE-0034; knowledge: MASTG-KNOW-0076
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0335/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## WebView File Origin Access Relaxed by Configurationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### WebView File Origin Access Relaxed by Configurationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### WebView File Origin Access Relaxed by Configurationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
合否（Evaluation）の要点:
* The test case fails if the app enables allowFileAccessFromFileURLs or allowUniversalAccessFromFileURLs for a WKWebView that loads local file:// content.
* Further Validation Required:
* Inspect each reported code location using MASTG-TECH-0076:
* Determine whether allowFileAccessFromFileURLs or allowUniversalAccessFromFileURLs is explicitly used and set to true, for example through setValue:forKey: or equivalent Swift calls.
* Determine which WKWebView instance receives the configuration and whether it handles sensitive information or functionality.
* Determine whether that WKWebView loads local file:// content, for example using APIs such as loadFileURL(_:allowingReadAccessTo:) or loadHTMLString(_:baseURL:) with a file:// base URL.
* 観測期待: The output should identify locations in the binary where the app references or enables the relevant configuration values.
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
- MASTG-TEST-0335 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0335/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
