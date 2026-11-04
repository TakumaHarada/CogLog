---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0132/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0132
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0132: Android Activities

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Android Activities」（Android / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: An activity is an app component that provides a single screen with a user interface. An app typically implements one activity per screen, so an app with three screens implements three activities. Each activity extends the Activity class (or a subclass such as AppCompatActivity) and hosts the user interface elements of that screen, including fragments, views, and layouts.
* 要旨: Activities are a fundamental inter-process communication (IPC) entry points. Other apps and the system can start an activity by sending it an Intent, subject to manifest access controls such as android:exported and android:permission. This makes activity visibility directly relevant to the app's attack surface. See for the IPC model and for how implicit intents reach activities.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0132/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Android Activitiesの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Android Activitiesの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Android Activitiesの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* onCreate): initializes the activity and is where the user interface is usually built.
* onStart, onResume: the activity becomes visible and then interactive.
* onPause, onStop: the activity loses focus and then visibility.
* onDestroy: the activity is being removed; release resources here.
* onSaveInstanceState and onRestoreInstanceState: persist and restore transient UI state.
* 公式記事内のコード例言語: xml
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- onCreate): initializes the activity and is where the user interface is usually built.
- onStart, onResume: the activity becomes visible and then interactive.
- onPause, onStop: the activity loses focus and then visibility.
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
- 変更レビューで MASTG-KNOW-0132 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0132/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
