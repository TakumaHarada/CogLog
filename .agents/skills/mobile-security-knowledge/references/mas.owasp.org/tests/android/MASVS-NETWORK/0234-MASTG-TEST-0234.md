---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0234/
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
mastg_test_id: MASTG-TEST-0234
masvs_category: MASVS-NETWORK
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0234: Missing Implementation of Server Hostname Verification with SSLSockets

## 概要

* 本ドキュメントは OWASP MASTG Test「Missing Implementation of Server Hostname Verification with SSLSockets」（Android / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test checks whether an Android app uses SSLSocket without a HostnameVerifier, allowing connections to servers presenting certificates with wrong or invalid hostnames.
* メタ: type: static, code; profiles: L1, L2; weakness: MASWE-0027
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0234/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Missing Implementation of Server Hostname Verification with SSLSocketsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Missing Implementation of Server Hostname Verification with SSLSocketsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Missing Implementation of Server Hostname Verification with SSLSocketsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0014 to look for the relevant APIs.
合否（Evaluation）の要点:
* The test case fails if the app uses SSLSocket without a HostnameVerifier.
* If a HostnameVerifier is present, ensure it's not implemented in an unsafe manner. See MASTG-TEST-0283 for guidance.
* 観測期待: The output should contain a list of locations where SSLSocket and HostnameVerifier are used.
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
- MASTG-TEST-0234 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0234/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
