---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0009/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - code
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0009
masvs_category: MASVS-CODE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0009: StrictMode

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「StrictMode」（Android / コード品質）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: StrictMode is a developer tool for detecting violations, e.g. accidental disk or network access to the app's main thread. It can also be used to check for good coding practices, such as implementing performant code.
* 要旨: Different policies can be set using the ThreadPolicy Builder and the VmPolicy Builder.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0009/>
* 関連制御群: `MASVS-CODE`（コード品質）

## StrictModeの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### StrictModeの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-CODE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### StrictModeの実装・監査観点の実装例

```text
公式記事の API・設定説明を読み、次を確認する。
* 依存関係の既知脆弱性をリリース前にトリアージする
* debuggable / デバッグ記号を本番から除去する
* 例外情報に秘密を載せない
* 公式記事内のコード例言語: java
```

## ナレッジベース

### DO: 依存関係の既知脆弱性をリリース前にトリアージする

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 依存関係の既知脆弱性をリリース前にトリアージする
- debuggable / デバッグ記号を本番から除去する
- 例外情報に秘密を載せない

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
- 変更レビューで MASTG-KNOW-0009 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0009/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-CODE`: <https://mas.owasp.org/MASVS/>
