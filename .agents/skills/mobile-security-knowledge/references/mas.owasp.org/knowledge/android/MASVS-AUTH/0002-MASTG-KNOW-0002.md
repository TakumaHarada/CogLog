---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-AUTH/MASTG-KNOW-0002/
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
mastg_know_id: MASTG-KNOW-0002
masvs_category: MASVS-AUTH
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0002: FingerprintManager

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「FingerprintManager」（Android / 認証・認可）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。新規実装の根拠にせず、代替 Knowledge を参照する。
* 要旨: Android 6.0 (API level 23) introduced public APIs for authenticating users via fingerprint, but is deprecated in Android 9 (API level 28). Access to the fingerprint hardware is provided through the FingerprintManager class. An app can request fingerprint authentication by instantiating a FingerprintManager object and calling its authenticate method. The caller registers callback methods to handle possible outcomes...
* 要旨: You can achieve better security by using the fingerprint API in conjunction with the Android KeyGenerator class. With this approach, a symmetric key is stored in the Android KeyStore and unlocked with the user's fingerprint. For example, to enable user access to a remote service, an AES key is created which encrypts the authentication token. By calling setUserAuthenticationRequired(true) when creating the key, it ...

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-AUTH/MASTG-KNOW-0002/>
* 関連制御群: `MASVS-AUTH`（認証・認可）

## FingerprintManagerの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### FingerprintManagerの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-AUTH）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### FingerprintManagerの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* The permission must be requested in the Android Manifest:
* Fingerprint hardware must be available:
* The user must have a protected lock screen:
* At least one finger should be registered:
* The application should have permission to ask for a user fingerprint:
* 公式記事内のコード例言語: java
```

## ナレッジベース

### DO: 認証成功のブール値 alone で機微操作を許可しない

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 認証成功のブール値 alone で機微操作を許可しない
- Keystore/Keychain と紐づけた暗号操作を優先する
- サーバ側で最終認可する
- The permission must be requested in the Android Manifest:
- Fingerprint hardware must be available:
- The user must have a protected lock screen:
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
- 変更レビューで MASTG-KNOW-0002 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-AUTH/MASTG-KNOW-0002/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-AUTH`: <https://mas.owasp.org/MASVS/>
