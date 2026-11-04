---
source: https://mas.owasp.org/MASTG/0x05i-Testing-Code-Quality-and-Build-Settings/
scopes:
  - test
  - android
  - mobile
  - code-quality
  - build-settings
  - security-review
  - implementation
  - mastg-android-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-CODE
---

# MASTG 0x05i: Android Code Quality and Build Settings

## 概要

本ドキュメントは MASTG「Android Code Quality and Build Settings」を蒸留したものである。debuggable、署名、依存関係、メモリ安全、コンパイラ防護など、ビルドとコード品質の欠陥を扱う。章本文は概要中心のため、詳細は CODE の Knowledge / Tests を正とする。

* 正本: <https://mas.owasp.org/MASTG/0x05i-Testing-Code-Quality-and-Build-Settings/>
* Knowledge: `docs/security/mas.owasp.org/knowledge/android/MASVS-CODE/`
* Tests: `docs/security/mas.owasp.org/tests/android/MASVS-CODE/`

## 本番ビルドからデバッグ能力を除去する

`android:debuggable`、冗長ログ、デバッグ記号、開発用エンドポイントを release から排除する。

### 本番ビルドからデバッグ能力を除去するの補足

* 利点: 動的解析と情報漏洩の入口を減らせる
* 注意点: Flutter / Gradle の build type とマニフェストマージの合成結果を確認する
* 適用範囲: CI リリースゲート、ストア提出物
* 例外: 明示的な社内デバッグ配布（署名・配布経路を分離）

### 本番ビルドからデバッグ能力を除去するの実装例

```text
確認
* release で debuggable=false
* デバッグ用 cleartext / Debug App Check が混入していない
* 依存関係の既知 CVE をトリアージ（MASTG-KNOW-0004）
* 例外メッセージに秘密を載せない（MASTG-KNOW-0010）
```

## 署名と第三者ライブラリを供給網リスクとして扱う

不正署名・改変 SDK・脆弱ライブラリは CODE / サプライチェーン双方の問題である。

### 署名と第三者ライブラリを供給網リスクとして扱うの補足

* 利点: 実行時欠陥以外の侵入経路を塞げる
* 注意点: ロックファイルと SBOM 無しでは再現できない
* 適用範囲: 依存更新、CI、署名検証
* 例外: なし

### 署名と第三者ライブラリを供給網リスクとして扱うの実装例

```text
ゲート例
* apksigner verify
* dependency vulnerability scan
* 新規 SDK の権限・通信先レビュー
```

## ナレッジベース

### DO: release 成果物に対し「debuggable / 依存 CVE / 署名」を自動チェックする

```text
# 推奨
gates: [debuggable=false, deps, apksigner]
```

### DO NOT: debug 用緩和を product flavor 全体へ適用したまま出荷する

* 理由: CODE と NETWORK/STORAGE の欠陥が同時に残る
* 理由: テスト環境の都合が本番設定へ染み出しやすい

```text
# DO NOT: debug cleartext を main マニフェストへ入れる

# DO: src/debug に隔離する
```

## 参考リンク

* Android Code Quality and Build Settings: <https://mas.owasp.org/MASTG/0x05i-Testing-Code-Quality-and-Build-Settings/>
