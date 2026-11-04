---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0022/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - network
  - backend
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0022
masvs_category: MASVS-NETWORK
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0022: Testing Custom Certificate Stores and Certificate Pinning

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Custom Certificate Stores and Certificate Pinning」（Android / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Inspect the Network Security Configuration looking for any elements. Check their expiration date, if any. If expired, certificate pinning will be disabled for the affected domains.
* メタ: profiles: L2; covered_by: MASTG-TEST-0242, MASTG-TEST-0243, MASTG-TEST-0244; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0022/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Custom Certificate Stores and Certificate Pinningのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Custom Certificate Stores and Certificate Pinningのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Custom Certificate Stores and Certificate Pinningのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Inspect the Network Security Configuration looking for any elements. Check their expiration date, if any. If expired, certificate pinning will be disabled for the affected domains.
* [Static] > Testing Tip: If a certificate pinning validation check has failed, the following event should be logged in the system logs (see MASTG-TECH-0009):
* [Static] I/X509Util: Failed to validate the certificate chain, error: Pin verification failed
* [Static] Implementing certificate pinning involves three main steps:
* [Static] Obtain the certificate of the desired host(s).
* [Dynamic] Follow the instructions from MASTG-TEST-0021. If doing so doesn't lead to traffic being proxied, it may mean that certificate pinning is actually implemented and all security measures are in place. Does the ...
* [Dynamic] As a quick smoke test, you can try to bypass certificate pinning using MASTG-TOOL-0038 as described in MASTG-TECH-0012. Pinning related APIs being hooked by objection should appear in objection's output.
* [Dynamic] However, keep in mind that:
合否（Evaluation）の要点:
* Inspect the Network Security Configuration looking for any elements. Check their expiration date, if any. If expired, certificate pinning will be disabled for the affected domains.
* > Testing Tip: If a certificate pinning validation check has failed, the following event should be logged in the system logs (see MASTG-TECH-0009):
* I/X509Util: Failed to validate the certificate chain, error: Pin verification failed
* To analyze the correct implementation of certificate pinning, the HTTP client should load the KeyStore:
* Alternatively, it is better to use an OkHttpClient with configured pins and let it act as a proxy overriding shouldInterceptRequest of the WebViewClient.
```

## ナレッジベース

### DO: TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する
- 検証スキップ経路があれば fail とする
- 後継: MASTG-TEST-0242, MASTG-TEST-0243, MASTG-TEST-0244
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
- MASTG-TEST-0022 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0022/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
