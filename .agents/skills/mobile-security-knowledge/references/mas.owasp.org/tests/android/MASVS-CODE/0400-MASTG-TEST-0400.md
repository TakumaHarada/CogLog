---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0400/
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
mastg_test_id: MASTG-TEST-0400
masvs_category: MASVS-CODE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0400: Runtime Use of WebViewClient URL Loading Handlers

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Use of WebViewClient URL Loading Handlers」（Android / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test dynamically analyzes the runtime behavior of WebViewClient URL interception methods to understand how the app handles URL loading in WebViews. By hooking relevant methods at runtime, you can observe:
* メタ: type: dynamic, hooks, manual; profiles: L1, L2; weakness: MASWE-0035; knowledge: MASTG-KNOW-0018
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0400/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Use of WebViewClient URL Loading Handlersのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Use of WebViewClient URL Loading Handlersのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Use of WebViewClient URL Loading Handlersのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0005 to install the app.
* Use MASTG-TECH-0043 to hook the relevant API calls.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
合否（Evaluation）の要点:
* The test case fails if the runtime analysis shows that a URL is loaded or a resource request is served without the app validating it against trusted content.
* Further Validation Required:
* Using the backtraces from the hook output, inspect the code locations using MASTG-TECH-0023 to determine whether:
* The app validates the URL's host or scheme before allowing navigation or returning resource data.
* The validation logic reliably restricts navigation to trusted domains (for example, validating the full host rather than relying on a substring match).
* Note that intercepting URL loading is not inherently insecure. The test fails only when the implementation does not properly restrict navigation to trusted content.
* 観測期待: The output should contain:
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 関連弱点 MASWE-0035 の有無をチケットへ併記する
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
- MASTG-TEST-0400 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0400/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
