---
source: https://mas.owasp.org/MASTG/0x05b-Android-Security-Testing/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - test-environment
  - mastg-android-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
---

# MASTG 0x05b: Android Security Testing（環境構築）

## 概要

本ドキュメントは MASTG「Android Security Testing」を蒸留したものである。ホスト／実機／エミュレータの選定、特権取得、ルート検知への向き合い方など、MASTG テストケース実施の土台を定義する。

* 正本: <https://mas.owasp.org/MASTG/0x05b-Android-Security-Testing/>
* 関連 Tests: `docs/security/mas.owasp.org/tests/0000-index.md`

## テスト環境を目的別に選ぶ

動的解析は実機推奨、API 切替やスナップショットはエミュレータを併用する。

### テスト環境を目的別に選ぶの補足

* 利点: 速度・ハードウェア・ルート容易性のトレードオフを明示できる
* 注意点: エミュレータはアーティファクトが多く、ルート／エミュレータ検知に引っかかりやすい
* 適用範囲: セキュリティテスト計画、ラボ構築
* 例外: なし

### テスト環境を目的別に選ぶの実装例

```text
ホスト
* Android SDK platform-tools / emulator /（必要なら）NDK
* 端末ミラーが必要なら scrcpy 等

実機
* unlockable bootloader / コミュニティサポートがある機種を優先
* Developer options + USB debugging
* 個人端末はルートしない（専用テスト端末）

エミュレータ
* 公式 AVD を基本とする
* スナップショットはマルウェア解析等で有用
```

## 特権取得は専用端末・書面の許可範囲で行う

ルートはサンドボックス制限を外すために有用だが、保証・ブリック・追加リスクがある。

### 特権取得は専用端末・書面の許可範囲で行うの補足

* 利点: Frida 等の動的手法を安定して使える
* 注意点: Magisk 等の systemless root でも検知は完全回避できない。OWASP は損害責任を負わない旨が原文にある
* 適用範囲: 社内ラボ、委託テストの環境条項
* 例外: ルート無しで可能な静的解析のみの場合

### 特権取得は専用端末・書面の許可範囲で行うの実装例

```text
運用
* テスト専用端末のみルート
* ルート手法と Magisk 版をテスト記録へ残す
* 本番相当ビルドと「ルート検知無効の debug ビルド」のどちらを使うかを計画に明記
* ルート検知バイパス手順の詳細 PoC を公開 docs に置かない（合否と影響のみ）
```

## ナレッジベース

### DO: テスト計画に「実機/AVD」「API level」「root 有無」「対象ビルド種別」を必須記載する

```text
# 推奨
device: Pixel (physical, Magisk)
api: 34
build: release 相当 / root-detection disabled debug
tools: adb, frida (approved)
```

### DO NOT: 個人利用端末をルートして本番アカウントで動的解析する

* 理由: データ漏洩・マルウェア・保証失効のリスクが高い
* 理由: テスト結果の再現環境が個人依存になる

```text
# DO NOT: 自分の常用スマホをルートして本番ログイン

# DO: ワイプ可能な専用端末とテストアカウントを使う
```

## 参考リンク

* Android Security Testing: <https://mas.owasp.org/MASTG/0x05b-Android-Security-Testing/>
* Platform Overview: <https://mas.owasp.org/MASTG/0x05a-Platform-Overview/>
