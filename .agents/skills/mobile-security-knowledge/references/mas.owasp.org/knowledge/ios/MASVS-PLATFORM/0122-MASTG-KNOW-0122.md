---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0122/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0122
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0122: Document Picker, Document Interaction, and Open in Place

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Document Picker, Document Interaction, and Open in Place」（iOS / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: iOS provides several mechanisms for exchanging files between apps. These mechanisms are user-mediated: the user chooses which files to share, open, import, or export, and which apps or locations are involved.
* 要旨: Storage apps can expose documents to system document UIs, such as the document picker, document browser, and Files app, through File Provider extensions. This is especially relevant for document picker and open in place flows, where the selected file may live outside the receiving app's sandbox.

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0122/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Document Picker, Document Interaction, and Open in Placeの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Document Picker, Document Interaction, and Open in Placeの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Document Picker, Document Interaction, and Open in Placeの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Open and move operations provide security-scoped URLs for external documents. Apps should call startAccessingSecurityScopedResource() before accessing them, unless access is managed by UIDocument.
* Import and export operations copy files into or out of the app's sandbox.
* Access to files outside the app's sandbox is mediated by the system. Access to external documents should be coordinated using , especially if the file may be modified by multiple apps or processes.
* The system filters available actions and apps based on the file type, using declared document types and Uniform Type Identifiers.
* When a file is opened by another app as a copy, the receiving app receives its own copy, commonly in its Documents/Inbox directory.
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- Open and move operations provide security-scoped URLs for external documents. Apps should call startAccessingSecurityScopedResource() before accessing them, unless access is managed by UIDocument.
- Import and export operations copy files into or out of the app's sandbox.
- Access to files outside the app's sandbox is mediated by the system. Access to external documents should be coordinated using , especially if the file may be modified by multiple apps or processes.
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
- 変更レビューで MASTG-KNOW-0122 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0122/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
