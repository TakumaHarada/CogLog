---
source: https://mas.owasp.org/MASTG/0x06b-iOS-Security-Testing/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - test-environment
  - mastg-ios-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
---

# MASTG 0x06b: iOS Security Testing（環境構築）

## 概要

本ドキュメントは MASTG「iOS Security Testing」を蒸留したものである。macOS ホスト、実機（jailbreak）、Simulator、特権取得の前提と注意を定義し、MASTG Test 実施の土台にする。

* 正本: <https://mas.owasp.org/MASTG/0x06b-iOS-Security-Testing/>
* 関連 Tests: `docs/security/mas.owasp.org/tests/0000-index.md`

## ホストは macOS を基本にする

Xcode / iOS SDK は macOS のみ。ソース解析とデバッグ、多くの黒箱作業が macOS 前提である。

### ホストは macOS を基本にするの補足

* 利点: 公式ツールチェーンと実機連携が安定する
* 注意点: Linux/Windows だけでは実施不能なテストが多い
* 適用範囲: ラボ構築、委託 SoW
* 例外: 静的 IPA 解析のみなど限定スコープ

### ホストは macOS を基本にするの実装例

```text
最小セット
* macOS + admin
* Xcode / 関連 CLI
* クライアント間通信可能な Wi-Fi（プロキシ用）
* 可能なら jailbroken 実機
* 傍受プロキシ
* 対象 UDID の記録（Finder / idevice_id 等）
```

## 実機・Simulator・仮想化の違いを計画に書く

Simulator は実機バイナリを動かさない。Apple silicon Mac 上の iOS アプリ実行も Simulator とは別環境である。

### 実機・Simulator・仮想化の違いを計画に書くの補足

* 利点: 「シミュレータで通った」ことを実機検証と混同しない
* 注意点: jailbreak は署名制約解除が目的で、Android root と同一ではない
* 適用範囲: 動的解析計画
* 例外: UI のみのスモークは Simulator 可（根拠を残す）

### 実機・Simulator・仮想化の違いを計画に書くの実装例

```text
推奨
* 動的解析: jailbroken 実機（専用端末）
* 機能確認: 署名付き実機ビルド
* Simulator: アーキテクチャ差を理解した補助用途
* Mac 上 iOS アプリ: MASTG-KNOW-0136 を参照して別検知
```

## Jailbreak は専用端末・自己責任・バージョン固定で扱う

署名ウィンドウとアップデートで再取得が困難になる。個人端末は使わない。

### Jailbreak は専用端末・自己責任・バージョン固定で扱うの補足

* 利点: ルート FS・未署名ツール・ランタイム解析が可能になる
* 注意点: 偽ツール／スパイウェアに注意。ブリックリスクは自己負担（章の警告）
* 適用範囲: 社内ラボ
* 例外: jailbreak 無しで可能な静的中心の評価

### Jailbreak は専用端末・自己責任・バージョン固定で扱うの実装例

```text
運用
* テスト専用機のみ jailbreak
* iOS 版と jailbreak 種別（tethered 等）を記録
* 検知無効 debug ビルドの有無を計画に明記
* バイパス手順の詳細 PoC を公開 docs に置かない
```

## ナレッジベース

### DO: テスト計画に「ホスト OS / 実機 or Simulator / jailbreak 有無 / 対象ビルド」を必須記載する

```text
# 推奨
host: macOS
device: physical jailbroken / Simulator
ios: x.y
build: TestFlight / ad-hoc / production-like
```

### DO NOT: 個人常用 iPhone を jailbreak して本番アカウントで解析する

* 理由: データ漏洩・端末破損・再現性低下のリスクが高い
* 理由: 章も専用機と慎重な版管理を前提にしている

```text
# DO NOT: 常用端末を jailbreak して本番ログイン

# DO: ワイプ可能な専用機とテストアカウントを使う
```

## 参考リンク

* iOS Security Testing: <https://mas.owasp.org/MASTG/0x06b-iOS-Security-Testing/>
* Platform Overview: <https://mas.owasp.org/MASTG/0x06a-Platform-Overview/>
