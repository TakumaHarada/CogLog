---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0012/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0012
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0012: Disable JavaScript in WebViews

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Disable JavaScript in WebViews」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Enabling JavaScript is not a vulnerability by itself. In real apps it is often required for legitimate functionality, such as rendering modern web applications, interactive account portals, support centers, payment or login flows, or hybrid app content built with web technolog...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0012/>
* 関連 Knowledge: `MASTG-KNOW-0018`
* 索引: [`../0000-index.md`](../0000-index.md)

## Disable JavaScript in WebViewsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Disable JavaScript in WebViewsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Disable JavaScript in WebViewsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Enabling JavaScript is not a vulnerability by itself. In real apps it is often required for legitimate functionality, such as rendering modern web applications, interactive account portals, support centers, payment or login flows, or hybrid app content built with web technologies. Frameworks such as Ionic and Capacitor are built around a WebView that runs JavaScript application code, and react-native-webview exists specifically to render web content in a native view.
* Android's guidance associates unsafe use of JavaScript enabled WebViews with cross-app scripting. JavaScript does increase the attack surface of a WebView, but severe cases typically happen when it is combined with one or more of the following conditions: loading untrusted or weakly validated content, exposing JavaScript bridges, allowing permissive file or content access, or using unsafe URL loading.
* Keep JavaScript disabled for WebViews that only display static or minimally interactive content. Good candidates include static help pages, legal text, release notes, or other controlled content that does not need client-side scripting.
* Only enable JavaScript when the WebView is intentionally used to run trusted web application logic. Good candidates include hybrid app screens, complex internal web apps, single-page applications, and web-based user experiences that depend on JavaScript to render or function.
* Only load expected and allowlisted origins.
* Validate scheme and host before calling loadUrl, shouldOverrideUrlLoading, or similar APIs.
* Disable file and content access unless they are strictly needed (@MASTG-BEST-0011 and @MASTG-BEST-0013).
* Avoid exposing JavaScript bridges to untrusted content (@MASTG-BEST-0035).
```

## ナレッジベース

### DO: Disable JavaScript in WebViews を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Disable JavaScript in WebViews を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0018）と合わせてレビューする
- Enabling JavaScript is not a vulnerability by itself. In real apps it is often required for legitimate functionality, such as rendering modern web applications, interactive account portals, support centers, payment or login flows, or hybrid app content built with web technologies. Frameworks such as Ionic and Capacitor are built around a WebView that runs JavaScript application code, and react-native-webview exists specifically to render web content in a native view.
- Android's guidance associates unsafe use of JavaScript enabled WebViews with cross-app scripting. JavaScript does increase the attack surface of a WebView, but severe cases typically happen when it is combined with one or more of the following conditions: loading untrusted or weakly validated content, exposing JavaScript bridges, allowing permissive file or content access, or using unsafe URL loading.
- Keep JavaScript disabled for WebViews that only display static or minimally interactive content. Good candidates include static help pages, legal text, release notes, or other controlled content that does not need client-side scripting.
```

### DO NOT: MASTG-BEST-0012 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 不要な WebView で JavaScript を常時有効にする

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0012 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0012/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
