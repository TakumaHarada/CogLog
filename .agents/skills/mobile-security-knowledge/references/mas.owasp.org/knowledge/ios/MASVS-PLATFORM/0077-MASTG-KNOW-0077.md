---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0077/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0077
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0077: App Permissions

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「App Permissions」（iOS / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: iOS permissions work differently from Android. On Android, permissions are declared in a manifest and granted at install time or via runtime prompts. On iOS, access control is a layered model that is worth understanding before diving into individual checks.
* 要旨: All third-party iOS apps run under the non-privileged mobile user and are sandboxed via policies enforced by the Trusted BSD (MAC) Mandatory Access Control Framework Framework"). This baseline sandboxing is not the same as "permissions": it applies to every app automatically, without any developer configuration or user interaction. Access to resources beyond the sandbox is controlled through three distinct mechani...

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0077/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## App Permissionsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### App Permissionsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### App Permissionsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* The typical QR Code scanning app obviously requires the camera to function but might be requesting the photos permission as well. If storage is explicitly required, and depending on the sensitivity...
* Some apps require photo uploads (e.g. for profile pictures). Use PHPickerViewController (iOS 14+) or PhotosPicker (iOS 16+, SwiftUI). These APIs run in a separate process and give the app read-only...
* Usage description strings: (purpose strings) in Info.plist, which explain protected-resource access to the user and are required before the system will show an authorization prompt.
* Entitlements: , signed key-value pairs that enable access to specific platform services or cross-app data sharing.
* Authorization requests: at runtime, where the system prompts the user to grant or deny access to a specific resource.
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
- The typical QR Code scanning app obviously requires the camera to function but might be requesting the photos permission as well. If storage is explicitly required, and depending on the sensitivity of the pictures being taken, these apps might better opt to use the app sandbox storage to avoid other apps (having the photos permission) to access them.
- Some apps require photo uploads (e.g. for profile pictures). Use PHPickerViewController (iOS 14+) or PhotosPicker (iOS 16+, SwiftUI). These APIs run in a separate process and give the app read-only access exclusively to the images selected by the user, rather than the entire photo library. This is the preferred approach to avoid requesting unnecessary permissions.
- Usage description strings: (purpose strings) in Info.plist, which explain protected-resource access to the user and are required before the system will show an authorization prompt.
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
- 変更レビューで MASTG-KNOW-0077 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0077/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
