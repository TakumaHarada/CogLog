---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0368/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - resilience
  - profile-r
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0368
masvs_category: MASVS-RESILIENCE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0368: Insufficient Obfuscation of Security-Relevant Java/Kotlin Code

## 概要

* 本ドキュメントは OWASP MASTG Test「Insufficient Obfuscation of Security-Relevant Java/Kotlin Code」（Android / 耐タンパ・耐解析）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: If security-relevant Java or Kotlin code is not sufficiently obfuscated, decompilation of the app's DEX bytecode can expose business logic, device attestation and environment checks, integrity checks, and other implementation details that help an attacker understand the app and model attacks.
* メタ: type: static, code, manual; profiles: R; weakness: MASWE-0059; knowledge: MASTG-KNOW-0033
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0368/>
* 関連制御群: `MASVS-RESILIENCE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Insufficient Obfuscation of Security-Relevant Java/Kotlin Codeのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Insufficient Obfuscation of Security-Relevant Java/Kotlin Codeのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Insufficient Obfuscation of Security-Relevant Java/Kotlin Codeのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
合否（Evaluation）の要点:
* The test case fails if the Java or Kotlin layer allows an attacker to identify, correlate, and reverse engineer security-relevant logic with reasonable effort.
* Further Validation Required:
* Inspect the decompiled code using MASTG-TECH-0023. If the decompiled output is incomplete or unreliable, use MASTG-TECH-0016 to inspect the corresponding Smali code. Refer to MASTG-KNOW-0033 to determine whether the c...
* Determine whether class names, method names, field names, or local variables have been renamed to meaningless identifiers.
* Determine whether string literals (e.g., API endpoints, error messages, or detection artifact names) remain in plaintext and can be used to locate security-relevant logic.
* Determine whether the control flow is structured in a way that still makes the original logic easy to follow (e.g., no obfuscated branches or opaque predicates).
* 観測期待: The output should contain the decompiled Java code from the app.
```

## ナレッジベース

### DO: 耐タンパはプロファイル R 等の方針に従い深度を決める

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 耐タンパはプロファイル R 等の方針に従い深度を決める
- 検知をサーバ認可の代替にしない
- 関連弱点 MASWE-0059 の有無をチケットへ併記する
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
- MASTG-TEST-0368 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0368/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
