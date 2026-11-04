---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0108/
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
mastg_know_id: MASTG-KNOW-0108
masvs_category: MASVS-STORAGE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0108: App Sandbox Directories

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「App Sandbox Directories」（iOS / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: On iOS, each application gets a sandboxed folder to store its data. As per the iOS security model, an application's sandboxed folder cannot be accessed by another application. Additionally, the users do not have direct access to the iOS filesystem, thus preventing browsing or extraction of data from the filesystem.
* 要旨: There are several ways to access the app's sandboxed folder:

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0108/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## App Sandbox Directoriesの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### App Sandbox Directoriesの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### App Sandbox Directoriesの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* On any device - Only Debug Builds: You can use Xcode's Devices and Simulators window to download the app container.
* On the iOS Simulator - All Built-in Apps and Debug Builds: You can navigate to the app's sandboxed folder directly from the macOS filesystem.
* On a non-jailbroken device - Only Repackaged Apps or Debug Builds: You can use and after that, use to explore the app's directory structure.
* On a jailbroken device - All Apps:
* You can use SSH or a file explorer app to navigate the filesystem and access the sandboxed folder directly.
* 公式記事内のコード例言語: txt
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない
- On any device - Only Debug Builds: You can use Xcode's Devices and Simulators window to download the app container.
- On the iOS Simulator - All Built-in Apps and Debug Builds: You can navigate to the app's sandboxed folder directly from the macOS filesystem.
- On a non-jailbroken device - Only Repackaged Apps or Debug Builds: You can use and after that, use to explore the app's directory structure.
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
- 変更レビューで MASTG-KNOW-0108 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0108/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
