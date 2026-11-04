---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0058/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0058
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0058: Restrict Native Functionality Exposed Through WebView Bridges

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Restrict Native Functionality Exposed Through WebView Bridges」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: When using WKWebView, native functionality can be exposed to JavaScript through message handlers registered via WKUserContentController.add(_:name:)). Any JavaScript running in the WebView can call window.webkit.messageHandlers.`name`.postMessage(...) to invoke the correspondi...

* 正本: `<https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0058/>`
* 関連 Knowledge: `MASTG-KNOW-0076`
* 索引: [`../0000-index.md`](../0000-index.md)

## Restrict Native Functionality Exposed Through WebView Bridgesを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Restrict Native Functionality Exposed Through WebView Bridgesを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Restrict Native Functionality Exposed Through WebView Bridgesを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* When using WKWebView, native functionality can be exposed to JavaScript through message handlers registered via WKUserContentController.add(_:name:)). Any JavaScript running in the WebView can call window.webkit.messageHandlers.`name`.postMessage(...) to invoke the corresponding native handler. If the handler exposes sensitive operations or data without proper validation, an attacker who can run JavaScript in the WebView (for example through content injection or XSS) can abuse it.
* Only expose the minimal native functionality that JavaScript actually needs. Avoid registering handlers that return sensitive data (such as credentials or API keys), trigger privileged operations, or allow arbitrary writes to storage. Handlers should implement narrow, purpose-built operations rather than generic dispatch mechanisms.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: Restrict Native Functionality Exposed Through WebView Bridges を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Restrict Native Functionality Exposed Through WebView Bridges を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0076）と合わせてレビューする
- When using WKWebView, native functionality can be exposed to JavaScript through message handlers registered via WKUserContentController.add(_:name:)). Any JavaScript running in the WebView can call window.webkit.messageHandlers.`name`.postMessage(...) to invoke the corresponding native handler. If the handler exposes sensitive operations or data without proper validation, an attacker who can run JavaScript in the WebView (for example through content injection or XSS) can abuse it.
- Only expose the minimal native functionality that JavaScript actually needs. Avoid registering handlers that return sensitive data (such as credentials or API keys), trigger privileged operations, or allow arbitrary writes to storage. Handlers should implement narrow, purpose-built operations rather than generic dispatch mechanisms.
```

### DO NOT: MASTG-BEST-0058 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- WebView ブリッジ経由で過剰なネイティブ機能を公開する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0058 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: `<https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0058/>`
* MASTG Best Practices 一覧: `<https://mas.owasp.org/MASTG/best-practices/>`
* MASTG Knowledge: `<https://mas.owasp.org/MASTG/knowledge/>`
* MASTG Tests: `<https://mas.owasp.org/MASTG/tests/>`
