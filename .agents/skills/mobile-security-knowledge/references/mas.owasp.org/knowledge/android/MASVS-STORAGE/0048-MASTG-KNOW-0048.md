---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0048/
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
mastg_know_id: MASTG-KNOW-0048
masvs_category: MASVS-STORAGE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0048: KeyChain

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「KeyChain」（Android / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: The KeyChain class is used to store and retrieve _system-wide_ private keys and their corresponding certificates (chain). The user will be prompted to set a lock screen pin or password to protect the credential storage if something is being imported into the KeyChain for the first time. Note that the KeyChain is system-wide, every application can access the materials stored in the KeyChain.
* 要旨: Inspect the source code to determine whether native Android mechanisms identify sensitive information. Sensitive information should be encrypted, not stored in clear text. For sensitive information that must be stored on the device, several API calls are available to protect the data via the KeyChain class. Complete the following steps:

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0048/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## KeyChainの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### KeyChainの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### KeyChainの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Make sure that the app is using the Android KeyStore and Cipher mechanisms to securely store encrypted information on the device. Look for the patterns AndroidKeystore, import java.security.KeyStor...
* Use the store(OutputStream stream, char[] password) function to store the KeyStore to disk with a password. Make sure that the password is provided by the user, not hard-coded.
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない
- Make sure that the app is using the Android KeyStore and Cipher mechanisms to securely store encrypted information on the device. Look for the patterns AndroidKeystore, import java.security.KeyStore, import javax.crypto.Cipher, import java.security.SecureRandom, and corresponding usages.
- Use the store(OutputStream stream, char[] password) function to store the KeyStore to disk with a password. Make sure that the password is provided by the user, not hard-coded.
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
- 変更レビューで MASTG-KNOW-0048 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0048/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
