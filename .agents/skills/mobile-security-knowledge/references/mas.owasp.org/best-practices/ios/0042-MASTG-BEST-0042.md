---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0042/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0042
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0042: Use Strong TLS Settings in ATS Configuration

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Use Strong TLS Settings in ATS Configuration」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: App Transport Security (ATS) enforces strong TLS defaults for URLSession connections on iOS 9 and later. Avoid weakening these defaults through ATS exceptions in Info.plist, and ensure any custom TLS configuration in code is equally strong.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0042/>
* 関連 Knowledge: `MASTG-KNOW-0071`
* 索引: [`../0000-index.md`](../0000-index.md)

## Use Strong TLS Settings in ATS Configurationを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Use Strong TLS Settings in ATS Configurationを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Use Strong TLS Settings in ATS Configurationを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* App Transport Security (ATS) enforces strong TLS defaults for URLSession connections on iOS 9 and later. Avoid weakening these defaults through ATS exceptions in Info.plist, and ensure any custom TLS configuration in code is equally strong.
* Since iOS 26, URLSession and the Network framework now enforce a minimum TLS version of 1.2. ATS exceptions configured to allow TLS 1.0 or 1.1 are no longer accepted by the operating system.
* Target only the specific domain that requires the exception.
* Avoid setting NSIncludesSubdomains = true unless all subdomains require the exception.
* Do not set NSAllowsArbitraryLoads to true. This disables ATS for all connections to domains not listed in NSExceptionDomains, removing TLS version enforcement, certificate validation, and forward secrecy requirements for those domains. Per-domain exceptions in NSExceptionDomains still apply to their listed domains, but all unlisted domains have no ATS protection.
* Provide a justification in the app's App Store submission as required by Apple.
```

## ナレッジベース

### DO: Use Strong TLS Settings in ATS Configuration を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Use Strong TLS Settings in ATS Configuration を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0071）と合わせてレビューする
- App Transport Security (ATS) enforces strong TLS defaults for URLSession connections on iOS 9 and later. Avoid weakening these defaults through ATS exceptions in Info.plist, and ensure any custom TLS configuration in code is equally strong.
- Since iOS 26, URLSession and the Network framework now enforce a minimum TLS version of 1.2. ATS exceptions configured to allow TLS 1.0 or 1.1 are no longer accepted by the operating system.
- Target only the specific domain that requires the exception.
```

### DO NOT: MASTG-BEST-0042 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- ATS / TLS を全面緩和したまま本番公開する
- 証明書検証をスキップする

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0042 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0042/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
