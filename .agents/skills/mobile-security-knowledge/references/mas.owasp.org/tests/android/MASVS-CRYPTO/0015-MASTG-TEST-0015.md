---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0015/
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
mastg_test_id: MASTG-TEST-0015
masvs_category: MASVS-CRYPTO
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0015: Testing the Purposes of Keys

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing the Purposes of Keys」（Android / 暗号）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Identify all instances where cryptography is used. You can look for:
* メタ: profiles: L2; covered_by: MASTG-TEST-0307, MASTG-TEST-0308
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0015/>
* 関連制御群: `MASVS-CRYPTO`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing the Purposes of Keysのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing the Purposes of Keysのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing the Purposes of Keysのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Identify all instances where cryptography is used. You can look for:
* [Static] classes Cipher, Mac, MessageDigest, Signature
* [Static] interfaces Key, PrivateKey, PublicKey, SecretKey
* [Static] functions getInstance, generateKey
* [Static] exceptions KeyStoreException, CertificateException, NoSuchAlgorithmException
* [Dynamic] You can use MASTG-TECH-0033 on cryptographic methods to determine input / output values such as the keys that are being used. Monitor file system access while cryptographic operations are being performed to ...
合否（Evaluation）の要点:
* for encryption/decryption - to ensure data confidentiality
* for signing/verifying - to ensure integrity of data (as well as accountability in some cases)
* Additionally, you should identify the business logic which uses identified instances of cryptography.
* During verification the following checks should be performed:
* are symmetric keys used for multiple purposes? A new symmetric key should be generated if it's used in a different context.
```

## ナレッジベース

### DO: 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする
- Keystore/Keychain 由来の鍵利用を確認する
- 後継: MASTG-TEST-0307, MASTG-TEST-0308
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
- MASTG-TEST-0015 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0015/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
