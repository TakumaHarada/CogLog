---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0369/
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
mastg_test_id: MASTG-TEST-0369
masvs_category: MASVS-RESILIENCE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0369: Insufficient Obfuscation of Security-Relevant Native Code

## 概要

* 本ドキュメントは OWASP MASTG Test「Insufficient Obfuscation of Security-Relevant Native Code」（Android / 耐タンパ・耐解析）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: If native libraries that implement security-relevant logic are not obfuscated, reverse engineering of packaged native code can expose business logic, device attestation and environment checks, integrity checks, and other implementation details that help an attacker understand the app and model attacks.
* メタ: type: static, package, manual; profiles: R; weakness: MASWE-0059; knowledge: MASTG-KNOW-0033
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0369/>
* 関連制御群: `MASVS-RESILIENCE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Insufficient Obfuscation of Security-Relevant Native Codeのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Insufficient Obfuscation of Security-Relevant Native Codeのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Insufficient Obfuscation of Security-Relevant Native Codeのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0157 to extract the native libraries from the app package.
合否（Evaluation）の要点:
* The test case fails if the app's native libraries allow an attacker to identify, correlate, and reverse engineer security-relevant logic with reasonable effort.
* Further Validation Required:
* Use MASTG-TECH-0018 to disassemble the native libraries and inspect it using MASTG-TECH-0024. Refer to MASTG-KNOW-0033 to determine whether the native code shows indicators of obfuscation:
* Determine whether native library strings or constants (e.g., monitored file paths, API tokens, or integrity check values) are in plaintext.
* Determine whether the disassembled function structure and call edges still reveal the original security-relevant logic with recognizable patterns.
* Determine whether exported JNI symbols retain descriptive names that can be directly correlated with security-relevant functionality.
* 観測期待: The output should contain the extracted native libraries, such as .so files.
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
- MASTG-TEST-0369 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0369/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
