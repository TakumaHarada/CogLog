---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0053/
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
mastg_test_id: MASTG-TEST-0053
masvs_category: MASVS-STORAGE
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0053: Checking Logs for Sensitive Data

## 概要

* 本ドキュメントは OWASP MASTG Test「Checking Logs for Sensitive Data」（iOS / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Use the following keywords to check the app's source code for predefined and custom logging statements:
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0296, MASTG-TEST-0297; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0053/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Checking Logs for Sensitive Dataのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Checking Logs for Sensitive Dataのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Checking Logs for Sensitive Dataのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Use the following keywords to check the app's source code for predefined and custom logging statements:
* [Static] For predefined and built-in functions:
* [Static] NSLog
* [Static] NSAssert
* [Static] NSCAssert
* [Dynamic] See MASTG-TECH-0060 and once you're set up, navigate to a screen that displays input fields that take sensitive user information.
* [Dynamic] After starting one of the methods, fill in the input fields. If sensitive data is displayed in the output, the app fails this test.
合否（Evaluation）の要点:
* Use the following keywords to check the app's source code for predefined and custom logging statements:
* After starting one of the methods, fill in the input fields. If sensitive data is displayed in the output, the app fails this test.
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 後継: MASTG-TEST-0296, MASTG-TEST-0297
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
- MASTG-TEST-0053 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0053/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
