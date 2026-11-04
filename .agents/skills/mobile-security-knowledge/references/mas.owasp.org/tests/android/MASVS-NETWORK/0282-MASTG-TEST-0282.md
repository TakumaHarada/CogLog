---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0282/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - network
  - backend
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0282
masvs_category: MASVS-NETWORK
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0282: Unsafe Custom Trust Evaluation

## 概要

* 本ドキュメントは OWASP MASTG Test「Unsafe Custom Trust Evaluation」（Android / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test evaluates whether an Android app uses checkServerTrusted(...) in an unsafe manner as part of a custom TrustManager, causing any connection configured to use that TrustManager to skip certificate validation.
* メタ: type: static, code, manual; profiles: L1, L2; weakness: MASWE-0027; knowledge: MASTG-KNOW-0010
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0282/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Unsafe Custom Trust Evaluationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Unsafe Custom Trust Evaluationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Unsafe Custom Trust Evaluationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0014 to look for the relevant APIs.
合否（Evaluation）の要点:
* The test case fails if checkServerTrusted(...) is implemented in a custom X509TrustManager and does not properly validate server certificates.
* Further Validation Required:
* Inspect each reported code location using MASTG-TECH-0023, looking for cases such as:
* Using checkServerTrusted(...) which is error prone, when NSC would be enough.
* Trust manager that does nothing: overriding checkServerTrusted(...) to accept all certificates without any validation, for example by returning immediately without verifying the certificate chain or by always returnin...
* Ignoring errors: failing to throw proper exceptions (e.g. CertificateException or IllegalArgumentException) on validation failure, or catching and suppressing them.
* 観測期待: The output should contain a list of locations where checkServerTrusted(...) is used.
```

## ナレッジベース

### DO: TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する
- 検証スキップ経路があれば fail とする
- 関連弱点 MASWE-0027 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: HTTPS という文言だけで pass にする

* 理由: MASVS-NETWORK の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- HTTPS という文言だけで pass にする
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0282 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0282/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
