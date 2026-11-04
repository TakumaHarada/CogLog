---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0130/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0130
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0130: Core Bluetooth

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Core Bluetooth」（iOS / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Core Bluetooth is the iOS framework for Bluetooth Low Energy (BLE) communication. Apps use it to discover, connect to, and exchange data with BLE peripherals, such as fitness trackers, medical sensors, smart home hardware, and companion devices.
* 要旨: Apps interact with BLE primarily through two manager classes:

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0130/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Core Bluetoothの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Core Bluetoothの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Core Bluetoothの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* CBCentralManager: Scans for, discovers, and connects to BLE peripherals. After connecting, the app reads, writes, and subscribes to GATT characteristics to exchange data.
* CBPeripheralManager: Lets the local device act as a BLE peripheral by advertising, publishing GATT services and characteristics, and responding to read, write, and subscription requests from connec...
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- CBCentralManager: Scans for, discovers, and connects to BLE peripherals. After connecting, the app reads, writes, and subscribes to GATT characteristics to exchange data.
- CBPeripheralManager: Lets the local device act as a BLE peripheral by advertising, publishing GATT services and characteristics, and responding to read, write, and subscription requests from connected centrals.
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
- 変更レビューで MASTG-KNOW-0130 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0130/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
