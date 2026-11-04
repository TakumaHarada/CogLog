---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0310/
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
mastg_test_id: MASTG-TEST-0310
masvs_category: MASVS-CRYPTO
platform: android
status: placeholder
upstream_revision: d7fd7d4
---

# MASTG-TEST-0310: Runtime Use of Reused Initialization Vectors in Symmetric Encryption

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Use of Reused Initialization Vectors in Symmetric Encryption」（Android / 暗号）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは placeholder である。手順が未充足の可能性があるため、単独の準拠根拠にしない。
* 要旨: Reusing a symmetric key is acceptable when IVs or nonces follow the rules defined for the mode. NIST SP 800 38A states that CBC requires a fresh or unpredictable IV for every encryption. NIST SP 800 38D states that counter based modes require a nonce that never repeats under the same key. Repeating a key and IV or nonce pair defeats confidentiality and can also undermine integrity.
* メタ: type: dynamic, hooks; profiles: L2; weakness: MASWE-0007
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0310/>
* 関連制御群: `MASVS-CRYPTO`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Use of Reused Initialization Vectors in Symmetric Encryptionのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Use of Reused Initialization Vectors in Symmetric Encryptionのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Use of Reused Initialization Vectors in Symmetric Encryptionのテスト実施の実装例

```text
公式記事の Overview / Static / Dynamic を読み、再現可能な手順へ落とす。
* note: Reusing a symmetric key is acceptable when IVs or nonces follow the rules defined for the mode. NIST SP 800 38A states that CBC requires a fresh or unpredictable IV for every encryption. NIST SP 800 38D states that count
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
- MASTG-TEST-0310 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0310/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
