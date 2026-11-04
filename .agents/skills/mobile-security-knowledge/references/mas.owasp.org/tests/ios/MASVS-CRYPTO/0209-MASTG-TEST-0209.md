---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CRYPTO/MASTG-TEST-0209/
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
mastg_test_id: MASTG-TEST-0209
masvs_category: MASVS-CRYPTO
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0209: Insufficient Key Sizes

## 概要

* 本ドキュメントは OWASP MASTG Test「Insufficient Key Sizes」（iOS / 暗号）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: In this test case, we will look for the use insufficient key sizes in iOS apps. To do this, we need to focus on APIs from cryptographic frameworks and libraries that are available in iOS and the methods that are used to generate cryptographic keys.
* メタ: type: static, code; profiles: L1, L2; weakness: MASWE-0013
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CRYPTO/MASTG-TEST-0209/>
* 関連制御群: `MASVS-CRYPTO`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Insufficient Key Sizesのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Insufficient Key Sizesのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Insufficient Key Sizesのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
合否（Evaluation）の要点:
* The test case fails if you can find the use of insufficient key sizes within the source code. For example, a 1024-bit key size is considered insufficient for RSA encryption and a 128-bit key size is considered insuffi...
* 観測期待: The output should contain the disassembled code of the functions using CCCrypt or other cryptographic functions.
```

## ナレッジベース

### DO: 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする
- Keystore/Keychain 由来の鍵利用を確認する
- 関連弱点 MASWE-0013 の有無をチケットへ併記する
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
- MASTG-TEST-0209 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CRYPTO/MASTG-TEST-0209/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
