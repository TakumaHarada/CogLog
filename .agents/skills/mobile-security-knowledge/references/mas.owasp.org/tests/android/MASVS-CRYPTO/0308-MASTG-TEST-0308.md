---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0308/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - crypto
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0308
masvs_category: MASVS-CRYPTO
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0308: Runtime Use of Asymmetric Key Pairs Used For Multiple Purposes

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Use of Asymmetric Key Pairs Used For Multiple Purposes」（Android / 暗号）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test is the dynamic counterpart to MASTG-TEST-0307, but it focuses on intercepting cryptographic operations rather than generating keys with multiple purposes.
* メタ: type: dynamic, hooks; profiles: L2; weakness: MASWE-0007; knowledge: MASTG-KNOW-0012
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0308/>
* 関連制御群: `MASVS-CRYPTO`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Use of Asymmetric Key Pairs Used For Multiple Purposesのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Use of Asymmetric Key Pairs Used For Multiple Purposesのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Use of Asymmetric Key Pairs Used For Multiple Purposesのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0005 to install the app.
* Use MASTG-TECH-0043 to hook the relevant API calls.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
合否（Evaluation）の要点:
* The test case fails if you find any keys used for multiple roles.
* Using the output, ensure that each key (or key pair) is restricted to exactly one of the following groups of operations:
* Encryption/Decryption (used in Cipher operations with ENCRYPT_MODE or DECRYPT_MODE)
* Signing/Verification (used in Signature operations)
* Key Wrapping (used in Cipher operations with WRAP_MODE or UNWRAP_MODE)
* 観測期待: The output should contain a list of all cryptographic operations together with their corresponding keys.
```

## ナレッジベース

### DO: 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする
- Keystore/Keychain 由来の鍵利用を確認する
- 関連弱点 MASWE-0007 の有無をチケットへ併記する
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
- MASTG-TEST-0308 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0308/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
