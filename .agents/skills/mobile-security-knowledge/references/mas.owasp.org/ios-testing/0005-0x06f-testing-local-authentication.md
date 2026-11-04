---
source: https://mas.owasp.org/MASTG/0x06f-Testing-Local-Authentication/
scopes:
  - test
  - ios
  - backend
  - mobile
  - authentication
  - security-review
  - implementation
  - mastg-ios-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-AUTH
---

# MASTG 0x06f: iOS Local Authentication

## 概要

本ドキュメントは MASTG「iOS Local Authentication」を蒸留したものである。Touch ID / Face ID / パスコードによるローカル認証は再開・ステップアップ用であり、ブール結果 alone ではバイパスされうる。Keychain アクセス制御またはサーバ再検証へ結びつける。

* 正本: <https://mas.owasp.org/MASTG/0x06f-Testing-Local-Authentication/>
* Knowledge: MASTG-KNOW-0056 / 0057 等
* Tests: `docs/security/mas.owasp.org/tests/ios/MASVS-AUTH/`

## LocalAuthentication の成功ブール alone で認可しない

`LocalAuthentication.framework` は成功可否を返す高水準 API である。秘密データの保護には Keychain のアクセス制御を使う。

### LocalAuthentication の成功ブール alone で認可しないの補足

* 利点: ランタイム改ざんによる「常に成功」を実害に繋げにくくする
* 注意点: 章および参照講演が、どちらの framework も制御としてはバイパスされうると述べる。最終的にはサーバ側も必須
* 適用範囲: アプリロック、機微操作、セッション再開
* 例外: オフラインで暗号的に保護されたデータのみ（根拠必須）

### LocalAuthentication の成功ブール alone で認可しないの実装例

```text
推奨
* Security.framework / Keychain ACL + biometry
* セッション再開はサーバトークン再検証
* 可能なら App Attest 等と組み合わせる

避ける
* if LAContext.evaluatePolicy success { showSecrets() }
* パスワードを端末保存してローカル照合のみ
```

## Touch ID / Face ID データをアプリが扱わない前提で設計する

指紋・顔データは Secure Enclave 側でありアプリへ露出しない。アプリは認証結果と鍵利用制約だけを扱う。

### Touch ID / Face ID データをアプリが扱わない前提で設計するの補足

* 利点: 生体テンプレート漏洩経路をアプリ実装から排除できる
* 注意点: 新規生体登録時の鍵無効化方針を決める
* 適用範囲: AUTH 実装
* 例外: なし

### Touch ID / Face ID データをアプリが扱わない前提で設計するの実装例

```text
確認
* LocalAuthentication vs Keychain ACL の選定理由
* 生体無効化・フォールバック（デバイスパスコード）方針
* ログアウト時の Keychain 削除
```

## ナレッジベース

### DO: ローカル認証 PR で「Keychain ACL またはサーバ step-up」を必須にする

```text
# 推奨
local_auth: FaceID/TouchID
binding: keychain_acl | server_step_up
```

### DO NOT: 生体ダイアログ表示をもって認証要件を充足とみなす

* 理由: 章がリモート強制または暗号プリミティブを要求している
* 理由: 成功ブールは攻撃者制御下で書き換えられうる

```text
# DO NOT: LAContext 成功だけで秘密画面を開く

# DO: 鍵操作またはサーバ認可に接続する
```

## 参考リンク

* iOS Local Authentication: <https://mas.owasp.org/MASTG/0x06f-Testing-Local-Authentication/>
* LocalAuthentication: <https://developer.apple.com/documentation/localauthentication>
