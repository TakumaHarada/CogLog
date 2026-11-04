---
source: https://mas.owasp.org/MASTG/0x06i-Testing-Code-Quality-and-Build-Settings/
scopes:
  - test
  - ios
  - mobile
  - code-quality
  - build-settings
  - security-review
  - implementation
  - mastg-ios-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-CODE
---

# MASTG 0x06i: iOS Code Quality and Build Settings

## 概要

本ドキュメントは MASTG「iOS Code Quality and Build Settings」を蒸留したものである。署名、デバッグ設定、依存関係、非本番リソース、例外処理などビルド品質を扱う。章本文は概要中心のため、詳細は CODE Knowledge / Tests を正とする。

* 正本: <https://mas.owasp.org/MASTG/0x06i-Testing-Code-Quality-and-Build-Settings/>
* Knowledge: `docs/security/mas.owasp.org/knowledge/ios/MASVS-CODE/`
* Tests: `docs/security/mas.owasp.org/tests/ios/MASVS-CODE/`

## 本番成果物からデバッグと非本番資源を除去する

デバッグ有効化、冗長ログ、開発用エンドポイント、テスト用証明書設定を release から排除する。

### 本番成果物からデバッグと非本番資源を除去するの補足

* 利点: 動的解析と設定漏れの入口を減らせる
* 注意点: Debug / Release の xcconfig・entitlements・ATS 例外を別管理する
* 適用範囲: CI、TestFlight、App Store 提出
* 例外: 社内専用配布（経路を分離）

### 本番成果物からデバッグと非本番資源を除去するの実装例

```text
確認（Knowledge）
* MASTG-KNOW-0062 Debuggable Apps
* MASTG-KNOW-0063 Debug Symbols
* MASTG-KNOW-0064 Non-Production Resources
* MASTG-KNOW-0065 Exception Handling
* MASTG-KNOW-0059 Third-Party Libraries
```

## コード署名と供給網を検証する

不正署名・改変依存・脆弱ライブラリは実行時欠陥以前の問題である。

### コード署名と供給網を検証するの補足

* 利点: 配布信頼と更新ハイジャック耐性を維持できる
* 注意点: 署名鍵の共有禁止（0x06a とも共通）
* 適用範囲: ビルドパイプライン
* 例外: なし

### コード署名と供給網を検証するの実装例

```text
ゲート例
* 署名検証
* 依存脆弱性スキャン
* Privacy Manifest / 権限差分レビュー
```

## ナレッジベース

### DO: release に対し「デバッグ設定 / 依存 CVE / 署名」を自動チェックする

```text
# 推奨
gates: [no debug leftovers, deps, codesign]
```

### DO NOT: Debug 用 ATS 緩和や Debug App Attest を本番設定へ残す

* 理由: CODE と NETWORK / RESILIENCE の欠陥が同時に残る
* 理由: 開発例外の染み出しが典型事故である

```text
# DO NOT: NSAllowsArbitraryLoads を共通 plist へ入れる

# DO: Debug xcconfig に閉じる
```

## 参考リンク

* iOS Code Quality and Build Settings: <https://mas.owasp.org/MASTG/0x06i-Testing-Code-Quality-and-Build-Settings/>
