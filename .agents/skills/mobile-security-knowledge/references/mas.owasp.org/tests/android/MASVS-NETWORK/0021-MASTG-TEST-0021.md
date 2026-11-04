---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0021/
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
mastg_test_id: MASTG-TEST-0021
masvs_category: MASVS-NETWORK
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0021: Testing Endpoint Identify Verification

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Endpoint Identify Verification」（Android / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Using TLS to transport sensitive information over the network is essential for security. However, encrypting communication between a mobile application and its backend API is not trivial. Developers often decide on simpler but less secure solutions (e.g., those that accept any certificate) to facilitate the development process, and sometimes these weak solutions make it into the production version, potentially exposing users to Machine-in-the-...
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0282, MASTG-TEST-0283, MASTG-TEST-0284, MASTG-TEST-0285, MASTG-TEST-0286; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0021/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Endpoint Identify Verificationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Endpoint Identify Verificationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Endpoint Identify Verificationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Using TLS to transport sensitive information over the network is essential for security. However, encrypting communication between a mobile application and its backend API is not trivial. Developers often dec...
* [Static] Two key issues should be addressed:
* [Static] Verify that a certificate comes from a trusted source, i.e. a trusted CA (Certificate Authority).
* [Static] Determine whether the endpoint server presents the right certificate.
* [Static] Make sure that the hostname and the certificate itself are verified correctly. Examples and common pitfalls are available in the official Android documentation. Search the code for examples of TrustManager an...
* [Dynamic] When testing an app targeting Android 7.0 (API level 24) or higher it should be effectively applying the Network Security Configuration and you shouldn't able to see the decrypted HTTPS traffic at first. How...
* [Dynamic] To test improper certificate verification launch a MITM attack using an interception proxy such as Burp. Try the following options:
* [Dynamic] Self-signed certificate:
合否（Evaluation）の要点:
* Two key issues should be addressed:
* Make sure that the hostname and the certificate itself are verified correctly. Examples and common pitfalls are available in the official Android documentation. Search the code for examples of TrustManager and Hostnam...
* Search for the Network Security Configuration file and inspect any custom defining (which should be avoided).
* You should carefully analyze the precedence of entries:
* TrustManager is a means of verifying conditions necessary for establishing a trusted connection in Android. The following conditions should be checked at this point:
```

## ナレッジベース

### DO: TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する
- 検証スキップ経路があれば fail とする
- 後継: MASTG-TEST-0282, MASTG-TEST-0283, MASTG-TEST-0284, MASTG-TEST-0285, MASTG-TEST-0286
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
- MASTG-TEST-0021 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0021/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
