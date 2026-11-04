---
source: https://mas.owasp.org/MASTG/0x05f-Testing-Local-Authentication/
scopes:
  - test
  - android
  - backend
  - mobile
  - authentication
  - security-review
  - implementation
  - mastg-android-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-AUTH
---

# MASTG 0x05f: Android Local Authentication

## 概要

本ドキュメントは MASTG「Android Local Authentication」を蒸留したものである。端末ローカルの PIN／パスワード／生体認証は「再開やステップアップ」用であり、リモートエンドポイントまたは暗号プリミティブ無しではバイパスされうる。

* 正本: <https://mas.owasp.org/MASTG/0x05f-Testing-Local-Authentication/>
* Knowledge: MASTG-KNOW-0001（Biometric Authentication）等
* Tests: `docs/security/mas.owasp.org/tests/android/MASVS-AUTH/`

## ローカル認証の結果だけで認可を完結させない

成功コールバックのブール値 alone で API や機微操作を通さない。サーバ検証または Keystore 鍵操作へ結びつける。

### ローカル認証の結果だけで認可を完結させないの補足

* 利点: Frida 等によるコールバック改ざん耐性が上がる
* 注意点: Confirm Credential / Biometric の両フローで同じ原則を適用する
* 適用範囲: アプリロック、機微画面、支払い・同意などのステップアップ
* 例外: 完全オフラインで暗号的に保護されたデータのみ扱う場合（設計根拠必須）

### ローカル認証の結果だけで認可を完結させないの実装例

```text
推奨パターン
* BiometricPrompt + CryptoObject で鍵利用を認可
* セッション再開は短命サーバトークン再検証
* 生体失敗時のフォールバック方針を脅威モデルで固定

避けるパターン
* if (biometricSuccess) showSecret()
* パスワードを端末に保存してローカル照合のみ
```

## Confirm Credential と Biometric を用途分離する

デバイス資格情報確認とアプリ固有の生体フローを混同しない。

### Confirm Credential と Biometric を用途分離するの補足

* 利点: API の保証範囲を誤解せずにテストできる
* 注意点: FingerprintManager は非推奨。Jetpack Biometric を使う
* 適用範囲: 実装選定、AUTH テスト
* 例外: なし

### Confirm Credential と Biometric を用途分離するの実装例

```text
確認
* androidx.biometric を使用しているか
* setInvalidatedByBiometricEnrollment 等の鍵無効化方針
* DEVICE_CREDENTIAL 併用の可否
```

## ナレッジベース

### DO: ローカル認証機能の PR で「サーバ再検証 or CryptoObject」のどちらかを必須にする

```text
# 推奨
local_auth: biometric
binding: CryptoObject | server_step_up
tests: MASVS-AUTH の現行 Test
```

### DO NOT: ローカル認証 UI の存在をもって認証要件を充足とみなす

* 理由: 章が「データが返らないローカル認証は容易にバイパスされる」と明記している
* 理由: クライアント改ざん前提の脅威モデルでは UI は信頼境界にならない

```text
# DO NOT: 生体ダイアログを出したので AUTH 完了

# DO: 鍵操作またはサーバ認可に接続する
```

## 参考リンク

* Android Local Authentication: <https://mas.owasp.org/MASTG/0x05f-Testing-Local-Authentication/>
* Biometric Auth Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-AUTH/MASTG-KNOW-0001/>
