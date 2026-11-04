---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0078/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0078
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0078: Inter-Process Communication (IPC)

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Inter-Process Communication (IPC)」（iOS / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: iOS does not provide a general-purpose mechanism for third-party apps to communicate directly. Instead, apps exchange data through platform-mediated interfaces of varying levels of abstraction.
* 要旨: Each IPC mechanism can be characterized by who can send data, who can receive data, whether user interaction is required, how long the data remains available, and whether the channel is restricted by an entitlement or app group.

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0078/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Inter-Process Communication (IPC)の実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Inter-Process Communication (IPC)の実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Inter-Process Communication (IPC)の実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* : clipboard-style data exchange between apps.
* and : for launching an app and passing small amounts of routing data. Universal Links are generally safer for web-to-app routing because they are bound to an associated domain, while custom URL sch...
* : share sheets for explicit user-initiated sharing of text, files, URLs, and other content.
* : document picker, document interaction, and open in place, for exchanging files selected by the user.
* , , and : Handoff, App Intents, and Siri Shortcuts, for system-mediated continuation, automation, or intent-based data exchange.
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- : clipboard-style data exchange between apps.
- and : for launching an app and passing small amounts of routing data. Universal Links are generally safer for web-to-app routing because they are bound to an associated domain, while custom URL schemes can conflict between apps.
- : share sheets for explicit user-initiated sharing of text, files, URLs, and other content.
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
- 変更レビューで MASTG-KNOW-0078 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0078/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
