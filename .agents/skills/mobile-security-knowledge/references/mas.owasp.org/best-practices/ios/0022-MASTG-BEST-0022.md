---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0022/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0022
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0022: Disable Verbose and Debug Logging in Production Builds

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Disable Verbose and Debug Logging in Production Builds」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: When logging information, it's crucial to protect sensitive values and avoid exposing unnecessary implementation details.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0022/>
* 関連 Knowledge: `MASTG-KNOW-0101`
* 索引: [`../0000-index.md`](../0000-index.md)

## Disable Verbose and Debug Logging in Production Buildsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Disable Verbose and Debug Logging in Production Buildsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Disable Verbose and Debug Logging in Production Buildsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* When logging information, it's crucial to protect sensitive values and avoid exposing unnecessary implementation details.
* Use logging only for operational events that are necessary for support and monitoring. Production logs should be limited to high-level, non-sensitive events that are useful for monitoring and support. Good examples include a generic authentication failure, a network timeout, or an unexpected state transition.
* full request or response headers and bodies.
* authentication tokens, cookies, session identifiers, or API keys.
* usernames, email addresses, or other personal data unless strictly necessary and appropriately protected.
* full error objects, diagnostic context, attached metadata, nested causes, or stack traces.
* backend hostnames, staging endpoints, feature flags, or internal module and class names.
* certificate validation behavior, SSL pinning status, retry logic, or other network security details.
* 公式記事内のコード例言語: swift, objectivec
```

## ナレッジベース

### DO: Disable Verbose and Debug Logging in Production Builds を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Disable Verbose and Debug Logging in Production Builds を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0101）と合わせてレビューする
- When logging information, it's crucial to protect sensitive values and avoid exposing unnecessary implementation details.
- Use logging only for operational events that are necessary for support and monitoring. Production logs should be limited to high-level, non-sensitive events that are useful for monitoring and support. Good examples include a generic authentication failure, a network timeout, or an unexpected state transition.
- full request or response headers and bodies.
```

### DO NOT: MASTG-BEST-0022 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 本番ビルドに verbose / debug ログや機微データ出力を残す
- トークン・PII を Logcat / NSLog 相当へ出す

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0022 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0022/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
