---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0013/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0013
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0013: Disable Content Provider Access in WebViews

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Disable Content Provider Access in WebViews」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Unlike other file content access methods from WebSettings, the setAllowContentAccess method always defaults to true. Therefore, whenever access to content providers isn't explicitly needed, ensure that the setAllowContentAccess method is set to false to prevent WebViews from a...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0013/>
* 関連 Knowledge: `MASTG-KNOW-0018`
* 索引: [`../0000-index.md`](../0000-index.md)

## Disable Content Provider Access in WebViewsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Disable Content Provider Access in WebViewsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Disable Content Provider Access in WebViewsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Unlike other file content access methods from WebSettings, the setAllowContentAccess method always defaults to true. Therefore, whenever access to content providers isn't explicitly needed, ensure that the setAllowContentAccess method is set to false to prevent WebViews from accessing content providers.
* Enabling content access in a WebView is not a vulnerability per se; it increases the number of ways an attacker could chain vulnerabilities. For example, if combined with an XSS or other injection vulnerability (or if the WebView is used to display untrusted remote content), it can allow an attacker to read sensitive data that they can send back to a remote server.
```

## ナレッジベース

### DO: Disable Content Provider Access in WebViews を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Disable Content Provider Access in WebViews を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0018）と合わせてレビューする
- Unlike other file content access methods from WebSettings, the setAllowContentAccess method always defaults to true. Therefore, whenever access to content providers isn't explicitly needed, ensure that the setAllowContentAccess method is set to false to prevent WebViews from accessing content providers.
- Enabling content access in a WebView is not a vulnerability per se; it increases the number of ways an attacker could chain vulnerabilities. For example, if combined with an XSS or other injection vulnerability (or if the WebView is used to display untrusted remote content), it can allow an attacker to read sensitive data that they can send back to a remote server.
```

### DO NOT: MASTG-BEST-0013 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- WebView から無制限に ContentProvider へアクセスさせる

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0013 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0013/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
