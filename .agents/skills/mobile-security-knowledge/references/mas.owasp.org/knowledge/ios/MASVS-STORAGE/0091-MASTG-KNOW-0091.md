---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0091/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - storage
  - backend
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0091
masvs_category: MASVS-STORAGE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0091: File System APIs

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「File System APIs」（iOS / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: iOS apps can write data to the file system using various APIs, depending on the use case.
* 要旨: For internal app files, caches, exports, or simple background writes where the app fully controls the path and conflicts are unlikely, apps typically use FileManager.

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0091/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## File System APIsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### File System APIsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### File System APIsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* First, obtain the path using FileManager.default.urls(for:in:)). Use the for parameter to specify the directory, such as .documentDirectory or .libraryDirectory.
* Apps can also write to the temporary directory using the URL property temporaryDirectory and the file manager property temporaryDirectory. The system may purge this directory when the app isn't run...
* For files that persist longer than temporary files, but are still purgeable, apps can use the caches directory .cachesDirectory.
* For files that are needed for app operation but don't need to be exposed to the user, apps can use the application support directory .applicationSupportDirectory (typically configuration files, tem...
* Next, call createFile(atPath:contents:attributes:), providing the path, the data to write, and optional attributes such as the file protection level.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない
- First, obtain the path using FileManager.default.urls(for:in:)). Use the for parameter to specify the directory, such as .documentDirectory or .libraryDirectory.
- Apps can also write to the temporary directory using the URL property temporaryDirectory and the file manager property temporaryDirectory. The system may purge this directory when the app isn't running.
- For files that persist longer than temporary files, but are still purgeable, apps can use the caches directory .cachesDirectory.
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
- 変更レビューで MASTG-KNOW-0091 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0091/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
