---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0004/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0004
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0004: Exclude Sensitive Data from Backups

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Exclude Sensitive Data from Backups」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: For the sensitive files found, instruct the system to exclude them from the backup:

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0004/>
* 関連 Knowledge: `MASTG-KNOW-0050`
* 索引: [`../0000-index.md`](../0000-index.md)

## Exclude Sensitive Data from Backupsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Exclude Sensitive Data from Backupsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Exclude Sensitive Data from Backupsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* For the sensitive files found, instruct the system to exclude them from the backup:
* If you are using Auto Backup, mark them with the exclude tag in backup_rules.xml (for Android 11 or lower using android:fullBackupContent) or data_extraction_rules.xml (for Android 12 and higher using android:dataExtractionRules), depending on the target API. Make sure to use both the cloud-backup and device-transfer parameters.
* If you are using the key-value approach, set up your BackupAgent accordingly.
```

## ナレッジベース

### DO: Exclude Sensitive Data from Backups を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Exclude Sensitive Data from Backups を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0050）と合わせてレビューする
- For the sensitive files found, instruct the system to exclude them from the backup:
- If you are using Auto Backup, mark them with the exclude tag in backup_rules.xml (for Android 11 or lower using android:fullBackupContent) or data_extraction_rules.xml (for Android 12 and higher using android:dataExtractionRules), depending on the target API. Make sure to use both the cloud-backup and device-transfer parameters.
- If you are using the key-value approach, set up your BackupAgent accordingly.
```

### DO NOT: MASTG-BEST-0004 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 機微ファイルをバックアップ対象のままにする
- allowBackup / 包括バックアップを無制限にする

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0004 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0004/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
