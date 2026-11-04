---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-RESILIENCE/MASTG-KNOW-0032/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - resilience
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0032
masvs_category: MASVS-RESILIENCE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0032: Runtime Integrity Verification

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Runtime Integrity Verification」（Android / 耐タンパ・耐解析）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: defensive controls in this category verify the integrity of the app's memory to defend against runtime memory patches. Such changes include unwanted modifications to native code, bytecode execution targets, function pointer tables, important runtime data structures, and unauthorized executable code loaded into process memory.
* 要旨: Unlike , which covers artifact-based detection (e.g., scanning for tool-specific strings or checking for open ports), this document focuses on detecting the _modifications_ that instrumentation tools make to the app's code and memory.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-RESILIENCE/MASTG-KNOW-0032/>
* 関連制御群: `MASVS-RESILIENCE`（耐タンパ・耐解析）

## Runtime Integrity Verificationの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Runtime Integrity Verificationの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-RESILIENCE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Runtime Integrity Verificationの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* entry_point_from_quick_compiled_code_: Pointer to the compiled native code
* entry_point_from_interpreter_: Pointer to interpreter entry
* access_flags_: Method modifiers (public, native, etc.)
* Entry point verification: Inspect the relevant ArtMethod entrypoint fields for the target Android version and verify that they fall within legitimate regions (OAT file, interpreter bridge, JNI/nati...
* Access flags inspection: Check if kAccNative (0x0100) was unexpectedly set
* 公式記事内のコード例言語: cpp
```

## ナレッジベース

### DO: 耐タンパは追加層としサーバ認可の代替にしない

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 耐タンパは追加層としサーバ認可の代替にしない
- 脅威モデルで要否と深度を文書化する
- 検知結果はサーバ側判断と組み合わせる
- entry_point_from_quick_compiled_code_: Pointer to the compiled native code
- entry_point_from_interpreter_: Pointer to interpreter entry
- access_flags_: Method modifiers (public, native, etc.)
```

### DO NOT: 難読化だけで平文保存や cleartext を許容する

* 理由: MASVS-RESILIENCE の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- 難読化だけで平文保存や cleartext を許容する
- クライアント検知成功 alone で権限を付与する

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0032 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-RESILIENCE/MASTG-KNOW-0032/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-RESILIENCE`: <https://mas.owasp.org/MASVS/>
