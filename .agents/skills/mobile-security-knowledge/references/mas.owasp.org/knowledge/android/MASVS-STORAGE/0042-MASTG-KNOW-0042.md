---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0042/
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
mastg_know_id: MASTG-KNOW-0042
masvs_category: MASVS-STORAGE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0042: External Storage

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「External Storage」（Android / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Android devices support shared external storage. This storage may be removable (such as an SD card) or emulated (non-removable). A malicious app with proper permissions running on Android 10 or below can access data that you write to "external" app-specific-directories. The user can also modify these files when USB mass storage is enabled.
* 要旨: The files stored in these directories are removed when your app is uninstalled.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0042/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## External Storageの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### External Storageの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### External Storageの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* adb shell content query --uri content://media/external_primary/images/media
* adb shell content query --uri content://media/external_primary/file
* media files including images (MediaStore.Images), videos (MediaStore.Video), audio (MediaStore.Audio) and downloads (MediaStore.Downloads), and
* non-media files (e.g. text, HTML, PDF, etc.) stored in the MediaStore.Files collection.
* They can access the app-specific files that belong to other apps if they have opted out of scoped storage and requested the READ_EXTERNAL_STORAGE permission.
* 公式記事内のコード例言語: kotlin, sh
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない
- adb shell content query --uri content://media/external_primary/images/media
- adb shell content query --uri content://media/external_primary/file
- media files including images (MediaStore.Images), videos (MediaStore.Video), audio (MediaStore.Audio) and downloads (MediaStore.Downloads), and
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
- 変更レビューで MASTG-KNOW-0042 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0042/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
