---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0008/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - code
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0008
masvs_category: MASVS-CODE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0008: Debugging Information and Debug Symbols

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Debugging Information and Debug Symbols」（Android / コード品質）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: On Android, native libraries are usually developed in C or C++ with the NDK and compiled into ELF shared objects with a .so extension, which reside in the lib/ directory of the APK. These libraries often expose functionality to be used from Dalvik through the Java Native Interface (JNI). Debug symbols in these binaries provide details like function names, variable names, and source file mappings, which are useful ...
* 要旨: When compiling and linking programs, symbols represent functions or variables. In ELF (Executable and Linkable Format) files, symbols have different roles:

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0008/>
* 関連制御群: `MASVS-CODE`（コード品質）

## Debugging Information and Debug Symbolsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Debugging Information and Debug Symbolsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-CODE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Debugging Information and Debug Symbolsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Local symbols: Only visible inside the file where they're defined. Used internally. Not accessible from other files.
* Global symbols: Visible to other files. Used to share functions or variables across different object files.
* Weak symbols: Like global symbols, but lower priority. A strong (non-weak) symbol overrides a weak one if both exist.
* .symtab: The full symbol table used at link time, often removed in production binaries (DT_SYMTAB dtag).
* .dynsym: The dynamic symbol table, used for runtime linking. It is always present in shared objects.
* 公式記事内のコード例言語: sh
```

## ナレッジベース

### DO: 依存関係の既知脆弱性をリリース前にトリアージする

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 依存関係の既知脆弱性をリリース前にトリアージする
- debuggable / デバッグ記号を本番から除去する
- 例外情報に秘密を載せない
- Local symbols: Only visible inside the file where they're defined. Used internally. Not accessible from other files.
- Global symbols: Visible to other files. Used to share functions or variables across different object files.
- Weak symbols: Like global symbols, but lower priority. A strong (non-weak) symbol overrides a weak one if both exist.
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
- 変更レビューで MASTG-KNOW-0008 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0008/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-CODE`: <https://mas.owasp.org/MASVS/>
