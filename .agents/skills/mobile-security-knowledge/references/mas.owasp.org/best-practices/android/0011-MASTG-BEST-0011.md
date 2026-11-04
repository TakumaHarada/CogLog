---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0011/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0011
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0011: Securely Load File Content in a WebView

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Securely Load File Content in a WebView」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: The recommended approach to load file content to a WebView securely is to use WebViewClient with WebViewAssetLoader to load assets from the app's assets or resources directory using https:// URLs instead of insecure file:// URLs. This ensures the content is loaded in a secure,...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0011/>
* 関連 Knowledge: `MASTG-KNOW-0018`
* 索引: [`../0000-index.md`](../0000-index.md)

## Securely Load File Content in a WebViewを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Securely Load File Content in a WebViewを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Securely Load File Content in a WebViewを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* The recommended approach to load file content to a WebView securely is to use WebViewClient with WebViewAssetLoader to load assets from the app's assets or resources directory using https:// URLs instead of insecure file:// URLs. This ensures the content is loaded in a secure, same-origin environment and avoids exposing local files to potential cross-origin attacks.
* If you must allow the WebView to load local files using the file:// scheme, consider the following:
* For apps with a minSdkVersion that has secure defaults for WebView file access methods, ensure that these methods are not used and the default values are preserved. Alternatively, explicitly set them to false to guarantee the WebView does not allow local file access:
* setAllowFileAccess(false)
* setAllowFileAccessFromFileURLs(false)
* setAllowUniversalAccessFromFileURLs(false)
* For apps with a minSdkVersion that does not have secure defaults for these methods (e.g., older API levels), ensure that the above methods are explicitly set to false in your WebView configuration.
```

## ナレッジベース

### DO: Securely Load File Content in a WebView を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Securely Load File Content in a WebView を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0018）と合わせてレビューする
- The recommended approach to load file content to a WebView securely is to use WebViewClient with WebViewAssetLoader to load assets from the app's assets or resources directory using https:// URLs instead of insecure file:// URLs. This ensures the content is loaded in a secure, same-origin environment and avoids exposing local files to potential cross-origin attacks.
- If you must allow the WebView to load local files using the file:// scheme, consider the following:
- For apps with a minSdkVersion that has secure defaults for WebView file access methods, ensure that these methods are not used and the default values are preserved. Alternatively, explicitly set them to false to guarantee the WebView does not allow local file access:
```

### DO NOT: MASTG-BEST-0011 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 信頼できないローカルファイルを WebView で無検証ロードする

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0011 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0011/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
