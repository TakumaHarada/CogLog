---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0402/
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
mastg_test_id: MASTG-TEST-0402
masvs_category: MASVS-RESILIENCE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0402: Runtime Use of Debugging Detection APIs

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Use of Debugging Detection APIs」（iOS / 耐タンパ・耐解析）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Even if an iOS app references debugging detection APIs, those checks may not execute in security-relevant code paths at runtime. For example, they may only run in debug builds, fire only once at startup, or be dead code that is never reached. If the app does not invoke its debugging detection logic at the right moments, an attacker who controls the device or app package can attach a debugger without triggering a defensive response.
* メタ: type: dynamic, hooks, manual; profiles: R; weakness: MASWE-0064; knowledge: MASTG-KNOW-0085
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0402/>
* 関連制御群: `MASVS-RESILIENCE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Use of Debugging Detection APIsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Use of Debugging Detection APIsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Use of Debugging Detection APIsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0056 to install the app.
* Use MASTG-TECH-0095 to hook the relevant APIs.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
合否（Evaluation）の要点:
* The test case fails if no debugging detection API calls are observed during app execution. However, results from this test should be interpreted as evidence of the presence of debugging detection logic, not as an asse...
* Further Validation Required:
* Using the backtraces from the hook output, inspect the code locations using MASTG-TECH-0076, and additionally use MASTG-TECH-0055 or MASTG-TECH-0084 to attach a debugger when feasible and verify the app's defensive re...
* Determine whether the checks are called in release builds and not only in debug configurations.
* Determine whether the checks are executed before or during security-relevant flows, and not only once at startup.
* Determine whether the app changes its behavior when a debugger is attached, such as issuing a warning, restricting access, terminating the process, requiring reauthentication, or sending a backend risk signal.
* 観測期待: The output should contain a list of calls to debugging detection APIs observed at runtime, including their return values and backtraces.
```

## ナレッジベース

### DO: 耐タンパはプロファイル R 等の方針に従い深度を決める

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 耐タンパはプロファイル R 等の方針に従い深度を決める
- 検知をサーバ認可の代替にしない
- 関連弱点 MASWE-0064 の有無をチケットへ併記する
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
- MASTG-TEST-0402 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0402/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
