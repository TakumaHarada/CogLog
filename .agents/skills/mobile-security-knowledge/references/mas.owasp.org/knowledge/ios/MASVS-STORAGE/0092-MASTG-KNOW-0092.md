---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0092/
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
mastg_know_id: MASTG-KNOW-0092
masvs_category: MASVS-STORAGE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0092: Binary Data Storage

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Binary Data Storage」（iOS / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: NSData (static data objects) and NSMutableData (dynamic data objects) are typically used for data storage, but they are also useful for distributed objects applications, in which data contained in data objects can be copied or moved between applications.
* 要旨: When writing NSData objects using write(to:options:)), you can specify WritingOptions for file protection:

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0092/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## Binary Data Storageの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Binary Data Storageの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Binary Data Storageの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* noFileProtection: does not encrypt the file.
* completeFileProtection: ensures the file is encrypted and can only be accessed when the device is unlocked.
* completeFileProtectionUnlessOpen: ensures the file is encrypted and can only be accessed when the device is unlocked or the file is already open.
* completeFileProtectionUntilFirstUserAuthentication: ensures the file is encrypted and can only be accessed until the first user authentication after a reboot.
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない
- noFileProtection: does not encrypt the file.
- completeFileProtection: ensures the file is encrypted and can only be accessed when the device is unlocked.
- completeFileProtectionUnlessOpen: ensures the file is encrypted and can only be accessed when the device is unlocked or the file is already open.
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
- 変更レビューで MASTG-KNOW-0092 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0092/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
