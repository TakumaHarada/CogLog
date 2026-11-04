---
source: https://mas.owasp.org/MASTG/0x06a-Platform-Overview/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - platform-overview
  - mastg-ios-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
---

# MASTG 0x06a: iOS Platform Overview

## 概要

本ドキュメントは MASTG「iOS Platform Overview」を蒸留したものである。Secure Boot、コード署名、サンドボックス、Data Protection、権限、App Attest など、後続テストの前提となる iOS 境界を整理する。

* 正本: <https://mas.owasp.org/MASTG/0x06a-Platform-Overview/>
* 関連: `docs/security/mas.owasp.org/ios-testing/0000-index.md`

## OS のハードウェア境界を前提にアプリ責任を切り分ける

UID/SEP、Secure Boot、コード署名、サンドボックスは OS 側の前提である。Data Protection・Keychain・ATS・権限説明はアプリ実装で壊しうる。

### OS のハードウェア境界を前提にアプリ責任を切り分けるの補足

* 利点: 「iOS だから安全」とアプリ欠陥を混同しない
* 注意点: FairPlay はストア配信の DRM であり、アプリ独自の秘密保護の代替ではない
* 適用範囲: 脅威モデル、設計レビュー
* 例外: なし

### OS のハードウェア境界を前提にアプリ責任を切り分けるの実装例

```text
OS 前提
* Secure Boot Chain / コード署名
* サンドボックス（コンテナ隔離、W^X 寄り制約）
* ASLR / XN

アプリ責任
* Data Protection クラスと Keychain accessibility
* ATS 例外の最小化
* Usage Description と実挙動の一致
* App Attest / DeviceCheck はサーバ検証とセット
```

## Info.plist・権限・配布形態を攻撃面一覧にする

サイドロード／Enterprise／App Store で配布経路が違う。権限は実行時要求だが、Usage Description キーは必須である。

### Info.plist・権限・配布形態を攻撃面一覧にするの補足

* 利点: IPC が少ない iOS でも、URL scheme・拡張・共有面を見落とさない
* 注意点: DeviceCheck は jailbreak 検知の代替ではない（章が明示）
* 適用範囲: 静的レビュー、ストア提出前確認
* 例外: なし

### Info.plist・権限・配布形態を攻撃面一覧にするの実装例

```text
確認
* NS*UsageDescription の有無と文言
* URL Types / Universal Links
* App Groups / Keychain Access Groups
* App Attest entitlement 環境（production/development）
```

```xml
<!-- ios/Runner/Runner.entitlements -->
<key>com.apple.developer.devicecheck.appattest-environment</key>
<string>production</string>
```

## ナレッジベース

### DO: 新機能レビューで「OS 境界」と「アプリ境界」を一文ずつ書く

```text
# 推奨
OS: sandbox + code signing
App: Keychain WhenUnlockedThisDeviceOnly / ATS 既定 / App Attest サーバ検証
```

### DO NOT: Secure Enclave やサンドボックスを理由に Keychain／ATS／権限設計を省略する

* 理由: 章もアプリ側の誤り余地が大きいと述べている
* 理由: ローカル認証や平文 UserDefaults は OS 境界の外側で破られる

```text
# DO NOT: 「iOS はサンドボックスなので UserDefaults にトークンでよい」

# DO: Keychain / 非保存 / サーバ失効を選ぶ
```

## 参考リンク

* iOS Platform Overview: <https://mas.owasp.org/MASTG/0x06a-Platform-Overview/>
* Apple Platform Security: <https://support.apple.com/guide/security/welcome/web>
