---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0081/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0081
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0081: UIActivity Sharing

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「UIActivity Sharing」（iOS / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Starting with iOS 6, apps can share data (items) via the system-wide "Share Sheet" using "Activity Views", which are implemented in the UIActivityViewController API.
* 要旨: From a user perspective, this is the familiar "Share" button available throughout iOS. The following figure shows such a "Share Sheet" when sharing a link in the Safari browser:

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0081/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## UIActivity Sharingの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### UIActivity Sharingの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### UIActivity Sharingの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* activityItems: An array of data objects to share. Items can be of any type that conforms to UIActivityItemSource or is directly shareable (for example, String, URL, UIImage).
* applicationActivities: An optional array of custom UIActivity subclass instances representing app-specific services.
* It only affects the built-in system activity types listed in UIActivity.ActivityType. As confirmed by an Apple Frameworks Engineer, apps "are not allowed to exclude extension activities that come f...
* The built-in set can grow between iOS releases, and newly introduced types are not excluded automatically, so an exclusion list is never exhaustive.
* UTExportedTypeDeclarations / UTImportedTypeDeclarations: declare custom Uniform Type Identifiers (UTIs) that the app exports or imports.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- activityItems: An array of data objects to share. Items can be of any type that conforms to UIActivityItemSource or is directly shareable (for example, String, URL, UIImage).
- applicationActivities: An optional array of custom UIActivity subclass instances representing app-specific services.
- It only affects the built-in system activity types listed in UIActivity.ActivityType. As confirmed by an Apple Frameworks Engineer, apps "are not allowed to exclude extension activities that come from other apps" — so third-party share extensions (for example, third-party messengers or cloud-storage apps), which are the dominant sharing channels on modern iOS, cannot be excluded.
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
- 変更レビューで MASTG-KNOW-0081 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0081/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
