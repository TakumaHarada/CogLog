---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-AUTH/MASTG-KNOW-0057/
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
mastg_know_id: MASTG-KNOW-0057
masvs_category: MASVS-AUTH
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0057: Keychain Services

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Keychain Services」（iOS / 認証・認可）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: The iOS keychain APIs can (and should) be used to implement local authentication. During this process, the app stores either a secret authentication token or another piece of secret data identifying the user in the keychain. In order to authenticate to a remote service, the user must unlock the keychain using their passphrase or fingerprint to obtain the secret data.
* 要旨: The keychain allows saving items with the special SecAccessControl attribute, which will allow access to the item from the keychain only after the user has passed Touch ID authentication (or passcode, if such a fallback is allowed by attribute parameters).

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-AUTH/MASTG-KNOW-0057/>
* 関連制御群: `MASVS-AUTH`（認証・認可）

## Keychain Servicesの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Keychain Servicesの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-AUTH）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Keychain Servicesの実装・監査観点の実装例

```text
公式記事の API・設定説明を読み、次を確認する。
* 認証成功のブール値 alone で機微操作を許可しない
* Keystore/Keychain と紐づけた暗号操作を優先する
* サーバ側で最終認可する
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
- 変更レビューで MASTG-KNOW-0057 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-AUTH/MASTG-KNOW-0057/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-AUTH`: <https://mas.owasp.org/MASVS/>
