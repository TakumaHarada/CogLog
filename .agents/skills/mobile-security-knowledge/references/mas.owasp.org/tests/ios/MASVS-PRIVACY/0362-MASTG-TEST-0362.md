---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0362/
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
mastg_test_id: MASTG-TEST-0362
masvs_category: MASVS-PRIVACY
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0362: Entitlements for Unjustified Capability Exposure

## 概要

* 本ドキュメントは OWASP MASTG Test「Entitlements for Unjustified Capability Exposure」（iOS / プライバシー）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Entitlements are signed rights or privileges that enable an iOS app or app extension to use specific platform services, capabilities, or system integrations. Unlike purpose strings, entitlements are not limited to protected resources or user-facing privacy prompts. Some entitlements are mainly functional or security-related, while others may affect privacy by enabling access to personal data, shared containers, cloud data, home data, network c...
* メタ: type: static, package, manual; profiles: P; weakness: MASWE-0066; knowledge: MASTG-KNOW-0077
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0362/>
* 関連制御群: `MASVS-PRIVACY`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Entitlements for Unjustified Capability Exposureのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Entitlements for Unjustified Capability Exposureのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Entitlements for Unjustified Capability Exposureのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to unzip the app package.
* Use MASTG-TECH-0111 to extract entitlements from the app binaries, including the main app and app extensions.
* Use MASTG-TECH-0066 to look for framework APIs, shared container APIs, identifiers, or system entry points related to the identified entitlements.
* > The entitlements signed into the app binary are the reliable source, because they are present regardless of how the app was built or signed. The embedded.mobileprovision file can carry the same entitlements, but it ...
合否（Evaluation）の要点:
* The test case fails if the collected evidence shows that the app is signed with an entitlement without a reasonable connection to a user-visible feature, or if the entitlement creates a broader privacy-relevant capabi...
* Further Validation Required:
* Use the signed entitlements, referenced APIs, app metadata, visible app features, and relevant identifiers to determine whether each entitlement is justified, prioritizing entitlements that affect personal data, share...
* Consider the following when evaluating:
* Is the entitlement and its related API surface reasonably connected to the app's stated purpose or visible functionality?
* Does the entitlement create a personal data access, shared storage, cross-app communication, or system integration surface that is broader or more sensitive than the feature requires?
* 観測期待: The output should contain:
```

## ナレッジベース

### DO: 権限・収集・申告の一致を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 権限・収集・申告の一致を確認する
- 関連弱点 MASWE-0066 の有無をチケットへ併記する
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
- MASTG-TEST-0362 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0362/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
