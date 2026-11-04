---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0314/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - storage
  - backend
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0314
masvs_category: MASVS-STORAGE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0314: Runtime Monitoring of Text Fields Eligible for Keyboard Caching

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Monitoring of Text Fields Eligible for Keyboard Caching」（iOS / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test complements MASTG-TEST-0313. It monitors text inputs in the app at runtime, for example UITextField, UITextView or UISearchBar, and checks whether they are eligible for keyboard caching when the user enters sensitive information.
* メタ: type: dynamic, hooks; profiles: L2; weakness: MASWE-0036; knowledge: MASTG-KNOW-0100
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0314/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Monitoring of Text Fields Eligible for Keyboard Cachingのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Monitoring of Text Fields Eligible for Keyboard Cachingのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Monitoring of Text Fields Eligible for Keyboard Cachingのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0056 to install the app.
* Use MASTG-TECH-0095 to hook the relevant APIs.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
合否（Evaluation）の要点:
* The test case fails if any UI inputs that may handle sensitive values (for example, usernames, passwords, email addresses, credit card numbers, recovery codes) are eligible for keyboard caching. This occurs when:
* isSecureTextEntry is not enabled, or
* autocorrectionType is set to default or yes, or
* spellCheckingType is set to default or yes.
* Expected False Negatives:
* This test may produce false negatives if the app uses custom text input controls that do not rely on standard UIKit classes such as UITextField or UITextView (for example in custom UI frameworks or game engines), or i...
* 観測期待: The output should allow the tester to associate each text entry with the corresponding input field and its protection status. At minimum it should contain:
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 関連弱点 MASWE-0036 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 内部ストレージだから安全と一律 pass にする

* 理由: MASVS-STORAGE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 内部ストレージだから安全と一律 pass にする
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0314 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0314/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
