---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0383/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - code
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0383
masvs_category: MASVS-CODE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0383: References to Enforced Updating APIs

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Enforced Updating APIs」（iOS / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: iOS apps may fail to enforce updates when critical security patches or minimum version requirements are needed. Apple does not provide a public API to force install or silently update an App Store app, so apps must implement their own mechanism: either querying the App Store using the iTunes Search API (for example, <https://itunes.apple.com/lookup?bundleId=> or <https://itunes.apple.com/lookup?id=>, with an optional country parameter) and compari...
* メタ: type: static, code, manual; profiles: L2; weakness: MASWE-0043; knowledge: MASTG-KNOW-0074
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0383/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Enforced Updating APIsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Enforced Updating APIsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Enforced Updating APIsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from the app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
合否（Evaluation）の要点:
* The test case fails if no code locations show an update enforcement mechanism.
* Further Validation Required:
* Inspect each reported code location using MASTG-TECH-0076 to determine whether the update enforcement is correct:
* Determine whether the update check executes before access to protected functionality or backend services and cannot be bypassed (for example, by checking the call graph or app startup entry points such as AppDelegate....
* Determine whether the enforcement uses a non-dismissible blocking UI (for example, a UIAlertController without a dismiss action, or a gating view controller) or redirects to the App Store (via UIApplication.shared.ope...
* For App Store lookup flows, determine whether the app parses results[0].version from the iTunes lookup response and correctly enforces an update when the published version exceeds the installed version and the flow is...
* 観測期待: The output should contain a list of code locations where the app retrieves its version (for example, CFBundleShortVersionString or CFBundleVersion), compares it against a backend-supplied minimum or the latest App Store 
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 関連弱点 MASWE-0043 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: ビルド設定を見ずにコードレビューだけで完了する

* 理由: MASVS-CODE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- ビルド設定を見ずにコードレビューだけで完了する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0383 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0383/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
