---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0358/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - resilience
  - profile-r
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0358
masvs_category: MASVS-RESILIENCE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0358: Implementation Details Exposure Through Logging APIs

## 概要

* 本ドキュメントは OWASP MASTG Test「Implementation Details Exposure Through Logging APIs」（iOS / 耐タンパ・耐解析）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test checks for verbose error logging and debugging messages in iOS applications. While logging is useful during development, verbose logging in production builds can expose implementation details such as function names, code paths, internal state information, and error conditions that could be exploited by attackers performing reverse engineering.
* メタ: type: static, code; profiles: R; weakness: MASWE-0061; knowledge: MASTG-KNOW-0064, MASTG-KNOW-0101
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0358/>
* 関連制御群: `MASVS-RESILIENCE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Implementation Details Exposure Through Logging APIsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Implementation Details Exposure Through Logging APIsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Implementation Details Exposure Through Logging APIsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
* Use MASTG-TECH-0071 to look for logging strings.
* Use MASTG-TECH-0076 to analyze the relevant code paths and correlate strings and logging API calls where needed.
合否（Evaluation）の要点:
* The test case fails if the app contains implemented logging paths that produce verbose debug or error messages in production builds and expose implementation details.
* This determination should be based on analyzing how logging APIs are used, not merely on the presence of logging functions in the binary. Reverse engineering should be used to inspect the arguments, message strings, a...
* Static analysis is well suited to identifying logging behavior across the codebase, including paths that may be difficult to reach at runtime, but it can require substantial effort when symbols are stripped, strings a...
* Examples of failing cases include logs that reveal:
* internal function names or code paths
* detailed error information, stack-related details, or diagnostic context
* 観測期待: The output should contain a list of logging function calls or other relevant logging references found in the binary.
```

## ナレッジベース

### DO: 耐タンパはプロファイル R 等の方針に従い深度を決める

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 耐タンパはプロファイル R 等の方針に従い深度を決める
- 検知をサーバ認可の代替にしない
- 関連弱点 MASWE-0061 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 難読化有無だけでセキュリティ完了とする

* 理由: MASVS-RESILIENCE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 難読化有無だけでセキュリティ完了とする
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0358 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0358/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
