---
source: https://mas.owasp.org/MASTG/0x06h-Testing-Platform-Interaction/
scopes:
  - test
  - ios
  - mobile
  - platform
  - security-review
  - implementation
  - mastg-ios-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-PLATFORM
---

# MASTG 0x06h: iOS Platform APIs

## 概要

本ドキュメントは MASTG「iOS Platform APIs」を蒸留したものである。権限、WebView、URL scheme / Universal Links、共有、拡張、Pasteboard、App Intents など OS 連携面を扱う。章本文は概要中心のため、詳細は PLATFORM Knowledge / Tests を正とする。

* 正本: <https://mas.owasp.org/MASTG/0x06h-Testing-Platform-Interaction/>
* Knowledge: `docs/security/mas.owasp.org/knowledge/ios/MASVS-PLATFORM/`
* Tests: `docs/security/mas.owasp.org/tests/ios/MASVS-PLATFORM/`

## 入口を最小化し、入力を検証する

Custom URL Schemes / Universal Links / Share / Extensions / WebView を攻撃面一覧にし、不要なら無効化する。

### 入口を最小化し、入力を検証するの補足

* 利点: Android より IPC は少ないが、URL・共有・拡張は依然リスク源である
* 注意点: Usage Description と実 API 利用の一致も PLATFORM/PRIVACY 境界
* 適用範囲: Info.plist、拡張ターゲット、WKWebView
* 例外: 明示的な連携要件（検証付き）

### 入口を最小化し、入力を検証するの実装例

```text
優先 Knowledge
* MASTG-KNOW-0076 WebViews
* MASTG-KNOW-0077 App Permissions
* MASTG-KNOW-0079 Custom URL Schemes
* MASTG-KNOW-0080 Universal Links
* MASTG-KNOW-0081 UIActivity Sharing
* MASTG-KNOW-0082 App Extensions
* MASTG-KNOW-0083 Pasteboard
* MASTG-KNOW-0129 App Intents and AI Agent Exposure
```

```xml
<!-- Deep Link 自動処理を無効化する例 -->
<key>FlutterDeepLinkingEnabled</key>
<false/>
```

## ナレッジベース

### DO: PLATFORM 変更で「入口一覧 → 権限説明 → 入力検証」をレビューする

```text
# 推奨
entries: [url schemes, universal links, share, extensions, webview]
permissions: purpose strings match behavior
```

### DO NOT: 便利さのために広い URL scheme や無制限 WebView を既定にする

* 理由: 章の対象がプラットフォーム境界そのものである
* 理由: 一度公開した入口は削除コストが高い

```text
# DO NOT: 未検証のカスタム URL で機微画面を開く

# DO: 署名付き Universal Links + サーバ検証
```

## 参考リンク

* iOS Platform APIs: <https://mas.owasp.org/MASTG/0x06h-Testing-Platform-Interaction/>
* Platform Overview: <https://mas.owasp.org/MASTG/0x06a-Platform-Overview/>
