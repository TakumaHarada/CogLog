---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0008/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0008
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0008: Debugging Disabled for WebViews

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Debugging Disabled for WebViews」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Ensure that WebView debugging is disabled in production builds to prevent attackers from exploiting this feature to eavesdrop, modify, or debug communication within WebViews.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0008/>
* 関連 Knowledge: `MASTG-KNOW-0018`
* 索引: [`../0000-index.md`](../0000-index.md)

## Debugging Disabled for WebViewsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Debugging Disabled for WebViewsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Debugging Disabled for WebViewsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Ensure that WebView debugging is disabled in production builds to prevent attackers from exploiting this feature to eavesdrop, modify, or debug communication within WebViews.
* Set WebView.setWebContentsDebuggingEnabled to false in production, or remove the calls entirely if they are unnecessary.
* If WebView debugging is required during development, ensure it is enabled only when the app is in a debuggable state by checking the ApplicationInfo.FLAG_DEBUGGABLE flag at runtime.
* Patch the app to add calls to these APIs (see @MASTG-TECH-0038), then repackage and re-sign it (see @MASTG-TECH-0039).
* Use runtime method hooking (see @MASTG-TECH-0043) to enable WebView debugging dynamically at runtime.
* 公式記事内のコード例言語: kotlin
```

## ナレッジベース

### DO: Debugging Disabled for WebViews を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Debugging Disabled for WebViews を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0018）と合わせてレビューする
- Ensure that WebView debugging is disabled in production builds to prevent attackers from exploiting this feature to eavesdrop, modify, or debug communication within WebViews.
- Set WebView.setWebContentsDebuggingEnabled to false in production, or remove the calls entirely if they are unnecessary.
- If WebView debugging is required during development, ensure it is enabled only when the app is in a debuggable state by checking the ApplicationInfo.FLAG_DEBUGGABLE flag at runtime.
```

### DO NOT: MASTG-BEST-0008 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 本番で WebView リモートデバッグを有効にする

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0008 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0008/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
