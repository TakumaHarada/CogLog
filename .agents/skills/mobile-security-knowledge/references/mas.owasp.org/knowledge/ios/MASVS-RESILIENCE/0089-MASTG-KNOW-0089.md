---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-RESILIENCE/MASTG-KNOW-0089/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - resilience
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0089
masvs_category: MASVS-RESILIENCE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0089: Obfuscation

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Obfuscation」（iOS / 耐タンパ・耐解析）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: introduces common obfuscation techniques that apply across platforms. On iOS, these techniques can affect native Mach-O code, Objective-C and Swift runtime metadata, bundled resources, and data used by the app.
* 要旨: iOS applications are distributed as signed app bundles containing a main Mach-O executable and, often, embedded frameworks, app extensions, and resource files.

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-RESILIENCE/MASTG-KNOW-0089/>
* 関連制御群: `MASVS-RESILIENCE`（耐タンパ・耐解析）

## Obfuscationの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Obfuscationの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-RESILIENCE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Obfuscationの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* O-MVLL is an LLVM-based obfuscator for native code. Its documentation describes passes such as string encoding, control-flow flattening, opaque constants, indirect calls and branches, Objective-C m...
* "Protecting Million-User iOS Apps with Obfuscation: Motivations, Pitfalls, and Experience" describes practical iOS obfuscation at scale and discusses motivations, pitfalls, and lessons learned from...
* Exported symbols and local symbol table entries.
* Objective-C class names, categories, protocols, properties, and selectors.
* Swift type descriptors, protocol metadata, and mangled Swift symbols.
* 公式記事内のコード例言語: assembly, python, swift
```

## ナレッジベース

### DO: 耐タンパは追加層としサーバ認可の代替にしない

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 耐タンパは追加層としサーバ認可の代替にしない
- 脅威モデルで要否と深度を文書化する
- 検知結果はサーバ側判断と組み合わせる
- O-MVLL is an LLVM-based obfuscator for native code. Its documentation describes passes such as string encoding, control-flow flattening, opaque constants, indirect calls and branches, Objective-C metadata cleaning, and anti-hooking.
- "Protecting Million-User iOS Apps with Obfuscation: Motivations, Pitfalls, and Experience" describes practical iOS obfuscation at scale and discusses motivations, pitfalls, and lessons learned from deploying obfuscation in production apps.
- Exported symbols and local symbol table entries.
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
- 変更レビューで MASTG-KNOW-0089 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-RESILIENCE/MASTG-KNOW-0089/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-RESILIENCE`: <https://mas.owasp.org/MASVS/>
