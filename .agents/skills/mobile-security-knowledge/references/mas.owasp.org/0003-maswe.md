---
source: https://mas.owasp.org/MASWE/
scopes:
  - test
  - android
  - ios
  - backend
  - mobile
  - weakness
  - security-review
  - implementation
updated_at: 2026-08-16
---

# OWASP MASWE（Mobile Application Security Weakness Enumeration）

## 概要

OWASP MASWE はモバイル固有の弱点カタログである。本ドキュメントは頻出弱点について、実装時の具体的な緩和（Mitigations）へ落とす。ID の定義は公式一覧を正本とする。

* 弱点は脆弱性そのものではなく、導入条件となりうる
* 関連: `docs/security/mas.owasp.org/0002-masvs.md`

## 保存・ログ系弱点を実装で塞ぐ

ストレージとログは、端末取得・バックアップ・サポートログ経由で漏れやすい。

### 保存・ログ系弱点を実装で塞ぐの補足

* 利点: MASVS-STORAGE 違反の典型経路を先に潰せる
* 注意点: 「暗号化している」より「どこに・誰が読めるか」を先に設計する
* 適用範囲: Preferences、DB、ファイル、ログ、バックアップ
* 例外: 非機微な表示用キャッシュ

### 保存・ログ系弱点を実装で塞ぐの実装例

```text
MASWE-0002 私有領域外への非暗号化保存
* 外部ストレージ / 共有メディアへトークン・PII を書かない
* 共有が必要なら ContentProvider + 最小権限

MASWE-0003 鍵をプラットフォーム Keystore 外へ
* 鍵材料をソース・Assets・平文 Preferences に置かない
* Android Keystore / iOS Keychain を使う

MASWE-0004 パッケージ内ハードコード秘密
* パスワード・秘密鍵・本番管理用トークンをリポジトリへ入れない
* クライアント API Key は抽出前提でサーバ側制限を付ける

MASWE-0005 ログへの機微データ挿入
* Authorization / idToken / パスワードをログしない
* クラッシュレポートのパンくずからも除去する

MASWE-0006 バックアップ除外漏れ
* allowBackup=false または機微データをバックアップ対象外にする
```

```dart
// infra_google_mobile, mobile_google_sign_in_proxy.dart
/// `account.authentication`はidTokenを含むため出力しない。
void _logSignInSuccess(gsi.GoogleSignInAccount account) {
  _log.i("signIn success");
  _log.i("  - id: ${account.id}");
}
```

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application android:allowBackup="false" android:fullBackupContent="false" ...>
```

## 通信・プラットフォーム系弱点を実装で塞ぐ

ネットワーク検証とコンポーネント公開設定は、実装一行で崩壊しうる。

### 通信・プラットフォーム系弱点を実装で塞ぐの補足

* 利点: MITM と Intent / WebView 経由の侵入を防げる
* 注意点: ライブラリのデフォルト設定も成果物で確認する
* 適用範囲: TLS、ディープリンク、Intent、WebView
* 例外: debug 限定の開発例外（本番分離必須）

### 通信・プラットフォーム系弱点を実装で塞ぐの実装例

```text
MASWE-0026 通信非暗号化
* 本番 HTTP を禁止。cleartext 例外を release から除去

MASWE-0027 証明書検証不備
* badCertificateCallback / 空 TrustManager / 常時 pin 失敗無視を禁止
* 開発用スキップはビルド種別で隔離

MASWE-0028 ピンニング不備（採用時）
* ピン更新・バックアップピン・障害時手順を先に設計する

MASWE-0029 不安全な Deep Links
* 未使用なら無効化。使うなら署名付き App Links / サーバ検証

MASWE-0032 不安全な Intent（Android）
* exported を最小化。暗黙 Intent で機微処理を晒さない

MASWE-0033〜0035 WebView
* JS bridge 最小化、信頼できない URL をロードしない
* file access / 混合コンテンツを閉じる
```

Deep Link 無効化の例である。

```xml
<meta-data
  android:name="flutter_deeplinking_enabled"
  android:value="false" />
```

## 認証・依存・プライバシー系弱点を実装で塞ぐ

クライアント改ざんと依存関係、権限宣言のずれを前提に設計する。

### 認証・依存・プライバシー系弱点を実装で塞ぐの補足

* 利点: 「アプリが正しいと言っている」ことをサーバが信じない設計になる
* 注意点: App Attest / Play Integrity は正規クライアント補助であり権限代替ではない
* 適用範囲: ログイン、セッション、SDK、権限、ストア申告
* 例外: なし

### 認証・依存・プライバシー系弱点を実装で塞ぐの実装例

```text
MASWE-0018 コンポーネントの認証・認可不足
* エクスポート API / ローカルエンドポイントにも認可を付ける

MASWE-0020〜0022 ローカル認証バイパス
* 生体成功ブール alone で秘密操作を許可しない
* 鍵を biometric 無効化ポリシー付きで保護する

MASWE-0044 既知脆弱性依存
* CI で依存スキャン。High 以上はリリース前に対応または期限付き例外

MASWE-0066 不適切な権限管理
* 未使用権限を削除。実行時は文脈に応じて要求

MASWE-0072〜0074 プライバシー申告不足
* 収集・トラッキング宣言と SDK 実態を一致させる
```

サーバ検証前提でトークンを付与する例である。

```dart
// RPC / API client (example)
interceptors.add(_apiKeyInterceptor(apiKey));
interceptors.add(_appCheckInterceptor(await _resolveAppCheckToken()));
final idToken = await user.getIdToken();
interceptors.add(_authorizationInterceptor("Bearer $idToken"));
```

## ナレッジベース

### DO: 指摘票に MASWE ID と「直すコード／設定箇所」を必ず書く

```text
# 推奨
MASWE-0005: FooLogger で Authorization を info 出力している → マスクまたは削除
MASWE-0026: release に usesCleartextTraffic=true → 削除
```

### DO NOT: 弱点を「将来の耐タンパ（R）」に先送りして基本制御を空ける

* 理由: STORAGE/NETWORK/AUTH の多くは L1 相当の基本である
* 理由: 難読化は平文保存や cleartext を救わない

```text
# DO NOT: 難読化導入までトークン平文保存を許容する

# DO: 保存・通信・認可の基本弱点を先に閉じる
```

## 参考リンク

* OWASP MASWE: <https://mas.owasp.org/MASWE/>
* OWASP MASVS: <https://mas.owasp.org/MASVS/>
