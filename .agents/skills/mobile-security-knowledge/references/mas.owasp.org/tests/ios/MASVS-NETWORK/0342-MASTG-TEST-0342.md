---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0342/
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
mastg_test_id: MASTG-TEST-0342
masvs_category: MASVS-NETWORK
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0342: References to Weak ATS TLS Policy Exceptions in Info.plist

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Weak ATS TLS Policy Exceptions in Info.plist」（iOS / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Apps can weaken ATS TLS enforcement through NSAppTransportSecurity exceptions in Info.plist. In particular:
* メタ: type: static, code; profiles: L1, L2; weakness: MASWE-0026; knowledge: MASTG-KNOW-0071
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0342/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Weak ATS TLS Policy Exceptions in Info.plistのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Weak ATS TLS Policy Exceptions in Info.plistのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Weak ATS TLS Policy Exceptions in Info.plistのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to unzip the app package.
* Use MASTG-TECH-0153 to retrieve the Info.plist file.
* Use MASTG-TECH-0155 to analyze the ATS configuration for TLS policy exceptions, specifically NSExceptionMinimumTLSVersion, NSExceptionRequiresForwardSecrecy, and NSAllowsArbitraryLoads.
合否（Evaluation）の要点:
* The test case fails if any of the following conditions are met:
* NSAllowsArbitraryLoads is set to true. This disables ATS for all connections to domains not listed in NSExceptionDomains. Per-domain exceptions in NSExceptionDomains still apply to their respective domains, but all ot...
* Any domain, IP address, or IP address range sets NSExceptionMinimumTLSVersion to TLSv1.0 or TLSv1.1.
* Any domain, IP address, or IP address range sets NSExceptionRequiresForwardSecrecy to false, NO, or 0.
* Apple may require justification for ATS exceptions during App Store submission. If available, record that evidence in the report as contextual information only.
* 観測期待: The output should contain any TLS policy exceptions configured under NSAppTransportSecurity, if present.
```

## ナレッジベース

### DO: TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する
- 検証スキップ経路があれば fail とする
- 関連弱点 MASWE-0026 の有無をチケットへ併記する
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
- MASTG-TEST-0342 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0342/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
