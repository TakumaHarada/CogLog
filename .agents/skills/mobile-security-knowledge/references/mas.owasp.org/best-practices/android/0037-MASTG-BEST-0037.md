---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0037/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0037
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0037: Invalidate Biometric Keys on Enrollment Changes

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Invalidate Biometric Keys on Enrollment Changes」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: When generating cryptographic keys for biometric authentication, ensure keys are invalidated when new biometrics are enrolled. Either configure setInvalidatedByBiometricEnrollment(true)) explicitly, or rely on the default behavior, which invalidates keys when setUserAuthentica...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0037/>
* 関連 Knowledge: `MASTG-KNOW-0001`
* 索引: [`../0000-index.md`](../0000-index.md)

## Invalidate Biometric Keys on Enrollment Changesを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Invalidate Biometric Keys on Enrollment Changesを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Invalidate Biometric Keys on Enrollment Changesを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* When generating cryptographic keys for biometric authentication, ensure keys are invalidated when new biometrics are enrolled. Either configure setInvalidatedByBiometricEnrollment(true)) explicitly, or rely on the default behavior, which invalidates keys when setUserAuthenticationRequired(true) is set.
* When setInvalidatedByBiometricEnrollment(false) is used, a key remains valid even after new biometrics are enrolled. An attacker who obtains the device passcode could enroll a new biometric and use it to access existing encrypted data or trigger sensitive operations.
```

## ナレッジベース

### DO: Invalidate Biometric Keys on Enrollment Changes を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Invalidate Biometric Keys on Enrollment Changes を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0001）と合わせてレビューする
- When generating cryptographic keys for biometric authentication, ensure keys are invalidated when new biometrics are enrolled. Either configure setInvalidatedByBiometricEnrollment(true)) explicitly, or rely on the default behavior, which invalidates keys when setUserAuthenticationRequired(true) is set.
- When setInvalidatedByBiometricEnrollment(false) is used, a key remains valid even after new biometrics are enrolled. An attacker who obtains the device passcode could enroll a new biometric and use it to access existing encrypted data or trigger sensitive operations.
```

### DO NOT: MASTG-BEST-0037 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 生体認証成功のブール alone で機微操作を許可する
- 登録変更で鍵無効化しない

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0037 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0037/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
