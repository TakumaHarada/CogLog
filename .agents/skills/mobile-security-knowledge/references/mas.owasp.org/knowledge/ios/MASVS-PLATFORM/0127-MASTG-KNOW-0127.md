---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0127/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0127
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0127: File Coordination APIs

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「File Coordination APIs」（iOS / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: The File Coordination APIs provide a mechanism for coordinating safe, concurrent access to files and directories. They are particularly important when multiple processes or objects, such as an app and its extensions, read or write shared files in an App Group container (see ).
* 要旨: File coordination is implemented through two main classes:

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0127/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## File Coordination APIsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### File Coordination APIsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### File Coordination APIsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* NSFileCoordinator: Coordinates reads and writes to a file or directory among participating file presenters. Callers use it to declare their intent before accessing a file, allowing the system to se...
* NSFilePresenter: A protocol adopted by objects that want to be notified when a file or directory they are interested in changes. Presenters are registered with the file coordination system and rece...
* File coordination is only meaningful between cooperating processes or objects that use the file coordination system. Uncoordinated file access bypasses the coordination mechanism.
* Coordination is commonly used for external documents, document-based apps, and App Group shared containers where the main app and its extensions may access the same files.
* When using UIDocument or NSDocument, file coordination is managed automatically by the document class.
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
- NSFileCoordinator: Coordinates reads and writes to a file or directory among participating file presenters. Callers use it to declare their intent before accessing a file, allowing the system to serialize conflicting coordinated access.
- NSFilePresenter: A protocol adopted by objects that want to be notified when a file or directory they are interested in changes. Presenters are registered with the file coordination system and receive callbacks for changes made through coordinated access.
- File coordination is only meaningful between cooperating processes or objects that use the file coordination system. Uncoordinated file access bypasses the coordination mechanism.
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
- 変更レビューで MASTG-KNOW-0127 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0127/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
