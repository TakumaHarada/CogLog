---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-AUTH/MASTG-KNOW-0056/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - auth
  - backend
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0056
masvs_category: MASVS-AUTH
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0056: Local Authentication Framework

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Local Authentication Framework」（iOS / 認証・認可）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: The Local Authentication framework provides facilities for requesting a passphrase or Touch ID authentication from users. Developers can display and utilize an authentication prompt by utilizing the function evaluatePolicy of the LAContext class.
* 要旨: Two available policies define acceptable forms of authentication:

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-AUTH/MASTG-KNOW-0056/>
* 関連制御群: `MASVS-AUTH`（認証・認可）

## Local Authentication Frameworkの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Local Authentication Frameworkの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-AUTH）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Local Authentication Frameworkの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* deviceOwnerAuthentication(Swift) or LAPolicyDeviceOwnerAuthentication(Objective-C): When available, the user is prompted to perform Touch ID authentication. If Touch ID is not activated, the device...
* deviceOwnerAuthenticationWithBiometrics (Swift) or LAPolicyDeviceOwnerAuthenticationWithBiometrics(Objective-C): Authentication is restricted to biometrics where the user is prompted for Touch ID.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: 認証成功のブール値 alone で機微操作を許可しない

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 認証成功のブール値 alone で機微操作を許可しない
- Keystore/Keychain と紐づけた暗号操作を優先する
- サーバ側で最終認可する
- deviceOwnerAuthentication(Swift) or LAPolicyDeviceOwnerAuthentication(Objective-C): When available, the user is prompted to perform Touch ID authentication. If Touch ID is not activated, the device passcode is requested instead. If the device passcode is not enabled, policy evaluation fails.
- deviceOwnerAuthenticationWithBiometrics (Swift) or LAPolicyDeviceOwnerAuthenticationWithBiometrics(Objective-C): Authentication is restricted to biometrics where the user is prompted for Touch ID.
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
- 変更レビューで MASTG-KNOW-0056 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-AUTH/MASTG-KNOW-0056/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-AUTH`: <https://mas.owasp.org/MASVS/>
