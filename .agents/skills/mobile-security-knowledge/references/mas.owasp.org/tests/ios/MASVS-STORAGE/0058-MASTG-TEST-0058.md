---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0058/
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
mastg_test_id: MASTG-TEST-0058
masvs_category: MASVS-STORAGE
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0058: Testing Backups for Sensitive Data

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Backups for Sensitive Data」（iOS / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: A backup of a device on which a mobile application has been installed will include all subdirectories (except for Library/Caches/) and files in the app's private directory.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0215, MASTG-TEST-0298; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0058/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Backups for Sensitive Dataのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Backups for Sensitive Dataのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Backups for Sensitive Dataのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] A backup of a device on which a mobile application has been installed will include all subdirectories (except for Library/Caches/) and files in the app's private directory.
* [Static] Therefore, avoid storing sensitive data in plaintext within any of the files or folders that are in the app's private directory or subdirectories.
* [Static] Although all the files in Documents/ and Library/Application Support/ are always backed up by default, you can exclude files from the backup by calling NSURL setResourceValue:forKey:error: with the NSURLIsExc...
* [Static] You can use the NSURLIsExcludedFromBackupKey and CFURLIsExcludedFromBackupKey file system properties to exclude files and directories from backups. An app that needs to exclude many files can do so by creatin...
* [Static] Both file system properties are preferable to the deprecated approach of directly setting an extended attribute. All apps running on iOS version 5.1 and later should use these properties to exclude data from ...
* [Dynamic] In order to test the backup, you obviously need to create one first. The most common way to create a backup of an iOS device is by using iTunes, which is available for Windows, Linux and of course macOS (til...
* [Dynamic] > iTunes is not available anymore from macOS Catalina onwards. Managing of an iOS device, including updates, backup and restore has been moved to the Finder app. The approach remains the same, as described a...
* [Dynamic] After the iOS device has been backed up, you need to retrieve the file path of the backup, which are different locations on each OS. The official Apple documentation will help you to locate backups of your i...
合否（Evaluation）の要点:
* Although all the files in Documents/ and Library/Application Support/ are always backed up by default, you can exclude files from the backup by calling NSURL setResourceValue:forKey:error: with the NSURLIsExcludedFrom...
* You can use the NSURLIsExcludedFromBackupKey and CFURLIsExcludedFromBackupKey file system properties to exclude files and directories from backups. An app that needs to exclude many files can do so by creating its own...
* Both file system properties are preferable to the deprecated approach of directly setting an extended attribute. All apps running on iOS version 5.1 and later should use these properties to exclude data from backups.
* return .failure(.fileDoesNotExist)
* return .failure(.error("Error excluding \(file.lastPathComponent) from backup \(error)"))
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 後継: MASTG-TEST-0215, MASTG-TEST-0298
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
- MASTG-TEST-0058 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0058/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
