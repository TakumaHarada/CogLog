---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0102/
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
mastg_know_id: MASTG-KNOW-0102
masvs_category: MASVS-STORAGE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0102: Backups

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Backups」（iOS / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: iOS includes auto-backup features that create copies of the data stored on the device. You can make iOS backups from your host computer by using iTunes (till macOS Catalina) or Finder (from macOS Catalina onwards), or via the iCloud backup feature. In both cases, the backup includes nearly all data stored on the iOS device except highly sensitive data such as Apple Pay information and Touch ID settings.
* 要旨: Since iOS backs up installed apps and their data, an obvious concern is whether sensitive user data stored by the app might unintentionally leak through the backup. Another concern, though less obvious, is whether sensitive configuration settings used to protect data or restrict app functionality could be tampered to change app behavior after restoring a modified backup. Both concerns are valid and these vulnerabi...

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0102/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## Backupsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Backupsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Backupsの実装・監査観点の実装例

```text
公式記事の API・設定説明を読み、次を確認する。
* 機微データは内部ストレージまたは Keystore/Keychain へ
* ログ・バックアップ・スクショ・通知から秘密を除外する
* 外部ストレージへ秘密を書かない
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない

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
- 変更レビューで MASTG-KNOW-0102 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0102/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
