---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0067/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - network
  - backend
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0067
masvs_category: MASVS-NETWORK
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0067: Testing Endpoint Identity Verification

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Endpoint Identity Verification」（iOS / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Using TLS to transport sensitive information over the network is essential for security. However, encrypting communication between a mobile application and its backend API is not trivial. Developers often decide on simpler but less secure solutions (e.g., those that accept any certificate) to facilitate the development process, and sometimes these weak solutions make it into the production version, potentially exposing users to Machine-in-the-...
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0322, MASTG-TEST-0342, MASTG-TEST-0396, MASTG-TEST-0397; deprecation_note: "New version available in MASTG v2"
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0067/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Endpoint Identity Verificationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Endpoint Identity Verificationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Endpoint Identity Verificationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Using TLS to transport sensitive information over the network is essential for security. However, encrypting communication between a mobile application and its backend API is not trivial. Developers often dec...
* [Static] These are some of the issues should be addressed:
* [Static] Check if the app links against an SDK older than iOS 9.0. In that case ATS is disabled no matter which version of the OS the app runs on.
* [Static] Verify that a certificate comes from a trusted source, i.e. a trusted CA (Certificate Authority).
* [Static] Determine whether the endpoint server presents the right certificate.
* [Dynamic] Our test approach is to gradually relax security of the SSL handshake negotiation and check which security mechanisms are enabled.
* [Dynamic] Having Burp set up as a proxy, make sure that there is no certificate added to the trust store (Settings -> General -> Profiles) and that tools like SSL Kill Switch are deactivated. Launch your application a...
* [Dynamic] Now, install the Burp certificate, as explained in Burp's user documentation. If the handshake is successful and you can see the traffic in Burp, it means that the certificate is validated against the device...
合否（Evaluation）の要点:
* These are some of the issues should be addressed:
* Check if the app links against an SDK older than iOS 9.0. In that case ATS is disabled no matter which version of the OS the app runs on.
* Our test approach is to gradually relax security of the SSL handshake negotiation and check which security mechanisms are enabled.
* Having Burp set up as a proxy, make sure that there is no certificate added to the trust store (Settings -> General -> Profiles) and that tools like SSL Kill Switch are deactivated. Launch your application and check i...
```

## ナレッジベース

### DO: TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する
- 検証スキップ経路があれば fail とする
- 後継: MASTG-TEST-0322, MASTG-TEST-0342, MASTG-TEST-0396, MASTG-TEST-0397
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
- MASTG-TEST-0067 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0067/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
