---
source: https://mas.owasp.org/MASTG/0x05h-Testing-Platform-Interaction/
scopes:
  - test
  - android
  - mobile
  - platform
  - security-review
  - implementation
  - mastg-android-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-PLATFORM
---

# MASTG 0x05h: Android Platform APIs

## 概要

本ドキュメントは MASTG「Android Platform APIs」を蒸留したものである。権限、WebView、Deep Link、IPC（Intent / PendingIntent）、オーバーレイ等、OS 連携面の攻撃を扱う。章本文は概要中心のため、具体手順は PLATFORM の Knowledge / Tests を正とする。

* 正本: <https://mas.owasp.org/MASTG/0x05h-Testing-Platform-Interaction/>
* Knowledge: `docs/security/mas.owasp.org/knowledge/android/MASVS-PLATFORM/`
* Tests: `docs/security/mas.owasp.org/tests/android/MASVS-PLATFORM/`

## プラットフォーム入口を最小権限・明示 Intent で閉じる

他アプリやユーザ入力から届く入口（exported、URL、WebView）を攻撃面一覧にし、不要なら無効化する。

### プラットフォーム入口を最小権限・明示 Intent で閉じるの補足

* 利点: Intent 注入、ディープリンク不正、WebView ブリッジ悪用を減らせる
* 注意点: ライブラリが追加するコンポーネントも最終マニフェストで確認する
* 適用範囲: Activity/Service/Receiver/Provider、WebView、App Links
* 例外: 明示的な外部連携要件（検証付き）

### プラットフォーム入口を最小権限・明示 Intent で閉じるの実装例

```text
優先確認（Knowledge 連携）
* MASTG-KNOW-0017 App Permissions
* MASTG-KNOW-0018 WebViews
* MASTG-KNOW-0019 Deep Links
* MASTG-KNOW-0020 / 0024 / 0025 IPC・PendingIntent・明示/暗黙 Intent
* MASTG-KNOW-0132〜0134 Activities / Services / Receivers
```

```xml
<!-- Deep Link 無効化の例 -->
<meta-data
  android:name="flutter_deeplinking_enabled"
  android:value="false" />
```

## ナレッジベース

### DO: PLATFORM 変更で「入口一覧 → 権限 → 入力検証」の順にレビューする

```text
# 推奨
entries: [exported components, deeplinks, webview]
permissions: minimized
validation: client + server
```

### DO NOT: 便利さのために暗黙 Intent や広い WebView 設定を既定にする

* 理由: 章の対象領域そのものが IPC / Web コンテンツ境界である
* 理由: 一度広げた入口は削除コストが高い

```text
# DO NOT: android:exported=true を理由なく残す

# DO: 必要最小の明示 Intent / 検証付きディープリンク
```

## 参考リンク

* Android Platform APIs: <https://mas.owasp.org/MASTG/0x05h-Testing-Platform-Interaction/>
* Platform Overview: <https://mas.owasp.org/MASTG/0x05a-Platform-Overview/>
