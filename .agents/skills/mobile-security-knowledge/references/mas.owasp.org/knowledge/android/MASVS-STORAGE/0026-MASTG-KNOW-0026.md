---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0026/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - storage
  - backend
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0026
masvs_category: MASVS-STORAGE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0026: Third-party Services Embedded in the App

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Third-party Services Embedded in the App」（Android / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: The features provided by third-party services can involve tracking services to monitor the user's behavior while using the app, selling banner advertisements, or improving the user experience.
* 要旨: The downside is that developers don't usually know the details of the code executed via third-party libraries. Consequently, no more information than is necessary should be sent to a service, and no sensitive information should be disclosed.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0026/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## Third-party Services Embedded in the Appの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Third-party Services Embedded in the Appの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Third-party Services Embedded in the Appの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* with a standalone library
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない
- with a standalone library
```

### DO NOT: SharedPreferences / UserDefaults にパスワードを平文保存する

* 理由: MASVS-STORAGE の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- SharedPreferences / UserDefaults にパスワードを平文保存する
- バックアップ対象にトークンを残す

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0026 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0026/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
