---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0346/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0346
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0346: References to APIs Hiding Sensitive Data in Text Input Fields

## 概要

* 本ドキュメントは OWASP MASTG Test「References to APIs Hiding Sensitive Data in Text Input Fields」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: If the app does not mask text input fields that contain sensitive data, such data may be visible to bystanders (shoulder surfing) or captured in screenshots and screen recordings. Marking a field as secure also keeps it on the system keyboard: iOS does not offer installed third-party (custom) keyboards for secure fields (see MASTG-KNOW-0141), so they never receive the typed characters.
* メタ: type: static, code, manual; profiles: L2; weakness: MASWE-0036; knowledge: MASTG-KNOW-0121, MASTG-KNOW-0141
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0346/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to APIs Hiding Sensitive Data in Text Input Fieldsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to APIs Hiding Sensitive Data in Text Input Fieldsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to APIs Hiding Sensitive Data in Text Input Fieldsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0065 to reverse engineer the app.
* Use MASTG-TECH-0066 to look for uses of the relevant APIs.
* Use MASTG-TECH-0076 to analyze the relevant code paths and determine whether sensitive data is stored in the input fields.
合否（Evaluation）の要点:
* The test case fails if the app uses text input fields to input sensitive data and these input fields are not masked. This occurs when:
* UIKit UITextField used for a password, PIN, or OTP does not have isSecureTextEntry set to true.
* SwiftUI TextField is used instead of SecureField for a password, PIN, or OTP field.
* It is not a failure if non-sensitive text input fields (for example, for a username or email address) are unmasked. Validating whether a text input field is used for sensitive data may require a review of the app's UI...
* This test may produce false negatives if the app uses custom text input controls that do not rely on standard classes such as UITextField or SecureField (for example in custom UI frameworks or game engines, or if text...
* 観測期待: The output should contain a list of locations where the app:
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0036 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 未使用入口をテスト対象外のまま放置する

* 理由: MASVS-PLATFORM の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 未使用入口をテスト対象外のまま放置する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0346 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0346/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
