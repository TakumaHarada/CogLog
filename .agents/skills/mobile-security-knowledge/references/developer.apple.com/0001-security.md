---
source: https://developer.apple.com/security/
scopes:
  - test
  - ios
  - mobile
  - app-transport-security
  - privacy
  - authentication
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Apple Developer Security

## 概要

Apple Developer Security ハブに基づく、iOS アプリ実装向けプラクティスである。ATS、Keychain、プライバシー申告、App Attest 連携など、コードと Info.plist / entitlements で確認できる項目へ落とす。

* OS 設計の詳細は `docs/security/support.apple.com/0001-platform-security.md`
* 引用例: 導入アプリの iOS 設定（存在すれば）

## App Transport Security を本番で維持する

ATS の既定（HTTPS・十分な TLS）を緩めず、例外は最小・理由付き・期限付きとする。

### App Transport Security を本番で維持するの補足

* 利点: 平文や弱い TLS への後退を防げる
* 注意点: SDK が ATS 例外を要求しても、例外ドメインを無制限に広げない
* 適用範囲: URLSession、WKWebView、サードパーティネットワークスタック
* 例外: ローカル開発のみ。本番 Info.plist から除去する

### App Transport Security を本番で維持するの実装例

```text
実装チェック
* NSAllowsArbitraryLoads=true を本番に置かない
* 例外は必要ドメインのみ。NSExceptionAllowsInsecureHTTPLoads を安易に true にしない
* 自己署名を許可する NSURL 検証スキップ API を使わない
* 第三者 WebView セッションで mixed content を許さない
```

ATS を上書きしていない（＝既定 ATS）例として、本番 Info.plist に広範な ATS 例外キーが無い状態を維持する。

```xml
<!-- ios/Runner/Info.plist（抜粋） -->
<key>FlutterDeepLinkingEnabled</key>
<false/>
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

## Keychain と認証材料の扱い

パスワードを端末保存せず、Keychain の accessibility を脅威モデルに合わせて選ぶ。

### Keychain と認証材料の扱いの補足

* 利点: ファイル平文保存より耐性がある
* 注意点: `kSecAttrAccessibleAlways` 系の安易な選択はロック中漏洩面を広げる
* 適用範囲: リフレッシュトークン、鍵、機密設定
* 例外: 認証 SDK（例: Firebase Auth）に保管を委譲する場合は、自前二重保存しない

### Keychain と認証材料の扱いの実装例

```text
実装チェック
* パスワードの UserDefaults 保存を禁止する
* 必要なら Keychain + 適切な accessibility（例: WhenUnlockedThisDeviceOnly）
* 生体は鍵アンロックに使い、LocalAuthentication 成功 alone で API 認可しない
* ログアウト／退会で Keychain 項目を削除する
```

## プライバシー申告と App Attest

収集宣言と実装を一致させ、改ざん耐性シグナルはサーバ検証とセットにする。

### プライバシー申告と App Attest の補足

* 利点: ストア要件と MASVS-PRIVACY、不正クライアント検出に効く
* 注意点: Debug Provider を本番に残さない
* 適用範囲: Privacy Manifest、権限説明文、App Check / App Attest
* 例外: なし

### プライバシー申告と App Attest の実装例

```text
実装チェック
* NSCameraUsageDescription 等の目的文が実機能と一致
* Privacy Manifest の Required Reason API / トラッキング宣言を SDK 更新のたびに再確認
* App Attest entitlement の環境（production/development）が意図どおり
```

```xml
<!-- ios/Runner/Runner.entitlements -->
<key>com.apple.developer.devicecheck.appattest-environment</key>
<string>production</string>
```

```dart
// App Check activation (example)
if (debugToken.isEmpty) {
  return const AppleAppAttestProvider();
} else {
  return AppleDebugProvider(debugToken: debugToken);
}
```

## ナレッジベース

### DO: iOS 変更で Info.plist / entitlements / 通信コードをセットでレビューする

```text
# 推奨
* ATS 例外の差分
* Keychain 追加項目の accessibility
* 権限説明文と Privacy Manifest
* App Attest / 署名関連 entitlement
```

### DO NOT: 開発用 ATS 緩和や Debug Attest を release 設定へ残す

* 理由: M5/M8 相当の設定不備になる
* 理由: 例外は「動かすため」に増えやすく、削除されにくい

```text
# DO NOT
NSAllowsArbitraryLoads = true を共通 plist へ入れる

# DO
本番は ATS 既定。開発用例外は Debug xcconfig / scheme に閉じる
```

## 参考リンク

* Apple Developer Security: <https://developer.apple.com/security/>
* Apple Platform Security: <https://support.apple.com/guide/security/welcome/web>
* App Transport Security: <https://developer.apple.com/documentation/security/preventing-insecure-network-connections>
