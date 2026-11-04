---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0345/
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
mastg_test_id: MASTG-TEST-0345
masvs_category: MASVS-NETWORK
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0345: Embedded or Third-party TLS Stack Configuration

## 概要

* 本ドキュメントは OWASP MASTG Test「Embedded or Third-party TLS Stack Configuration」（iOS / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Some apps embed networking stacks that manage TLS independently from Apple's ATS-enforced URL Loading System. Examples include OpenSSL, BoringSSL, mbedTLS, curl, and gRPC. Since ATS doesn't apply to these libraries, any weak TLS configuration in them is not protected by ATS or URLSession settings.
* メタ: type: static, code, manual; profiles: L1, L2; weakness: MASWE-0026; knowledge: MASTG-KNOW-0073
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0345/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Embedded or Third-party TLS Stack Configurationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Embedded or Third-party TLS Stack Configurationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Embedded or Third-party TLS Stack Configurationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0082 to identify all bundled libraries.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
合否（Evaluation）の要点:
* The test case fails if any embedded TLS library is configured to:
* Allow TLS versions below 1.2.
* Use weak or deprecated cipher suites.
* Disable certificate verification or use a custom trust store without proper validation.
* Further Validation Required:
* Inspect each reported code location using MASTG-TECH-0076 to determine the TLS configuration settings in use.
* 観測期待: The output should contain a list of any identified third-party TLS library symbols and their locations in the app binary.
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
- MASTG-TEST-0345 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0345/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
