---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0363/
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
mastg_test_id: MASTG-TEST-0363
masvs_category: MASVS-PRIVACY
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0363: Runtime Use of Entitlement-Backed APIs for Unjustified Capability Exposure

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Use of Entitlement-Backed APIs for Unjustified Capability Exposure」（iOS / プライバシー）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test is the dynamic counterpart to MASTG-TEST-0362. See MASTG-TEST-0362 for background on the relationship between Xcode capabilities, signed entitlements, and entitlement-backed APIs or entry points.
* メタ: type: dynamic, hooks, manual; profiles: P; weakness: MASWE-0066; knowledge: MASTG-KNOW-0077
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0363/>
* 関連制御群: `MASVS-PRIVACY`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Use of Entitlement-Backed APIs for Unjustified Capability Exposureのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Use of Entitlement-Backed APIs for Unjustified Capability Exposureのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Use of Entitlement-Backed APIs for Unjustified Capability Exposureのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0056 to install the app.
* Use MASTG-TECH-0111 to extract entitlements from the app binaries, including the main app and app extensions.
* Use MASTG-TECH-0095 to hook the relevant entitlement-backed APIs, shared container APIs, and system entry points.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
合否（Evaluation）の要点:
* The test case fails if the collected evidence shows that the app uses an entitlement-backed API, shared container, or system entry point without a reasonable connection to a user-visible feature, or if the runtime beh...
* Further Validation Required:
* Use the observed runtime calls, trigger conditions, signed entitlements, app metadata, visible app features, relevant identifiers, and backtraces to determine whether each entitlement-backed runtime behavior is justif...
* Consider the following when evaluating:
* Is the observed entitlement-backed API or entry point reasonably connected to the user action or feature that triggered it?
* Does the observed runtime behavior create a personal data access, shared storage, cross-app communication, or system integration surface that is broader or more sensitive than the feature requires?
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
- MASTG-TEST-0363 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0363/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
