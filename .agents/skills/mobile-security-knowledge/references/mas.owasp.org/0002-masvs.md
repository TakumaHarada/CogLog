---
source: https://mas.owasp.org/MASVS/
scopes:
  - test
  - android
  - ios
  - backend
  - mobile
  - storage
  - cryptography
  - authentication
  - network
  - privacy
  - security-review
updated_at: 2026-08-16
---

# OWASP MASVS（Mobile Application Security Verification Standard）

## 概要

OWASP MASVS はモバイルアプリセキュリティの検証標準である。本ドキュメントは制御群ごとに、実装・レビューで確認する具体プラクティスへ落とす。

* 制御の定義は公式 `controls/MASVS-*` を正本とする
* 関連: MASWE（失敗モード）、MASTG（検証手順）
* アプリ実装の参照例は導入アプリ（存在するもののみ引用）

## MASVS-STORAGE: 機微データは保護された保存領域に置く

意図的に端末へ残す機微データは、保存場所とバックアップ経路を含めて保護する（[MASVS-STORAGE-1](https://mas.owasp.org/MASVS/controls/MASVS-STORAGE-1/)）。

### MASVS-STORAGE: 機微データは保護された保存領域に置くの補足

* 利点: 他アプリ・バックアップ・物理取得からの漏洩面を縮小できる
* 注意点: 「アプリ私有ディレクトリにある」だけではトークン／パスワード保護として不十分な場合がある
* 適用範囲: アクセストークン、更新トークン、API 秘密、PII、認証セッション
* 例外: 公開コンテンツのキャッシュなど非機微データ

### MASVS-STORAGE: 機微データは保護された保存領域に置くの実装例

実装プラクティスである。

* パスワードや長期秘密を端末に保存しない。失効可能な短命トークンを使う
* Android: Keystore 連携の EncryptedSharedPreferences / Keystore 鍵。外部ストレージ禁止
* iOS: Keychain（適切な accessibility）。ファイル平文保存を避ける
* バックアップ除外: Android `allowBackup=false` または機微パス除外、iOS はバックアップ非対象属性を検討
* ログ・クラッシュレポート・分析 SDK にトークン／PII を出さない

バックアップを無効化した例である。

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application
    android:allowBackup="false"
    android:fullBackupContent="false"
    android:label="@string/app_name"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

トークン本体をログしない例である。

```dart
// infra_google_mobile, mobile_google_sign_in_proxy.dart
/// NOTE.
/// `account.authentication`はidTokenを含むため出力しない。
void _logSignInSuccess(gsi.GoogleSignInAccount account) {
  _log.i("signIn success");
  _log.i("  - id: ${account.id}");
  _log.i("  - email: ${account.email}");
}
```

## MASVS-NETWORK: TLS のプラットフォーム既定を壊さない

ネットワーク通信は現行ベストプラクティス（TLS・エンドポイント認証）で保護する（[MASVS-NETWORK-1](https://mas.owasp.org/MASVS/controls/MASVS-NETWORK-1/)）。

### MASVS-NETWORK: TLS のプラットフォーム既定を壊さないの補足

* 利点: MITM による資格情報・個人データ盗聴を防ぐ
* 注意点: `badCertificateCallback`、カスタム TrustManager、ATS/cleartext 例外で既定を無効化しやすい
* 適用範囲: API、分析、課金、WebView / アプリ内ブラウザ
* 例外: ローカル開発のみ。本番 flavor から分離する

### MASVS-NETWORK: TLS のプラットフォーム既定を壊さないの実装例

実装プラクティスである。

* 本番は HTTPS のみ。Android cleartext / iOS ATS 例外を本番に残さない
* 証明書検証をスキップするコードパスを禁止する（自己署名は開発用 CA で代替）
* サードパーティ SDK の通信先も TLS 対象に含める
* 機微データを SMS / プッシュ通知本文へ載せない
* ピンニングは脅威モデル次第（L2 相当）。導入する場合はローテーション手順を先に決める

debug 限定の cleartext 許可例（本番 main マニフェストには置かない）である。

```xml
<!-- android/app/src/debug/AndroidManifest.xml -->
<application
    android:usesCleartextTraffic="true"
    tools:ignore="MissingApplicationIcon" />
```

既定の `HttpClient` を使い、証明書検証の無効化コールバックを付けない例である。

```dart
// RPC / API client (example)
static final _httpClientProvider = Provider<io.HttpClient>(
  (ref) {
    final result = io.HttpClient();
    ref.keepAlive();
    ref.onDispose(() {
      result.close();
    });
    return result;
  },
);
```

## MASVS-AUTH: 認証材料は短命・失効可能にし認可はサーバで決める

クライアントはプロトコルの安全な利用に責任を持ち、認可の最終決定はリモートエンドポイント側とする（[MASVS-AUTH-1](https://mas.owasp.org/MASVS/controls/MASVS-AUTH-1/)）。

### MASVS-AUTH: 認証材料は短命・失効可能にし認可はサーバで決めるの補足

* 利点: 端末紛失・バイナリ解析時の永続侵害を抑えられる
* 注意点: クライアントの role フラグや「管理者です」ヘッダを信頼しない
* 適用範囲: ログイン、セッション、ステップアップ認証、API 認可
* 例外: 完全オフライン機能は別脅威モデル（根拠を残す）

### MASVS-AUTH: 認証材料は短命・失効可能にし認可はサーバで決めるの実装例

実装プラクティスである。

* 「Remember Me」でパスワードを端末保存しない
* 端末固有・失効可能なトークンを使う。デバイス ID や位置情報 alone で認証しない
* 生体認証は鍵／秘密のアンロックに使い、成功ブール値だけで API を通さない
* Backend で権限を再検証する。App Check / attestation は「正規クライアント」の補助であり認可の代替ではない

Firebase ID Token と App Check をリクエストへ付与し、サーバ側検証前提とする例である。

```dart
// RPC / API client (example)
interceptors.add(_apiKeyInterceptor(apiKey));
final appCheckToken = await _resolveAppCheckToken();
interceptors.add(_appCheckInterceptor(appCheckToken));
switch (request) {
  case RpcFetchRequestUnauthorized():
    break;
  case RpcFetchRequestAuthorized():
    final idToken = await user.getIdToken();
    interceptors.add(
      _authorizationInterceptor("Bearer $idToken"),
    );
}
```

本番で Play Integrity / App Attest を有効化する例である。

```dart
// App Check activation (example)
await appCheck.activate(
  providerAndroid: () {
    const debugToken = String.fromEnvironment('APP_CHECK_DEBUG_TOKEN');
    if (debugToken.isEmpty) {
      return const AndroidPlayIntegrityProvider();
    } else {
      return AndroidDebugProvider(debugToken: debugToken);
    }
  }(),
  providerApple: () {
    const debugToken = String.fromEnvironment('APP_CHECK_DEBUG_TOKEN');
    if (debugToken.isEmpty) {
      return const AppleAppAttestProvider();
    } else {
      return AppleDebugProvider(debugToken: debugToken);
    }
  }(),
);
```

## MASVS-PLATFORM: エクスポート面とディープリンクを最小化する

OS コンポーネント、他アプリ、クリップボード、WebView、通知からの機微データ露出を防ぐ。

### MASVS-PLATFORM: エクスポート面とディープリンクを最小化するの補足

* 利点: Intent / URL scheme 経由の不正起動やデータ注入を減らせる
* 注意点: ライブラリが追加する exported コンポーネントも成果物で確認する
* 適用範囲: Activity/Service/Receiver、App Links、Share、WebView
* 例外: 明示的に外部連携がプロダクト要件の場合（検証・署名付きリンク等）

### MASVS-PLATFORM: エクスポート面とディープリンクを最小化するの実装例

実装プラクティスである。

* 不要な Deep Link / App Links を有効化しない
* `android:exported` を意図どおりにする。暗黙 Intent の受信を最小化
* WebView は JS bridge・file access・混合コンテンツを既定で閉じる
* 機微画面はスクリーンショット／通知プレビュー対策を検討する（L2 相当）

Deep Link 自動処理を無効化した例である。

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<meta-data
  android:name="flutter_deeplinking_enabled"
  android:value="false" />
```

## MASVS-CRYPTO / CODE / PRIVACY / RESILIENCE: 実装時の最短ルール

### MASVS-CRYPTO / CODE / PRIVACY / RESILIENCE: 実装時の最短ルールの補足

* 利点: 制御群ごとの最低ラインを実装チェックリスト化できる
* 注意点: Resilience（耐タンパ）は全アプリ必須ではない。脅威モデルで要否を決める
* 適用範囲: 暗号利用、依存関係、権限・同意、改ざん耐性
* 例外: なし

### MASVS-CRYPTO / CODE / PRIVACY / RESILIENCE: 実装時の最短ルールの実装例

```text
CRYPTO
* OS 提供 API（Keystore/Keychain, platform TLS）を使う
* 自前プロトコル／自作 AES+固定 IV／Math.random 由来鍵を禁止
* 非推奨アルゴリズム（MD5/SHA1 署名、RC4 等）を新規採用しない

CODE
* 依存関係の既知 CVE をリリース前にトリアージする
* 動的コードロードやデバッグ API の本番残留を禁止する
* targetSdk / 最小 OS を政策どおり更新する

PRIVACY
* 権限は最小。目的文字列と実挙動を一致させる
* トラッキング／収集宣言（ストア・Privacy Manifest）と実装を一致させる
* 同意なしで機微データを収集・送信しない

RESILIENCE（必要な場合のみ）
* ルート検出・難読化・改ざん検知は「追加層」。サーバ認可の代替にしない
```

## ナレッジベース

### DO: 制御 ID ごとに「保存場所・通信経路・認可境界」をレビューコメントへ書く

```text
# 推奨
MASVS-STORAGE-1: トークンは Firebase Auth SDK 管理。平文 Preferences に ID Token を書かない
MASVS-NETWORK-1: 本番 cleartext なし。証明書検証スキップなし
MASVS-AUTH-1: 認可は backend。App Check は正規クライアント補助
```

### DO NOT: プラットフォーム既定の TLS／サンドボックスを無効化して「動くこと」を優先する

* 理由: MASVS-NETWORK / PLATFORM の中核は既定防護の維持である
* 理由: 例外は開発限定とし、本番成果物から除去する

```text
# DO NOT
HttpClient().badCertificateCallback = (_, __, ___) => true;

# DO
本番はプラットフォーム既定の証明書検証を維持する
開発はローカル CA またはエミュレータ専用設定に閉じる
```

## 参考リンク

* OWASP MASVS: <https://mas.owasp.org/MASVS/>
* MASVS-STORAGE-1: <https://mas.owasp.org/MASVS/controls/MASVS-STORAGE-1/>
* MASVS-NETWORK-1: <https://mas.owasp.org/MASVS/controls/MASVS-NETWORK-1/>
* MASVS-AUTH-1: <https://mas.owasp.org/MASVS/controls/MASVS-AUTH-1/>
