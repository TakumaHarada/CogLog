---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0001/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - storage
  - backend
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0001
masvs_category: MASVS-STORAGE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0001: Testing Local Storage for Sensitive Data

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Local Storage for Sensitive Data」（Android / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: This test case focuses on identifying potentially sensitive data stored by an application and verifying if it is securely stored. The following checks should be performed:
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0207, MASTG-TEST-0200, MASTG-TEST-0201, MASTG-TEST-0202, MASTG-TEST-0304, MASTG-TEST-0305, MASTG-TEST-0306; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0001/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Local Storage for Sensitive Dataのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Local Storage for Sensitive Dataのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Local Storage for Sensitive Dataのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] First of all, try to determine the kind of storage used by the Android app and to find out whether the app processes sensitive data insecurely.
* [Static] Check AndroidManifest.xml for read/write external storage permissions, for example, uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE".
* [Static] Check the source code for keywords and API calls that are used to store data:
* [Static] File permissions, such as:
* [Static] MODE_WORLD_READABLE or MODE_WORLD_WRITABLE: You should avoid using MODE_WORLD_WRITEABLE and MODE_WORLD_READABLE for files because any app will be able to read from or write to the files, even if they are stor...
* [Dynamic] Install and use the app, executing all functions at least once. Data can be generated when entered by the user, sent by the endpoint, or shipped with the app. Then complete the following:
* [Dynamic] Check both internal and external local storage for any files created by the application that contain sensitive data.
* [Dynamic] Identify development files, backup files, and old files that shouldn't be included with a production release.
合否（Evaluation）の要点:
* This test case focuses on identifying potentially sensitive data stored by an application and verifying if it is securely stored. The following checks should be performed:
* Be sure to trigger all possible functionality in the application (e.g. by clicking everywhere possible) in order to ensure data generation.
* Check all application generated and modified files and ensure that the storage method is sufficiently secure.
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 後継: MASTG-TEST-0207, MASTG-TEST-0200, MASTG-TEST-0201, MASTG-TEST-0202, MASTG-TEST-0304, MASTG-TEST-0305, MASTG-TEST-0306
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
- MASTG-TEST-0001 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0001/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
