---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0117/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - code
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0117
masvs_category: MASVS-CODE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0117: Android ContentProvider

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Android ContentProvider」（Android / コード品質）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: A ContentProvider is an Android component that exposes structured data to other apps and system services through a standardized URI-based interface. Providers support CRUD operations (query, insert, update, delete) and are typically backed by an SQLite database, though any data source may be used. Clients interact with a provider through ContentResolver or, on a device shell, via the content command.
* 要旨: Content URIs follow the scheme content:/// or content:////:

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0117/>
* 関連制御群: `MASVS-CODE`（コード品質）

## Android ContentProviderの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Android ContentProviderの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-CODE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Android ContentProviderの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Authority: a unique string identifying the provider, for example com.example.app.provider, declared in the element of the manifest.
* Path: identifies the resource type or table, for example students.
* ID segment: an optional integer row identifier appended to the path, for example students/3.
* Uri.getPathSegments() returns a decoded list of path segments after the authority. Index 0 is typically the resource path and index 1, when present, is an ID.
* Uri.getLastPathSegment() returns the final path segment.
* 公式記事内のコード例言語: kotlin
```

## ナレッジベース

### DO: 依存関係の既知脆弱性をリリース前にトリアージする

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 依存関係の既知脆弱性をリリース前にトリアージする
- debuggable / デバッグ記号を本番から除去する
- 例外情報に秘密を載せない
- Authority: a unique string identifying the provider, for example com.example.app.provider, declared in the element of the manifest.
- Path: identifies the resource type or table, for example students.
- ID segment: an optional integer row identifier appended to the path, for example students/3.
```

### DO NOT: 本番で StrictMode 違反やデバッグ設定を残す

* 理由: MASVS-CODE の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- 本番で StrictMode 違反やデバッグ設定を残す
- 未検証の動的コードロードを行う

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0117 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0117/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-CODE`: <https://mas.owasp.org/MASVS/>
