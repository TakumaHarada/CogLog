---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0028/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0028
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0028: WebViews Cache Cleanup

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「WebViews Cache Cleanup」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Android WebViews cache data when the server responds with specific Cache-Control headers that instruct the browser to cache the content. If a WebView processes sensitive data, you should ensure that no residual information remains on the device (disk and/or RAM) once the WebVi...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0028/>
* 関連 Knowledge: （未リンク）
* 索引: [`../0000-index.md`](../0000-index.md)

## WebViews Cache Cleanupを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### WebViews Cache Cleanupを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### WebViews Cache Cleanupを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Android WebViews cache data when the server responds with specific Cache-Control headers that instruct the browser to cache the content. If a WebView processes sensitive data, you should ensure that no residual information remains on the device (disk and/or RAM) once the WebView is no longer required.
* Prefer server-side cache prevention by using headers such as Cache-Control: no-cache in API responses that contain sensitive data to instruct the webview not to cache.
* The first disadvantage is indiscriminately deleting all cached data, including non-sensitive items that actually benefit from the cache, such as bigger files like images.
* The second disadvantage is the lack of a guarantee that the clear method will always be called, particularly if the app process is killed abruptly. In this case, evaluation of prior cache clearing and active clearing would be required, such as at the next app start.
```

## ナレッジベース

### DO: WebViews Cache Cleanup を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- WebViews Cache Cleanup を該当機能に適用する
- Android WebViews cache data when the server responds with specific Cache-Control headers that instruct the browser to cache the content. If a WebView processes sensitive data, you should ensure that no residual information remains on the device (disk and/or RAM) once the WebView is no longer required.
- Prefer server-side cache prevention by using headers such as Cache-Control: no-cache in API responses that contain sensitive data to instruct the webview not to cache.
- The first disadvantage is indiscriminately deleting all cached data, including non-sensitive items that actually benefit from the cache, such as bigger files like images.
```

### DO NOT: MASTG-BEST-0028 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- ログアウト後も WebView キャッシュに機微データを残す

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0028 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0028/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
