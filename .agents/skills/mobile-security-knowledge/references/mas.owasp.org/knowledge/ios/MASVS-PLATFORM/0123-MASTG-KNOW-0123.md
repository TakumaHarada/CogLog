---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0123/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0123
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0123: Handoff

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Handoff」（iOS / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Handoff is an Apple continuity feature that lets users start an activity on one device and continue it on another nearby Apple device. It relies on NSUserActivity to capture enough state to resume the activity later.
* 要旨: An app creates an NSUserActivity object describing the current activity and makes it current. Handoff advertises eligible user activities to nearby devices signed into the same iCloud account. When the user accepts the handoff on another device, the system launches or resumes the app on that device and delivers the NSUserActivity to it.

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0123/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Handoffの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Handoffの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Handoffの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Handoff works between nearby Apple devices signed into the same iCloud account.
* The activityType must be declared in the app's Info.plist under NSUserActivityTypes.
* Data transferred via userInfo should be minimal. Apple recommends transferring as small a payload as possible, preferably 3 KB or less. For larger state, store the data elsewhere and include only e...
* If the activity contains file URLs, the receiving app may need to call startAccessingSecurityScopedResource() before accessing them.
* Apps can mark an activity as eligible for search (isEligibleForSearch) and prediction (isEligibleForPrediction), which exposes the activity to Spotlight and Siri Suggestions respectively.
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- Handoff works between nearby Apple devices signed into the same iCloud account.
- The activityType must be declared in the app's Info.plist under NSUserActivityTypes.
- Data transferred via userInfo should be minimal. Apple recommends transferring as small a payload as possible, preferably 3 KB or less. For larger state, store the data elsewhere and include only enough information to retrieve or reconstruct it.
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
- 変更レビューで MASTG-KNOW-0123 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0123/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
