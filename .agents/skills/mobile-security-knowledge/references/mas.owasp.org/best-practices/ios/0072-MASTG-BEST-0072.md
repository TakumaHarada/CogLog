---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0072/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0072
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0072: Validate Input Parameters in Universal Link Handlers

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Validate Input Parameters in Universal Link Handlers」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Validate and sanitize the path and query parameters of every incoming universal link before using them in security-sensitive operations. Universal link verification only proves that the request targets a domain your app is associated with (@MASTG-KNOW-0080); it does not valida...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0072/>
* 関連 Knowledge: `MASTG-KNOW-0080`
* 索引: [`../0000-index.md`](../0000-index.md)

## Validate Input Parameters in Universal Link Handlersを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Validate Input Parameters in Universal Link Handlersを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Validate Input Parameters in Universal Link Handlersを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Validate and sanitize the path and query parameters of every incoming universal link before using them in security-sensitive operations. Universal link verification only proves that the request targets a domain your app is associated with (@MASTG-KNOW-0080); it does not validate the rest of the URL. Anyone can craft a link to your verified domain with arbitrary path and query values and get the user to open it, so treat the webpageURL and its parameters as untrusted input.
* Apple makes this explicit in "Supporting universal links in your app": universal links are an entry point into your app, so validate all URL parameters, discard malformed URLs, and limit the actions a link can trigger to those that do not put the user's data at risk.
* Path traversal: a value like path=../../private/secrets.txt can escape intended directories if used in file operations. Resolve paths with URL.standardized and verify the result stays within the expected base directory. See @MASTG-BEST-0033 for secure file loading in WebViews.
* Script injection: a value like q=<script>alert(1)</script> can execute arbitrary JavaScript if rendered in a WKWebView. See @MASTG-BEST-0034 for WebView input validation guidance.
* Command or query injection: values interpolated into shell commands, SQL queries, or predicate strings can alter their logic. Use parameterized queries and avoid string interpolation for constructing commands.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: Validate Input Parameters in Universal Link Handlers を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Validate Input Parameters in Universal Link Handlers を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0080）と合わせてレビューする
- Validate and sanitize the path and query parameters of every incoming universal link before using them in security-sensitive operations. Universal link verification only proves that the request targets a domain your app is associated with (@MASTG-KNOW-0080); it does not validate the rest of the URL. Anyone can craft a link to your verified domain with arbitrary path and query values and get the user to open it, so treat the webpageURL and its parameters as untrusted input.
- Apple makes this explicit in "Supporting universal links in your app": universal links are an entry point into your app, so validate all URL parameters, discard malformed URLs, and limit the actions a link can trigger to those that do not put the user's data at risk.
- Path traversal: a value like path=../../private/secrets.txt can escape intended directories if used in file operations. Resolve paths with URL.standardized and verify the result stays within the expected base directory. See @MASTG-BEST-0033 for secure file loading in WebViews.
```

### DO NOT: MASTG-BEST-0072 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 外部入口の入力検証・送信元検証を省略する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0072 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0072/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
