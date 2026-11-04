---
source: https://mas.owasp.org/MASTG/0x05a-Platform-Overview/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - platform-overview
  - mastg-android-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
---

# MASTG 0x05a: Android Platform Overview

## 概要

本ドキュメントは MASTG「Android Platform Overview」を、実装／テスト設計向けに蒸留したものである。Android の防御階層、アプリ構造、公開面を理解し、後続の保存・通信・IPC テストの前提にする。

* 正本: <https://mas.owasp.org/MASTG/0x05a-Platform-Overview/>
* 関連: `docs/security/mas.owasp.org/android-testing/0000-index.md`

## 防御階層（Defense-in-Depth）を前提にアプリ境界を設計する

OS の TEE / SELinux / サンドボックス / TLS 既定を信頼しつつ、アプリ側の誤設定で境界を壊さない。

### 防御階層（Defense-in-Depth）を前提にアプリ境界を設計するの補足

* 利点: 「OS が守る部分」と「アプリが守る部分」を分けて監査できる
* 注意点: サンドボックスがあることは平文保存や広い exported の免罪符ではない
* 適用範囲: 脅威モデル、設計レビュー、Android 実装
* 例外: なし

### 防御階層（Defense-in-Depth）を前提にアプリ境界を設計するの実装例

```text
OS 側（前提として利用）
* File-Based Encryption / TEE・Keystore・StrongBox
* Verified Boot、SELinux、権限モデル
* TLS by Default / DNS over TLS（API レベル依存）

アプリ側（実装で壊さない）
* 他 UID へのデータ露出（MODE_WORLD_*、無防備 Provider）
* 権限再委譲、暗黙 Intent、クリアテキスト例外
* 鍵材料を TEE 外へ持ち出す自前保管
```

## Manifest とコンポーネント公開面を攻撃面一覧にする

`AndroidManifest.xml` の権限・exported・Intent-filter・バックアップ設定を、テスト計画の入口にする。

### Manifest とコンポーネント公開面を攻撃面一覧にするの補足

* 利点: Activities / Services / Receivers / Providers / IPC の見落としを減らせる
* 注意点: ライブラリマージ後の最終マニフェストを見る
* 適用範囲: 静的レビュー、リリースゲート
* 例外: なし

### Manifest とコンポーネント公開面を攻撃面一覧にするの実装例

```text
確認項目
* uses-permission の最小性
* android:exported の意図
* Intent-filter（ディープリンク含む）の必要性
* allowBackup / fullBackupContent
* 署名方式（v2/v3 等）と鍵管理（共有禁止）
```

```xml
<!-- 良い例の方向性 -->
<!-- android/app/src/main/AndroidManifest.xml -->
<application android:allowBackup="false" android:fullBackupContent="false" ...>
```

## 署名鍵と配布経路をセキュリティ境界として扱う

署名鍵漏洩は更新ハイジャックと同義である。CI 専用保管と強パスワードを必須にする。

### 署名鍵と配布経路をセキュリティ境界として扱うの補足

* 利点: ストア信頼と signature 権限の前提を守れる
* 注意点: IDE が平文で鍵パスを設定ファイルへ書くことがある
* 適用範囲: リリースパイプライン、鍵ローテーション計画
* 例外: なし

### 署名鍵と配布経路をセキュリティ境界として扱うの実装例

```text
実装チェック
* 本番鍵は開発者個人端末へ置かない
* apksigner 前に zipalign
* 鍵紛失＝更新不能を前提にバックアップ方針を文書化
* サイドロード許可設定をテスト端末と本番ユーザ端末で混同しない
```

## ナレッジベース

### DO: 新機能レビューで「どの OS 境界を前提にしているか」を一文で書く

```text
# 推奨
前提: アプリサンドボックス + Keystore
アプリ責任: トークンを外部ストレージへ書かない / exported を最小化
```

### DO NOT: OS の TEE や Verified Boot を理由にアプリ側の鍵・IPC 設計を省略する

* 理由: 章の防御階層は多層であり、アプリ層の欠陥は別経路で破られる
* 理由: 攻撃面はマニフェストと IPC に表れる

```text
# DO NOT: 「Android は安全なので SharedPreferences 平文でよい」

# DO: データ感度に応じた保存と公開面の最小化を行う
```

## 参考リンク

* Android Platform Overview: <https://mas.owasp.org/MASTG/0x05a-Platform-Overview/>
* Android Security tips: <https://developer.android.com/privacy-and-security/security-tips>
