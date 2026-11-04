---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0033/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0033
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0033: Securely Load File Content in a WebView

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Securely Load File Content in a WebView」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: For WKWebView, allowFileAccessFromFileURLs and allowUniversalAccessFromFileURLs are not part of the public iOS WKWebView API. They are commonly accessed through Key-Value Coding (KVC), but should remain disabled unless there is a specific, well justified need.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0033/>
* 関連 Knowledge: `MASTG-KNOW-0076`
* 索引: [`../0000-index.md`](../0000-index.md)

## Securely Load File Content in a WebViewを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Securely Load File Content in a WebViewを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Securely Load File Content in a WebViewを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* For WKWebView, allowFileAccessFromFileURLs and allowUniversalAccessFromFileURLs are not part of the public iOS WKWebView API. They are commonly accessed through Key-Value Coding (KVC), but should remain disabled unless there is a specific, well justified need.
* If you must enable these properties, ensure that:
* The WebView only loads trusted content from controlled sources.
* Proper input validation and sanitization are implemented.
* The app does not store sensitive data in locations accessible to the WebView.
* For WKWebView, setting baseURL to nil gives the document an opaque origin. This prevents it from being treated as same origin with local files and helps stop access to other local resources.
* If the page needs bundled subresources such as CSS, images, or JavaScript, prefer loadFileURL(_:allowingReadAccessTo:)) or loadFileRequest(_:allowingReadAccessTo:)) with a narrowly scoped read access URL.
* If you do use a file:// base URL, keep it limited to a controlled resource location such as the app bundle.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: Securely Load File Content in a WebView を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Securely Load File Content in a WebView を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0076）と合わせてレビューする
- For WKWebView, allowFileAccessFromFileURLs and allowUniversalAccessFromFileURLs are not part of the public iOS WKWebView API. They are commonly accessed through Key-Value Coding (KVC), but should remain disabled unless there is a specific, well justified need.
- If you must enable these properties, ensure that:
- The WebView only loads trusted content from controlled sources.
```

### DO NOT: MASTG-BEST-0033 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 信頼できないローカルファイルを WebView で無検証ロードする

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0033 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0033/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
