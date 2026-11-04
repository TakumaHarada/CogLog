---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0262/
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
  - profile-p
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0262
masvs_category: MASVS-STORAGE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0262: References to Backup Configurations Not Excluding Sensitive Data

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Backup Configurations Not Excluding Sensitive Data」（Android / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test verifies whether apps correctly instruct the system to exclude sensitive files from backups by analyzing the app's AndroidManifest.xml and backup rule configuration files.
* メタ: type: static, code; profiles: L1, L2, P; weakness: MASWE-0006; knowledge: MASTG-KNOW-0050
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0262/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Backup Configurations Not Excluding Sensitive Dataのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Backup Configurations Not Excluding Sensitive Dataのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Backup Configurations Not Excluding Sensitive Dataのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0117 to obtain the AndroidManifest.xml.
* Use MASTG-TECH-0150 to obtain the relevant flag and attributes from the AndroidManifest.xml.
* Use MASTG-TECH-0007 to extract the backup_rules.xml or data_extraction_rules.xml file from the app package.
合否（Evaluation）の要点:
* The test case fails if the app allows sensitive data to be backed up. Specifically, if the following conditions are met:
* android:allowBackup="true" in the AndroidManifest.xml
* android:fullBackupContent="@xml/backup_rules" isn't declared in the AndroidManifest.xml (for Android 11 or lower)
* android:dataExtractionRules="@xml/data_extraction_rules" isn't declared in the AndroidManifest.xml (for Android 12 and higher)
* backup_rules.xml or data_extraction_rules.xml aren't present or don't exclude all sensitive files.
* 観測期待: The output should explicitly show:
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 関連弱点 MASWE-0006 の有無をチケットへ併記する
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
- MASTG-TEST-0262 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0262/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
