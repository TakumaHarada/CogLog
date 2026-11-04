---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0307/
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
mastg_test_id: MASTG-TEST-0307
masvs_category: MASVS-CRYPTO
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0307: References to Asymmetric Key Pairs Used For Multiple Purposes

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Asymmetric Key Pairs Used For Multiple Purposes」（Android / 暗号）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: According to section "5.2 Key Usage" of NIST SP 800-57 part 1 revision 5, cryptographic keys should be assigned a specific purpose and used only for that purpose (e.g., encryption, integrity authentication, key wrapping, random bit generation, or digital signatures). For example, a key intended for encryption should not be used for signing.
* メタ: type: static, code; profiles: L2; weakness: MASWE-0007; knowledge: MASTG-KNOW-0012
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0307/>
* 関連制御群: `MASVS-CRYPTO`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Asymmetric Key Pairs Used For Multiple Purposesのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Asymmetric Key Pairs Used For Multiple Purposesのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Asymmetric Key Pairs Used For Multiple Purposesのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0014 to look for the relevant APIs.
合否（Evaluation）の要点:
* The test case fails if you find any keys used for multiple roles (groups of purposes).
* Using the output, ensure that each key pair is restricted to exactly one of the following roles:
* Encryption/Decryption (PURPOSE_ENCRYPT / PURPOSE_DECRYPT)
* Signing/Verification (PURPOSE_SIGN / PURPOSE_VERIFY)
* Key Wrapping (PURPOSE_WRAP_KEY)
* When reverse engineering the app, you will find the previously mentioned purpose constants combined into a single integer value. For example, a purpose value of 15 combines all four purposes, which is not acceptable:
* 観測期待: The output should contain a list of locations where asymmetric keys are created using KeyGenParameterSpec.Builder and the associated purposes.
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
- MASTG-TEST-0307 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0307/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
