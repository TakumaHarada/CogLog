---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0036/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0036
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0036: Use Cryptographic Binding for Biometric Authentication

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Use Cryptographic Binding for Biometric Authentication」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: For sensitive operations protected by biometric authentication, use BiometricPrompt.authenticate()) with a CryptoObject backed by an Android Keystore key configured with setUserAuthenticationRequired(true). This cryptographically binds the authentication result to the key oper...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0036/>
* 関連 Knowledge: `MASTG-KNOW-0001`
* 索引: [`../0000-index.md`](../0000-index.md)

## Use Cryptographic Binding for Biometric Authenticationを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Use Cryptographic Binding for Biometric Authenticationを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Use Cryptographic Binding for Biometric Authenticationを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* For sensitive operations protected by biometric authentication, use BiometricPrompt.authenticate()) with a CryptoObject backed by an Android Keystore key configured with setUserAuthenticationRequired(true). This cryptographically binds the authentication result to the key operation, ensuring that the sensitive operation can only proceed after successful biometric verification.
* Without a CryptoObject, authentication is event-bound and relies solely on the onAuthenticationSucceeded callback. This makes it susceptible to runtime logic manipulation, for example by hooking the callback to return success without actually passing biometric verification.
* setUserAuthenticationRequired(true)): requires the user to authenticate before the key can be used.
* setUserAuthenticationParameters(0, type)): a timeout of 0 requires authentication for every individual cryptographic operation. Avoid extended validity durations for sensitive operations, as the key remains usable for the entire validity window even if the device is later accessed by an unauthorized person.
```

## ナレッジベース

### DO: Use Cryptographic Binding for Biometric Authentication を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Use Cryptographic Binding for Biometric Authentication を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0001）と合わせてレビューする
- For sensitive operations protected by biometric authentication, use BiometricPrompt.authenticate()) with a CryptoObject backed by an Android Keystore key configured with setUserAuthenticationRequired(true). This cryptographically binds the authentication result to the key operation, ensuring that the sensitive operation can only proceed after successful biometric verification.
- Without a CryptoObject, authentication is event-bound and relies solely on the onAuthenticationSucceeded callback. This makes it susceptible to runtime logic manipulation, for example by hooking the callback to return success without actually passing biometric verification.
- setUserAuthenticationRequired(true)): requires the user to authenticate before the key can be used.
```

### DO NOT: MASTG-BEST-0036 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 生体認証成功のブール alone で機微操作を許可する
- 登録変更で鍵無効化しない

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0036 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0036/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
