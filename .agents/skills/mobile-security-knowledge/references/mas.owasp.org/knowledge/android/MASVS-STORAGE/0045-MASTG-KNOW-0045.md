---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0045/
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
mastg_know_id: MASTG-KNOW-0045
masvs_category: MASVS-STORAGE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0045: Secure Key Import into Keystore

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Secure Key Import into Keystore」（Android / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Android 9 (API level 28) adds the ability to import keys securely into the AndroidKeystore. First, AndroidKeystore generates a key pair using PURPOSE_WRAP_KEY, which should also be protected with an attestation certificate. This pair aims to protect the Keys being imported to AndroidKeystore. The encrypted keys are generated as ASN.1-encoded message in the SecureKeyWrapper format, which also contains a description...
* 要旨: The code above presents the different parameters to be set when generating the encrypted keys in the SecureKeyWrapper format. Check the Android documentation on WrappedKeyEntry for more details.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0045/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## Secure Key Import into Keystoreの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Secure Key Import into Keystoreの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Secure Key Import into Keystoreの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* The algorithm parameter specifies the cryptographic algorithm with which the key is used
* The keySize parameter specifies the size, in bits, of the key, measuring in the normal way for the key's algorithm
* The digest parameter specifies the digest algorithms that may be used with the key to perform signing and verification operations
* 公式記事内のコード例言語: java
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない
- The algorithm parameter specifies the cryptographic algorithm with which the key is used
- The keySize parameter specifies the size, in bits, of the key, measuring in the normal way for the key's algorithm
- The digest parameter specifies the digest algorithms that may be used with the key to perform signing and verification operations
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
- 変更レビューで MASTG-KNOW-0045 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0045/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
