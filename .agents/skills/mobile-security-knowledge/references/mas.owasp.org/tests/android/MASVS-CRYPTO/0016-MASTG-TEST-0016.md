---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0016/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - crypto
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0016
masvs_category: MASVS-CRYPTO
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0016: Testing Random Number Generation

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Random Number Generation」（Android / 暗号）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Identify all the instances of random number generators and look for either custom or well-known insecure classes. For instance, java.util.Random produces an identical sequence of numbers for each given seed value; consequently, the sequence of numbers is predictable. Instead a well-vetted algorithm should be chosen that is currently considered to be strong by experts in the field, and a well-tested implementations with adequate length seeds sh...
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0204, MASTG-TEST-0205
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0016/>
* 関連制御群: `MASVS-CRYPTO`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Random Number Generationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Random Number Generationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Random Number Generationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Identify all the instances of random number generators and look for either custom or well-known insecure classes. For instance, java.util.Random produces an identical sequence of numbers for each given seed v...
* [Static] Identify all instances of SecureRandom that are not created using the default constructor. Specifying the seed value may reduce randomness. Use only the no-argument constructor of SecureRandom that uses the s...
* [Static] In general, if a PRNG is not advertised as being cryptographically secure (e.g. java.util.Random), then it is probably a statistical PRNG and should not be used in security-sensitive contexts.
* [Static] Pseudo-random number generators can produce predictable numbers if the generator is known and the seed can be guessed. A 128-bit seed is a good starting point for producing a "random enough" number.
* [Static] Once an attacker knows what type of weak pseudo-random number generator (PRNG) is used, it can be trivial to write a proof-of-concept to generate the next random value based on previously observed ones, as it...
* [Dynamic] You can use MASTG-TECH-0033 on the mentioned classes and methods to determine input / output values being used.
合否（Evaluation）の要点:
* Identify all the instances of random number generators and look for either custom or well-known insecure classes. For instance, java.util.Random produces an identical sequence of numbers for each given seed value; con...
* In general, if a PRNG is not advertised as being cryptographically secure (e.g. java.util.Random), then it is probably a statistical PRNG and should not be used in security-sensitive contexts.
* Pseudo-random number generators can produce predictable numbers if the generator is known and the seed can be guessed. A 128-bit seed is a good starting point for producing a "random enough" number.
* If you want to test for randomness, you can try to capture a large set of numbers and check with the Burp's sequencer to see how good the quality of the randomness is.
```

## ナレッジベース

### DO: 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする
- Keystore/Keychain 由来の鍵利用を確認する
- 後継: MASTG-TEST-0204, MASTG-TEST-0205
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 自前 XOR / ハードコード鍵を許容する

* 理由: MASVS-CRYPTO の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 自前 XOR / ハードコード鍵を許容する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0016 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0016/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
