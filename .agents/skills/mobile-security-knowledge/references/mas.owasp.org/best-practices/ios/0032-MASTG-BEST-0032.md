---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0032/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0032
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0032: Migrate from UIWebView to WKWebView

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Migrate from UIWebView to WKWebView」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Apple deprecated UIWebView in iOS 12 in favor of WKWebView for better security and performance. Migrate your app to WKWebView to benefit from its improved security features, such as out-of-process rendering and enhanced JavaScript control. WKWebView allows you to disable JavaS...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0032/>
* 関連 Knowledge: `MASTG-KNOW-0076`
* 索引: [`../0000-index.md`](../0000-index.md)

## Migrate from UIWebView to WKWebViewを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Migrate from UIWebView to WKWebViewを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Migrate from UIWebView to WKWebViewを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Apple deprecated UIWebView in iOS 12 in favor of WKWebView for better security and performance. Migrate your app to WKWebView to benefit from its improved security features, such as out-of-process rendering and enhanced JavaScript control. WKWebView allows you to disable JavaScript entirely, preventing script injection vulnerabilities, and provides better isolation between web content and the app, reducing the risk of memory corruption affecting the main app process. Additionally, WKWebView supports modern web security features like Content Security Policy (CSP), which can further enhance the security of your web content.
```

## ナレッジベース

### DO: Migrate from UIWebView to WKWebView を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Migrate from UIWebView to WKWebView を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0076）と合わせてレビューする
- Apple deprecated UIWebView in iOS 12 in favor of WKWebView for better security and performance. Migrate your app to WKWebView to benefit from its improved security features, such as out-of-process rendering and enhanced JavaScript control. WKWebView allows you to disable JavaScript entirely, preventing script injection vulnerabilities, and provides better isolation between web content and the app, reducing the risk of memory corruption affecting the main app process. Additionally, WKWebView supports modern web security features like Content Security Policy (CSP), which can further enhance the security of your web content.
```

### DO NOT: MASTG-BEST-0032 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 非推奨 UIWebView を新規採用・残置する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0032 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0032/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
