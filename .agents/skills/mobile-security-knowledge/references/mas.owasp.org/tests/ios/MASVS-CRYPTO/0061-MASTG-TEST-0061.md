---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CRYPTO/MASTG-TEST-0061/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - crypto
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0061
masvs_category: MASVS-CRYPTO
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0061: Verifying the Configuration of Cryptographic Standard Algorithms

## 概要

* 本ドキュメントは OWASP MASTG Test「Verifying the Configuration of Cryptographic Standard Algorithms」（iOS / 暗号）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: For each of the libraries that are used by the application, the used algorithms and cryptographic configurations need to be verified to make sure they are not deprecated and used correctly.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0209, MASTG-TEST-0210, MASTG-TEST-0211; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CRYPTO/MASTG-TEST-0061/>
* 関連制御群: `MASVS-CRYPTO`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Verifying the Configuration of Cryptographic Standard Algorithmsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Verifying the Configuration of Cryptographic Standard Algorithmsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Verifying the Configuration of Cryptographic Standard Algorithmsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] For each of the libraries that are used by the application, the used algorithms and cryptographic configurations need to be verified to make sure they are not deprecated and used correctly.
* [Static] Pay attention to how-to-be-removed key-holding datastructures and plain-text data structures are defined. If the keyword let is used, then you create an immutable structure which is harder to wipe from memory...
* [Static] Ensure that the best practices outlined in the "Cryptography for Mobile Apps" chapter are followed. Look at insecure and deprecated algorithms and common configuration issues.
* [Static] If the app uses standard cryptographic implementations provided by Apple, the easiest way to determine the status of the related algorithm is to check for calls to functions from CommonCryptor, such as CCCryp...
* [Static] CCCryptorStatus CCCryptorCreate(
合否（Evaluation）の要点:
* Ensure that the best practices outlined in the "Cryptography for Mobile Apps" chapter are followed. Look at insecure and deprecated algorithms and common configuration issues.
* If the app uses standard cryptographic implementations provided by Apple, the easiest way to determine the status of the related algorithm is to check for calls to functions from CommonCryptor, such as CCCrypt and CCC...
* You can then compare all the enum types to determine which algorithm, padding, and key material is used. Pay attention to the keying material: the key should be generated securely - either using a key derivation funct...
* Note that functions which are noted in chapter "Cryptography for Mobile Apps" as deprecated, are still programmatically supported. They should not be used.
* Given the continuous evolution of all third party libraries, this should not be the place to evaluate each library in terms of static analysis. Still there are some points of attention:
```

## ナレッジベース

### DO: 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする
- Keystore/Keychain 由来の鍵利用を確認する
- 後継: MASTG-TEST-0209, MASTG-TEST-0210, MASTG-TEST-0211
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
- MASTG-TEST-0061 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CRYPTO/MASTG-TEST-0061/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
