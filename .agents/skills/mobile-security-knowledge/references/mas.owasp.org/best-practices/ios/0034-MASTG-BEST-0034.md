---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0034/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0034
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0034: Validate WebView Input

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Validate WebView Input」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Always treat any data passed to a WKWebView as untrusted unless it is fully controlled by the app. This includes URLs loaded through load(_:)), local files loaded through loadFileURL), HTML passed to loadHTMLString), JavaScript passed to evaluateJavaScript), and any data inser...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0034/>
* 関連 Knowledge: `MASTG-KNOW-0076`
* 索引: [`../0000-index.md`](../0000-index.md)

## Validate WebView Inputを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Validate WebView Inputを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Validate WebView Inputを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Always treat any data passed to a WKWebView as untrusted unless it is fully controlled by the app. This includes URLs loaded through load(_:)), local files loaded through loadFileURL), HTML passed to loadHTMLString), JavaScript passed to evaluateJavaScript), and any data inserted into the rendered page.
* If the app loads a URL into a WKWebView, the URL should be parsed and validated against a strict allowlist of expected schemes, hosts, paths, and other relevant components. Do not allow attacker-controlled input, such as deep links, custom URL schemes, pasted text, or server-supplied values, to determine arbitrary WebView destinations.
```

## ナレッジベース

### DO: Validate WebView Input を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Validate WebView Input を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0076）と合わせてレビューする
- Always treat any data passed to a WKWebView as untrusted unless it is fully controlled by the app. This includes URLs loaded through load(_:)), local files loaded through loadFileURL), HTML passed to loadHTMLString), JavaScript passed to evaluateJavaScript), and any data inserted into the rendered page.
- If the app loads a URL into a WKWebView, the URL should be parsed and validated against a strict allowlist of expected schemes, hosts, paths, and other relevant components. Do not allow attacker-controlled input, such as deep links, custom URL schemes, pasted text, or server-supplied values, to determine arbitrary WebView destinations.
```

### DO NOT: MASTG-BEST-0034 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 機微入力のマスク / キャッシュ無効を省略する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0034 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0034/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
