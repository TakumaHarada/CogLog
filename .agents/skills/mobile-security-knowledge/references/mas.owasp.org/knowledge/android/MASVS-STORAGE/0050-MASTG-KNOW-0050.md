---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0050/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - storage
  - backend
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0050
masvs_category: MASVS-STORAGE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0050: Backups

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Backups」（Android / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Android backups usually include copies of data and settings for all installed apps. Given its diverse ecosystem, Android supports many backup options:
* 要旨: - Stock Android has built-in USB backup facilities. When USB debugging is enabled, use the adb backup command (restricted since Android 12, requires android:debuggable=true in the AndroidManifest.xml) to create full data backups and backups of an app's data directory.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0050/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## Backupsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Backupsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Backupsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Stock Android has built-in USB backup facilities. When USB debugging is enabled, use the adb backup command (restricted since Android 12, requires android:debuggable=true in the AndroidManifest.xml...
* Google provides a "Back Up My Data" feature that backs up all app data to Google's servers.
* Two Backup APIs are available to app developers:
* Key/Value Backup (Backup API or Android Backup Service) uploads to the Android Backup Service cloud.
* Auto Backup for Apps: With Android 6.0 (API level 23) and above, Google added the "Auto Backup for Apps feature". This feature automatically syncs at most 25MB of app data with the user's Google Dr...
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない
- Stock Android has built-in USB backup facilities. When USB debugging is enabled, use the adb backup command (restricted since Android 12, requires android:debuggable=true in the AndroidManifest.xml) to create full data backups and backups of an app's data directory.
- Google provides a "Back Up My Data" feature that backs up all app data to Google's servers.
- Two Backup APIs are available to app developers:
```

### DO NOT: SharedPreferences / UserDefaults にパスワードを平文保存する

* 理由: MASVS-STORAGE の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- SharedPreferences / UserDefaults にパスワードを平文保存する
- バックアップ対象にトークンを残す

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0050 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0050/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
