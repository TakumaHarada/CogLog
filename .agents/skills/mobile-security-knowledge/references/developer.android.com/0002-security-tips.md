---
source: https://developer.android.com/privacy-and-security/security-tips
scopes:
  - test
  - android
  - backend
  - mobile
  - storage
  - permissions
  - network
  - webview
  - ipc
  - cryptography
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Android Security tips（セキュアコーディング）

## 概要

Android 公式 Security tips に基づく実装プラクティス集である。マニフェスト設定、保存、権限、ネットワーク、IPC、WebView、暗号の具体ルールを DO / DO NOT 監査向けに落とす。

* 関連: [`0000-index.md`](./0000-index.md)、[`0001-security.md`](./0001-security.md)、[`0003-privacy-guidelines.md`](./0003-privacy-guidelines.md)
* 引用例: 導入アプリの Android 設定（存在すれば）
* 正本: <https://developer.android.com/privacy-and-security/security-tips>

## 保存: 内部ストレージ既定、外部は非機微のみ

内部ストレージのアプリ私有領域を既定とし、外部ストレージへ機微データを置かない。バックアップ経路も閉じる。

### 保存: 内部ストレージ既定、外部は非機微のみの補足

* 利点: 他アプリやメディア抜き取りによる漏洩を減らせる
* 注意点: MODE_WORLD_READABLE/WRITEABLE は使わない。共有は ContentProvider
* 適用範囲: ファイル、DB、Preferences、バックアップ
* 例外: ユーザが明示共有する非機微ファイル

### 保存: 内部ストレージ既定、外部は非機微のみの実装例

```text
実装チェック
* トークン / 秘密鍵を getExternalStorage* 配下へ書かない
* 実行ファイルを外部ストレージから動的ロードしない（するなら署名検証必須）
* ContentProvider は不要なら android:exported=false
* 自アプリ間共有は protectionLevel=signature を優先
* query/update/delete はパラメータ化。selection を文字列連結しない
```

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application
    android:allowBackup="false"
    android:fullBackupContent="false"
    ... >
```

## 権限と IPC: 最小権限、再委譲禁止、明示 Intent

要求権限を最小化し、権限で得たデータを権限のない相手へ IPC 経由で渡さない。

### 権限と IPC: 最小権限、再委譲禁止、明示 Intent の補足

* 利点: 攻撃面と誤用、ユーザ離脱を同時に減らせる
* 注意点: ライブラリが追加する権限・exported もマージ後マニフェストで確認する
* 適用範囲: uses-permission、カスタム permission、Activity/Service/Receiver
* 例外: なし

### 権限と IPC: 最小権限、再委譲禁止、明示 Intent の実装例

```text
実装チェック
* 機能に不要な権限を削除する（端末 ID 取得の代替にアプリ内 UUID 等）
* 暗黙 Intent で機微コンポーネントを起動可能にしない
* 受信側は意図した package / signature を検証する
* 権限付きデータを「薄いラッパ API」で他アプリへ再公開しない
```

Deep Link 自動処理を無効化し、意図しない外部入口を閉じる例である。

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<meta-data
  android:name="flutter_deeplinking_enabled"
  android:value="false" />
<intent-filter>
  <action android:name="android.intent.action.MAIN"/>
  <category android:name="android.intent.category.LAUNCHER"/>
</intent-filter>
```

## ネットワークと WebView: cleartext 禁止、検証スキップ禁止

本番通信は TLS。WebView は信頼できないコンテンツとローカルリソースの交差を閉じる。

### ネットワークと WebView: cleartext 禁止、検証スキップ禁止の補足

* 利点: MITM と Web コンテンツ注入を防げる
* 注意点: debug の cleartext を main / release へマージしない
* 適用範囲: OkHttp/HttpURLConnection/dart:io、WebView、ディープリンク URL
* 例外: エミュレータ開発のみ（debug ソースセット）

### ネットワークと WebView: cleartext 禁止、検証スキップ禁止の実装例

```text
実装チェック
* release で usesCleartextTraffic=true や permissive networkSecurityConfig が無い
* X509TrustManager / HostnameVerifier を空実装していない
* WebView: setAllowFileAccess(false) 相当、不要な addJavascriptInterface 禁止
* https ページからの file:// や混合コンテンツを許可しない
* 入力（URL・HTML・Intent extra）を検証する。最終検証はサーバ
```

```xml
<!-- android/app/src/debug/AndroidManifest.xml -->
<!-- DO: debug 限定。release の main には置かない -->
<application
    android:usesCleartextTraffic="true"
    tools:ignore="MissingApplicationIcon" />
```

## 認証・暗号・API キー: プラットフォーム部品を使う

Credential Manager / 生体認証、Android Keystore、公式暗号 API を使い、自前鍵管理を避ける。

### 認証・暗号・API キー: プラットフォーム部品を使うの補足

* 利点: 弱い乱数・固定鍵・自作プロトコルの失敗を避けられる
* 注意点: クライアント埋め込み API Key は抽出前提。サーバ側で追加制御する
* 適用範囲: ログイン、トークン、ローカル暗号、サードパーティキー
* 例外: なし

### 認証・暗号・API キー: プラットフォーム部品を使うの実装例

```text
実装チェック
* パスワードを SharedPreferences 平文保存しない
* Keystore 鍵で必要データを暗号化する（または認証 SDK に保管を委譲）
* Play Integrity 等はサーバでトークン検証する
* API キーはビルド種別ごとに分離し、ログ出力しない
* 非推奨暗号（MD5 パスワード格納等）を新規採用しない
```

App Check（Play Integrity）を本番有効化した例である。

```dart
// App Check activation (example)
if (debugToken.isEmpty) {
  return const AndroidPlayIntegrityProvider();
} else {
  return AndroidDebugProvider(debugToken: debugToken);
}
```

## ナレッジベース

### DO: マージ後の最終 AndroidManifest で security 属性を確認する

* ソース分散（main/debug/ライブラリ）の合成結果を見る

```text
# 推奨
./gradlew :app:processReleaseMainManifest
確認: allowBackup, usesCleartextTraffic, exported, permission
```

### DO NOT: 証明書検証や WebView 制限を「一時的に」外して release へ残す

* 理由: Security tips が明示する高リスクパターンである
* 理由: 開発例外の残留は M5/M8 に直結する

```text
# DO NOT（概念）
trustAllCerts = true を共通モジュールへ置く

# DO
検証スキップは禁止。開発はローカル CA かエミュレータ専用ビルドへ閉じる
```

## 参考リンク

* Security tips: <https://developer.android.com/privacy-and-security/security-tips>
* Security ハブ: <https://developer.android.com/security>
* Android Keystore: <https://developer.android.com/privacy-and-security/keystore>
