---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CRYPTO/MASTG-TEST-0349/
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
mastg_test_id: MASTG-TEST-0349
masvs_category: MASVS-CRYPTO
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0349: Runtime Use of Insecure Random APIs

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Use of Insecure Random APIs」（iOS / 暗号）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: If the app uses insecure pseudorandom number generators (PRNGs) at runtime, generated values can become predictable. This can lead to weak tokens, nonces, keys, or identifiers when those values are used in security-relevant contexts. This test checks whether the running app calls insecure random APIs, such as rand, random, and the rand48 family, during relevant flows.
* メタ: type: dynamic, hooks, manual; profiles: L1, L2; weakness: MASWE-0012; knowledge: MASTG-KNOW-0070
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CRYPTO/MASTG-TEST-0349/>
* 関連制御群: `MASVS-CRYPTO`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Use of Insecure Random APIsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Use of Insecure Random APIsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Use of Insecure Random APIsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0056 to install the app.
* Use MASTG-TECH-0095 to hook the relevant APIs.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
合否（Evaluation）の要点:
* The test case fails if random values produced by insecure APIs are used in security-relevant contexts.
* Further Validation Required:
* Using the backtraces from the hook output, inspect the code locations using MASTG-TECH-0076 to determine whether the usage is security-relevant:
* Determine whether the generated random values are used for security-relevant purposes, such as generating cryptographic keys, initialization vectors (IVs), nonces, authentication tokens, session identifiers, passwords...
* 観測期待: The output should contain runtime calls to insecure random APIs, including function names and backtraces.
```

## ナレッジベース

### DO: 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 非推奨アルゴリズム・固定鍵・弱い乱数を検出したら fail とする
- Keystore/Keychain 由来の鍵利用を確認する
- 関連弱点 MASWE-0012 の有無をチケットへ併記する
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
- MASTG-TEST-0349 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CRYPTO/MASTG-TEST-0349/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
