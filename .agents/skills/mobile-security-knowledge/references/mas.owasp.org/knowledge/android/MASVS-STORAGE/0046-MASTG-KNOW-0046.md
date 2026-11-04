---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0046/
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
mastg_know_id: MASTG-KNOW-0046
masvs_category: MASVS-STORAGE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0046: BouncyCastle KeyStore

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「BouncyCastle KeyStore」（Android / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。新規実装の根拠にせず、代替 Knowledge を参照する。
* 要旨: Older Android versions don't include KeyStore, but they _do_ include the KeyStore interface from JCA (Java Cryptography Architecture). You can use KeyStores that implement this interface to ensure the secrecy and integrity of keys stored with KeyStore; BouncyCastle KeyStore (BKS) is recommended. All implementations are based on the fact that files are stored on the filesystem; all files are password-protected.
* 要旨: To create one, use the KeyStore.getInstance("BKS", "BC") method, where "BKS" is the KeyStore name (BouncyCastle Keystore) and "BC" is the provider (BouncyCastle). You can also use SpongyCastle as a wrapper and initialize the KeyStore as follows: KeyStore.getInstance("BKS", "SC").

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0046/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## BouncyCastle KeyStoreの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### BouncyCastle KeyStoreの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### BouncyCastle KeyStoreの実装・監査観点の実装例

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
- 変更レビューで MASTG-KNOW-0046 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0046/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
