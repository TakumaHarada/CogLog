---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0005/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - code
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0005
masvs_category: MASVS-CODE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0005: Memory Corruption Bugs

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Memory Corruption Bugs」（Android / コード品質）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Android applications typically run within a managed environment where many traditional memory corruption risks are mitigated by design. The Android Runtime (ART) and Java Virtual Machine handle memory management and enforce type safety, which largely prevents issues such as buffer overflows, out-of-bounds writes, and use-after-free conditions. Applications written in memory-safe languages such as Java or Kotlin ar...
* 要旨: However, these protections do not extend to all components. Memory corruption bugs can still occur in native layers that use the Java Native Interface (JNI) or the Android Native Development Kit (NDK). SDKs and libraries written in C or C++ operate outside the managed memory model and remain susceptible to traditional memory safety issues. For example, CVE-2018-9522 involved a serialization vulnerability in Androi...

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0005/>
* 関連制御群: `MASVS-CODE`（コード品質）

## Memory Corruption Bugsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Memory Corruption Bugsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-CODE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Memory Corruption Bugsの実装・監査観点の実装例

```text
公式記事の API・設定説明を読み、次を確認する。
* 依存関係の既知脆弱性をリリース前にトリアージする
* debuggable / デバッグ記号を本番から除去する
* 例外情報に秘密を載せない
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
- 変更レビューで MASTG-KNOW-0005 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0005/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-CODE`: <https://mas.owasp.org/MASVS/>
