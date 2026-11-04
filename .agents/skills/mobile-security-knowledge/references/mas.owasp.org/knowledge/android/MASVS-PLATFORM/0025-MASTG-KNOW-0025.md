---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0025/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0025
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0025: Explicit vs Implicit Intents

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Explicit vs Implicit Intents」（Android / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: An Intent is a messaging object used to request an action from another app component. Intents support three fundamental use cases: starting an activity, starting a service, and delivering a broadcast. See for the broader Android IPC model.
* 要旨: Android provides two types of intents, as described in the Android documentation on intents and intent filters:

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0025/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Explicit vs Implicit Intentsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Explicit vs Implicit Intentsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Explicit vs Implicit Intentsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Explicit intents: specify which application will satisfy the intent by providing either the target app's package name or a fully qualified component class name. They are commonly used to start a co...
* Implicit intents: do not name a specific component. They declare an action, and optionally data and categories, that another app component can handle. For example, a caller can use an implicit inte...
* Action: the filter must declare the same action string as the intent.
* Category: all categories in the intent must be listed in the filter; the filter may declare additional categories.
* Data: the URI scheme, host, path, and MIME type must satisfy the constraints in the filter.
* 公式記事内のコード例言語: kotlin, xml
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- Explicit intents: specify which application will satisfy the intent by providing either the target app's package name or a fully qualified component class name. They are commonly used to start a component in the same app because the caller knows the target activity or service class.
- Implicit intents: do not name a specific component. They declare an action, and optionally data and categories, that another app component can handle. For example, a caller can use an implicit intent to show a location on a map without selecting a specific map app.
- Action: the filter must declare the same action string as the intent.
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
- 変更レビューで MASTG-KNOW-0025 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0025/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
