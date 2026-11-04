---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0134/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0134
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0134: Android Broadcast Receivers

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Android Broadcast Receivers」（Android / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: A broadcast receiver is an app component that responds to broadcast messages from other apps or from the system. Apps use broadcasts as a publish-subscribe messaging mechanism: the system delivers broadcasts for events such as boot completion or connectivity changes, and apps can send their own broadcasts to communicate between components or with other apps. A broadcast receiver extends the BroadcastReceiver class...
* 要旨: Broadcasts are built on top of the Intent system and are an inter-process communication (IPC), entry point, subject to access controls such as android:exported, android:permission, runtime receiver export flags, and broadcast permissions. This makes receiver visibility directly relevant to the app's attack surface. See for the IPC model and for implicit intents.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0134/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Android Broadcast Receiversの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Android Broadcast Receiversの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Android Broadcast Receiversの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* registerReceiver(BroadcastReceiver receiver, IntentFilter filter))
* registerReceiver(BroadcastReceiver receiver, IntentFilter filter, int flags))
* registerReceiver(BroadcastReceiver receiver, IntentFilter filter, String broadcastPermission, Handler scheduler))
* registerReceiver(BroadcastReceiver receiver, IntentFilter filter, String broadcastPermission, Handler scheduler, int flags))
* ContextCompat.registerReceiver(Context context, BroadcastReceiver receiver, IntentFilter filter, int flags))
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
- registerReceiver(BroadcastReceiver receiver, IntentFilter filter))
- registerReceiver(BroadcastReceiver receiver, IntentFilter filter, int flags))
- registerReceiver(BroadcastReceiver receiver, IntentFilter filter, String broadcastPermission, Handler scheduler))
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
- 変更レビューで MASTG-KNOW-0134 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0134/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
