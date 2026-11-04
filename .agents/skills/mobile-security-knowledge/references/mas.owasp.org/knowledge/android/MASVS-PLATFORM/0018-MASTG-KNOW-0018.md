---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0018/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0018
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0018: WebViews

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「WebViews」（Android / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: On Android versions prior to 4.4, WebViews used the WebKit rendering engine to display web pages. Since Android 4.4, WebViews have been based on Chromium, providing improved performance and compatibility. However, the pages are still stripped down to minimal functions; for example, pages don't have address bars.
* 要旨: WebViews are Android's embedded components which allow your app to open web pages within your application. In addition to mobile apps related threats, WebViews may expose your app to common web threats (e.g. XSS, Open Redirect, etc.).

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0018/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## WebViewsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### WebViewsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### WebViewsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Internal storage: the app's own internal storage.
* the entire external storage (SD card), if the app has the READ_EXTERNAL_STORAGE permission.
* only the app-specific directories (due to scoped storage restrictions) without any special permissions.
* entire media folders (including data from other apps) if the app has the READ_MEDIA_IMAGES or similar permissions.
* the entire external storage if the app has the MANAGE_EXTERNAL_STORAGE permission.
* 公式記事内のコード例言語: html, java, kotlin, kt
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- Internal storage: the app's own internal storage.
- the entire external storage (SD card), if the app has the READ_EXTERNAL_STORAGE permission.
- only the app-specific directories (due to scoped storage restrictions) without any special permissions.
```

### DO NOT: 不要な Deep Link を有効化する

* 理由: MASVS-PLATFORM の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- 不要な Deep Link を有効化する
- 信頼できないコンテンツを WebView で無制限に開く

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0018 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0018/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
