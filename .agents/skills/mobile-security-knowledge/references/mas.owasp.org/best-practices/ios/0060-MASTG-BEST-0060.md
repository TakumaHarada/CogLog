---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0060/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0060
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0060: Use Native Views for Sensitive Text Entry Over a WebView

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Use Native Views for Sensitive Text Entry Over a WebView」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: When a WKWebView contains an HTML input[type=password] or any sensitive text field, the typed value is stored in the element's .value property. Any JavaScript running on the page, including injected XSS payloads, can read it with document.querySelector('input[type=password]...

* 正本: `<https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0060/>`
* 関連 Knowledge: `MASTG-KNOW-0076`, `MASTG-KNOW-0139`
* 索引: [`../0000-index.md`](../0000-index.md)

## Use Native Views for Sensitive Text Entry Over a WebViewを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Use Native Views for Sensitive Text Entry Over a WebViewを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Use Native Views for Sensitive Text Entry Over a WebViewを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* When a WKWebView contains an HTML `input type="password"` or any sensitive text field, the typed value is stored in the element's .value property. Any JavaScript running on the page, including injected XSS payloads, can read it with document.querySelector('input[type=password]').value. The page does not need a native bridge to do this.
* The safer approach is to intercept user focus on the sensitive field before any typing occurs, then present a native UITextField (configured with isSecureTextEntry = true) overlaid at the exact position of the HTML element. The user types into the native view and the value never enters the DOM.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: Use Native Views for Sensitive Text Entry Over a WebView を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Use Native Views for Sensitive Text Entry Over a WebView を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0076, MASTG-KNOW-0139）と合わせてレビューする
- When a WKWebView contains an HTML `input type="password"` or any sensitive text field, the typed value is stored in the element's .value property. Any JavaScript running on the page, including injected XSS payloads, can read it with document.querySelector('input[type=password]').value. The page does not need a native bridge to do this.
- The safer approach is to intercept user focus on the sensitive field before any typing occurs, then present a native UITextField (configured with isSecureTextEntry = true) overlaid at the exact position of the HTML element. The user types into the native view and the value never enters the DOM.
```

### DO NOT: MASTG-BEST-0060 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- WebView ブリッジ経由で過剰なネイティブ機能を公開する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0060 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: `<https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0060/>`
* MASTG Best Practices 一覧: `<https://mas.owasp.org/MASTG/best-practices/>`
* MASTG Knowledge: `<https://mas.owasp.org/MASTG/knowledge/>`
* MASTG Tests: `<https://mas.owasp.org/MASTG/tests/>`
