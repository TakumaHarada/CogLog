---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0021/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0021
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0021: Ensure Proper Error and Exception Handling

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Ensure Proper Error and Exception Handling」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Secure exception and error handling in Android is about preventing the leakage of sensitive information, managing failures gracefully, and ensuring that errors do not compromise security. User-facing error messages should remain generic, while controlled logging is reserved fo...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0021/>
* 関連 Knowledge: `MASTG-KNOW-0010`
* 索引: [`../0000-index.md`](../0000-index.md)

## Ensure Proper Error and Exception Handlingを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Ensure Proper Error and Exception Handlingを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Ensure Proper Error and Exception Handlingを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Secure exception and error handling in Android is about preventing the leakage of sensitive information, managing failures gracefully, and ensuring that errors do not compromise security. User-facing error messages should remain generic, while controlled logging is reserved for developers. The OWASP DevGuide reinforces these principles with a focus on not disclosing internal details to end users, not disclosing sensitive user data to developers, and ensuring secure failure modes that do not weaken authentication or authorization.
* Avoid leaking sensitive information: Error messages shown to users should be generic and not reveal internal details. Logs should be sanitized to remove sensitive data and restricted to authorized personnel. The official Log Info Disclosure guidance warns against including sensitive data or stack traces in production logs and recommends sanitization and reduced verbosity.
* Fail securely: Exceptions must not weaken security controls. Any failure in security checks should result in a deny outcome, blocking the action rather than allowing weaker assumptions or insecure fallbacks. Security mechanisms should default to denying access until explicitly granted, since fail-open paths are a common attack vector.
* Validate strictly and abort on errors: Unexpected formats or values should be treated as errors. Do not continue in a partially verified state. For example, if a network call succeeds at the transport layer but fails validation at the application layer, processing must stop. If the validation fails, do not try to sanitize the data to make the validation succeed.
* "OWASP - Fail Securely"
* "OWASP - Improper Error Handling"
* "CWE-636 - Not Failing Securely ('Failing Open')"
```

## ナレッジベース

### DO: Ensure Proper Error and Exception Handling を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Ensure Proper Error and Exception Handling を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0010）と合わせてレビューする
- Secure exception and error handling in Android is about preventing the leakage of sensitive information, managing failures gracefully, and ensuring that errors do not compromise security. User-facing error messages should remain generic, while controlled logging is reserved for developers. The OWASP DevGuide reinforces these principles with a focus on not disclosing internal details to end users, not disclosing sensitive user data to developers, and ensuring secure failure modes that do not weaken authentication or authorization.
- Avoid leaking sensitive information: Error messages shown to users should be generic and not reveal internal details. Logs should be sanitized to remove sensitive data and restricted to authorized personnel. The official Log Info Disclosure guidance warns against including sensitive data or stack traces in production logs and recommends sanitization and reduced verbosity.
- Fail securely: Exceptions must not weaken security controls. Any failure in security checks should result in a deny outcome, blocking the action rather than allowing weaker assumptions or insecure fallbacks. Security mechanisms should default to denying access until explicitly granted, since fail-open paths are a common attack vector.
```

### DO NOT: MASTG-BEST-0021 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 例外メッセージに機微情報を含めユーザ／ログへ露出する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0021 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0021/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
