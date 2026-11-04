---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0024/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0024
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0024: Pending Intents

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Pending Intents」（Android / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Often while dealing with complex flows during app development, there are situations where an app A wants another app B to perform a certain action in the future, on app A's behalf. Trying to implement this by only using Intents leads to various security problems, like having multiple exported components. To handle this use case in a secure manner, Android provides the PendingIntent API.
* 要旨: PendingIntent are most commonly used for notifications, app widgets, media browser services, etc. When used for notifications, PendingIntent is used to declare an intent to be executed when a user performs an action with an application's notification. The notification requires a callback to the application to trigger an action when the user clicks on it.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0024/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Pending Intentsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Pending Intentsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Pending Intentsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Mutable fields: A PendingIntent can have mutable and empty fields that can be filled by a malicious application. This can lead to a malicious application gaining access to non-exported application ...
* Use of implicit intent: A malicious application can receive a PendingIntent and then update the base intent to target the component and package within the malicious application. As a mitigation, en...
* 公式記事内のコード例言語: java
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- Mutable fields: A PendingIntent can have mutable and empty fields that can be filled by a malicious application. This can lead to a malicious application gaining access to non-exported application components. Using the PendingIntent.FLAG_IMMUTABLE flag makes the PendingIntent immutable and prevents any changes to the fields. Prior to Android 12 (API level 31), the PendingIntent was mutable by default, while since Android 12 (API level 31), the mutability of each PendingIntent object must be specified using either FLAG_MUTABLE or the FLAG_IMMUTABLE flag. If the mutability isn't specified, the system throws an IllegalArgumentException and the app will crash.
- Use of implicit intent: A malicious application can receive a PendingIntent and then update the base intent to target the component and package within the malicious application. As a mitigation, ensure that you explicitly specify the exact package, action and component that will receive the base intent.
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
- 変更レビューで MASTG-KNOW-0024 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0024/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
