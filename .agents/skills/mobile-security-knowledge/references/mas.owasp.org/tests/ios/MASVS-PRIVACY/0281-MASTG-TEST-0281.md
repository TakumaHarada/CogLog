---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0281/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - privacy
  - profile-p
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0281
masvs_category: MASVS-PRIVACY
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0281: Undeclared Known Tracking Domains

## 概要

* 本ドキュメントは OWASP MASTG Test「Undeclared Known Tracking Domains」（iOS / プライバシー）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test identifies whether the app properly declares all known tracking domains it may communicate with in the NSPrivacyTrackingDomains section of its Privacy Manifest files.
* メタ: type: static, dynamic; profiles: P; weakness: MASWE-0074
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0281/>
* 関連制御群: `MASVS-PRIVACY`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Undeclared Known Tracking Domainsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Undeclared Known Tracking Domainsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Undeclared Known Tracking Domainsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
* Use MASTG-TECH-0071 to search for hardcoded strings representing known tracking domains.
* Use MASTG-TECH-0136 to extract the app's privacy manifest files, including those from third-party SDKs or frameworks.
* Use MASTG-TECH-0137 to obtain the list of declared tracking domains from the privacy manifest files.
* Use MASTG-TECH-0062 to intercept and log all outbound network traffic.
合否（Evaluation）の要点:
* The test case fails if any of the following is missing in the privacy manifest files' NSPrivacyTrackingDomains key for the app or any of its components (Frameworks, Plugins, etc.):
* Tracking domains contacted by the app at runtime.
* Tracking domains found in the code.
* Domains corresponding to tracking SDKs found in the code.
* 観測期待: The output should contain:
```

## ナレッジベース

### DO: 権限・収集・申告の一致を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 権限・収集・申告の一致を確認する
- 関連弱点 MASWE-0074 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: ストア文言だけで privacy pass にする

* 理由: MASVS-PRIVACY の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- ストア文言だけで privacy pass にする
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0281 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0281/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
