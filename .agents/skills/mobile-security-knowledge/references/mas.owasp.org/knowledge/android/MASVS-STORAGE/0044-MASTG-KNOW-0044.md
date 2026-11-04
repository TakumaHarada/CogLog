---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0044/
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
mastg_know_id: MASTG-KNOW-0044
masvs_category: MASVS-STORAGE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0044: Key Attestation

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Key Attestation」（Android / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: For applications that rely heavily on for business-critical operations, such as multi-factor authentication using cryptographic primitives and secure client-side storage of sensitive data, Android provides the Key Attestation feature, which helps analyze and verify the security of cryptographic material managed through the Android KeyStore. Starting with Android 8.0 (API level 26), key attestation became mandatory...
* 要旨: During key attestation, we can specify the alias of a key pair and, in return, receive a certificate chain that we can use to verify the properties of that key pair. If the chain's root certificate is the Google Hardware Attestation Root certificate and the hardware-backed key pair storage checks are satisfied, this provides assurance that the device supports hardware-level key attestation and that the key is stor...

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0044/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## Key Attestationの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Key Attestationの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Key Attestationの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* The server should initiate the key attestation process by generating a secure random number using a CSPRNG (Cryptographically Secure Random Number Generator) and sending it to the client as a chall...
* The client should call the setAttestationChallenge API with the challenge from the server, then retrieve the attestation certificate chain using the KeyStore.getCertificateChain method.
* The attestation response should be sent to the server for verification, and the following checks should be performed:
* Verify the certificate chain up to the root and perform certificate sanity checks, including validity, integrity, and trustworthiness. Check the Certificate Revocation Status List maintained by Goo...
* Check whether the root certificate is signed with the Google attestation root key, which makes the attestation process trustworthy.
* 公式記事内のコード例言語: json
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない
- The server should initiate the key attestation process by generating a secure random number using a CSPRNG (Cryptographically Secure Random Number Generator) and sending it to the client as a challenge.
- The client should call the setAttestationChallenge API with the challenge from the server, then retrieve the attestation certificate chain using the KeyStore.getCertificateChain method.
- The attestation response should be sent to the server for verification, and the following checks should be performed:
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
- 変更レビューで MASTG-KNOW-0044 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0044/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
