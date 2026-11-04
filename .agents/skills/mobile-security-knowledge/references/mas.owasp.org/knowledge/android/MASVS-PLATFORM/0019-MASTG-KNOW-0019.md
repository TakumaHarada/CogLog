---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0019/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0019
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0019: Deep Links

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Deep Links」（Android / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: _Deep links_ are URIs of any scheme that take users directly to specific content in an app. An app can set up deep links by adding _intent filters_ on the Android Manifest and extracting data from incoming intents to navigate users to the correct activity.
* 要旨: For a large-scale analysis of how Android apps implement and handle deep links, see the research paper "Measuring the Insecurity of Mobile Deep Links of Android".

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0019/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Deep Linksの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Deep Linksの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Deep Linksの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Custom URL Schemes: , which are deep links that use any custom URL scheme, e.g. myapp:// (not verified by the OS).
* Android App Links: (Android 6.0 (API level 23) and higher), which are deep links that use the http:// and https:// schemes and contain the autoVerify attribute (which triggers OS verification).
* App Links only use http:// and https:// schemes, any other custom URL schemes are not allowed.
* App Links require a live domain to serve a Digital Asset Links file via HTTPS.
* App Links do not suffer from deep link collision since they don't show a disambiguation dialog when a user opens them.
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- Custom URL Schemes: , which are deep links that use any custom URL scheme, e.g. myapp:// (not verified by the OS).
- Android App Links: (Android 6.0 (API level 23) and higher), which are deep links that use the http:// and https:// schemes and contain the autoVerify attribute (which triggers OS verification).
- App Links only use http:// and https:// schemes, any other custom URL schemes are not allowed.
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
- 変更レビューで MASTG-KNOW-0019 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0019/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
