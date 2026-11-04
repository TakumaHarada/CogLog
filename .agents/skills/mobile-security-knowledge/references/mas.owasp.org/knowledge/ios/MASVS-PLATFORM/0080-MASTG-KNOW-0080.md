---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0080/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0080
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0080: Universal Links

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Universal Links」（iOS / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Universal links are the iOS equivalent to Android App Links (aka. Digital Asset Links) and are used for deep linking. When tapping a universal link (to the app's website), the user will seamlessly be redirected to the corresponding installed app without going through Safari. If the app isn't installed, the link will open in Safari.
* 要旨: Universal links are standard web links (HTTP/HTTPS) and are not to be confused with custom URL schemes (), which originally were also used for deep linking.

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0080/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Universal Linksの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Universal Linksの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Universal Linksの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* tg://resolve?domain=fridadotre is a custom URL scheme and uses the tg:// scheme.
* https://telegram.me/fridadotre is a universal link and uses the https:// scheme.
* Unique: Unlike custom URL schemes, universal links can't be claimed by other apps, because they use standard HTTP or HTTPS links to the app's website. They were introduced as a way to _prevent_ URL...
* Secure: When users install the app, iOS downloads and checks a file (the Apple App Site Association or AASA) that was uploaded to the web server to make sure that the website allows the app to open...
* Flexible: Universal links work even when the app is not installed. Tapping a link to the website would open the content in Safari, as users expect.
* 公式記事内のコード例言語: json, text, xml
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- tg://resolve?domain=fridadotre is a custom URL scheme and uses the tg:// scheme.
- https://telegram.me/fridadotre is a universal link and uses the https:// scheme.
- Unique: Unlike custom URL schemes, universal links can't be claimed by other apps, because they use standard HTTP or HTTPS links to the app's website. They were introduced as a way to _prevent_ URL scheme hijacking attacks (an app installed after the original app may declare the same scheme and the system might target all new requests to the last installed app).
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
- 変更レビューで MASTG-KNOW-0080 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0080/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
