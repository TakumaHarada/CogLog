---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0133/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0133
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0133: Android Services

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Android Services」（Android / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: A service is an app component that performs long-running operations in the background without a user interface, such as processing data, performing network transactions, or interacting with content providers. A service extends the Service class. Unless configured otherwise, a service runs in the main thread of its hosting process and does not create its own thread.
* 要旨: Services are an inter-process communication (IPC) entry point: other apps and the system can start or bind to a service through an Intent, subject to manifest access controls such as android:exported and android:permission. This makes service visibility directly relevant to the app's attack surface. See for the IPC model and the role of Binder.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0133/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Android Servicesの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Android Servicesの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Android Servicesの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Started services:: launched with startService) (or startForegroundService)) and run until they stop themselves or are stopped.
* Bound services:: other components bind to them with bindService) to interact through a client-server interface. A bound service must return an IBinder from onBind). See Bound services.
* Foreground services:: show an ongoing notification and are subject to foreground service type requirements introduced in recent Android versions.
* A Messenger, which serializes requests into Message objects delivered to a Handler. This is the simplest cross-process interface.
* The Android Interface Definition Language (AIDL), which generates the marshalling code for a remote interface and allows concurrent calls across processes.
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
- Started services:: launched with startService) (or startForegroundService)) and run until they stop themselves or are stopped.
- Bound services:: other components bind to them with bindService) to interact through a client-server interface. A bound service must return an IBinder from onBind). See Bound services.
- Foreground services:: show an ongoing notification and are subject to foreground service type requirements introduced in recent Android versions.
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
- 変更レビューで MASTG-KNOW-0133 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0133/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
