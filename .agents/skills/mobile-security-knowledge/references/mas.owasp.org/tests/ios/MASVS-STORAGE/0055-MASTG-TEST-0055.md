---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0055/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - storage
  - backend
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0055
masvs_category: MASVS-STORAGE
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0055: Finding Sensitive Data in the Keyboard Cache

## 概要

* 本ドキュメントは OWASP MASTG Test「Finding Sensitive Data in the Keyboard Cache」（iOS / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: - Search through the source code for similar implementations, such as
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0313, MASTG-TEST-0314; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0055/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Finding Sensitive Data in the Keyboard Cacheのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Finding Sensitive Data in the Keyboard Cacheのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Finding Sensitive Data in the Keyboard Cacheのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Search through the source code for similar implementations, such as
* [Static] textObject.autocorrectionType = UITextAutocorrectionTypeNo;
* [Static] textObject.secureTextEntry = YES;
* [Static] Open xib and storyboard files in the Interface Builder of Xcode and verify the states of Secure Text Entry and Correction in the Attributes Inspector for the appropriate object.
* [Static] The application must prevent the caching of sensitive information entered into text fields. You can prevent caching by disabling it programmatically, using the textObject.autocorrectionType = UITextAutocorrec...
* [Dynamic] If a jailbroken iPhone is available, execute the following steps:
* [Dynamic] Reset your iOS device keyboard cache by navigating to Settings > General > Reset > Reset Keyboard Dictionary.
* [Dynamic] Use the application and identify the functionalities that allow users to enter sensitive data.
合否（Evaluation）の要点:
* The application must prevent the caching of sensitive information entered into text fields. You can prevent caching by disabling it programmatically, using the textObject.autocorrectionType = UITextAutocorrectionTypeN...
* Look for sensitive data, such as username, passwords, email addresses, and credit card numbers. If the sensitive data can be obtained via the keyboard cache file, the app fails this test.
* If you must use a non-jailbroken iPhone:
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 後継: MASTG-TEST-0313, MASTG-TEST-0314
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
- MASTG-TEST-0055 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0055/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
