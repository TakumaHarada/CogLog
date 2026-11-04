---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-AUTH/MASTG-KNOW-0001/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - auth
  - backend
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0001
masvs_category: MASVS-AUTH
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0001: Biometric Authentication

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Biometric Authentication」（Android / 認証・認可）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Android provides platform support for biometric authentication, such as fingerprint and face recognition, and exposes it to apps through the biometric APIs. At the framework level, Android includes support for face and fingerprint authentication, and device implementations can also support other biometric modalities. Biometric integration on Android is classified by biometric security, not only by modality. See th...
* 要旨: For app development, use the recommended Jetpack Biometric library, with the package name prefix androidx.biometric. This library provides compatibility wrappers around the platform biometric APIs and expands on the deprecated FingerprintManager API, with support back to Android 6.0 (API level 23).

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-AUTH/MASTG-KNOW-0001/>
* 関連制御群: `MASVS-AUTH`（認証・認可）

## Biometric Authenticationの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Biometric Authenticationの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-AUTH）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Biometric Authenticationの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* BIOMETRIC_STRONG: authentication using a Class 3 biometric.
* BIOMETRIC_WEAK: authentication using a Class 2 biometric.
* DEVICE_CREDENTIAL: authentication using the device screen lock credential, such as PIN, pattern, or password.
```

## ナレッジベース

### DO: 認証成功のブール値 alone で機微操作を許可しない

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 認証成功のブール値 alone で機微操作を許可しない
- Keystore/Keychain と紐づけた暗号操作を優先する
- サーバ側で最終認可する
- BIOMETRIC_STRONG: authentication using a Class 3 biometric.
- BIOMETRIC_WEAK: authentication using a Class 2 biometric.
- DEVICE_CREDENTIAL: authentication using the device screen lock credential, such as PIN, pattern, or password.
```

### DO NOT: 非推奨 API（例: FingerprintManager）を新規採用する

* 理由: MASVS-AUTH の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- 非推奨 API（例: FingerprintManager）を新規採用する
- 端末識別子 alone で認証する

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0001 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-AUTH/MASTG-KNOW-0001/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-AUTH`: <https://mas.owasp.org/MASVS/>
