---
source: https://developer.android.com/security
scopes:
  - test
  - android
  - backend
  - mobile
  - privacy
  - identity
  - fraud-prevention
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Android Developers Security ハブ

## 概要

Android 公式 Security ハブは、セキュア／プライバシー実装の入口である。具体的なコーディング規約は `0002-security-tips.md` を正本とし、本ドキュメントはハブが示す実装領域ごとの最短プラクティスをまとめる。

* 索引: [`0000-index.md`](./0000-index.md)
* 関連: [`0002-security-tips.md`](./0002-security-tips.md)、[`0003-privacy-guidelines.md`](./0003-privacy-guidelines.md)、[`0004`](./0004-fraud-prevention-environment.md)–[`0006`](./0006-fraud-prevention-authentication.md)

## 実装領域をハブの区分で埋める

Security / Privacy / Identity / Fraud の区分ごとに、実装タスクを割り当てる。

### 実装領域をハブの区分で埋めるの補足

* 利点: 「どこから手を付けるか」が明確になる
* 注意点: チェックリスト閲覧だけで終わらせず、tips の禁止事項まで落とす
* 適用範囲: 新規機能、SDK 追加、リリース前レビュー
* 例外: なし

### 実装領域をハブの区分で埋めるの実装例

```text
Security … 0002 Security tips
* データ保存: 内部ストレージ + 必要なら Keystore
* 通信: HTTPS、cleartext 禁止、証明書検証維持
* IPC: exported 最小化、権限再委譲禁止

Privacy … 0003 プライバシー ガイドライン
* 権限最小化、目的説明、データ最小化
* 収集宣言と実装の一致

Identity / Auth … 0006 安全なユーザー認証
* Credential Manager / パスキー等の推奨認証
* パスワードの端末平文保存禁止

Fraud / Integrity … 0004 環境 / 0005 アクティビティ
* Play Integrity トークンはサーバで検証
* 機微画面: FLAG_SECURE / HIDE_OVERLAY_WINDOWS
* クライアント判定 alone で課金・権限を決めない
```

本番で Play Integrity プロバイダを使う例である。

```dart
// App Check activation (example)
if (debugToken.isEmpty) {
  return const AndroidPlayIntegrityProvider();
}
```

## 暗号とネットワークは OS 標準スタックを使う

自前プロトコルを避け、Keystore とプラットフォーム TLS を使う。

### 暗号とネットワークは OS 標準スタックを使うの補足

* 利点: 弱い自作暗号と検証スキップの常態化を防げる
* 注意点: Keystore 利用とバックアップ／ログ対策は別問題
* 適用範囲: トークン、個人データ、API 通信
* 例外: 公開データのみの画面

### 暗号とネットワークは OS 標準スタックを使うの実装例

```text
at-rest: Keystore 連携または認証 SDK への保管委譲
in-transit: 既定 TLS。badCertificate* 系を禁止
debug 例外: src/debug のみ cleartext 等を許可
```

```xml
<!-- debug 限定例 -->
<application android:usesCleartextTraffic="true" ... />
```

## ナレッジベース

### DO: ハブから入ったら領域ガイド（tips / privacy / fraud）で実装可否を判定する

```text
# 推奨フロー
developer.android.com/security（本ドキュメント）
  → 0002 tips / 0003 privacy / 0004–0006 fraud
  → マニフェスト / コード差分で確認
```

### DO NOT: 「サンドボックスがある」を理由に平文保存や広い exported を残す

* 理由: ハブ自身がチェックリストと個別対策を要求している
* 理由: バックアップ、IPC、外部ストレージで境界は壊れる

```text
# DO NOT: SharedPreferences に refresh token を平文保存

# DO: Keystore 連携または短命トークン + サーバ失効
```

## 参考リンク

* Android Security ハブ: <https://developer.android.com/security>
* Security tips: <https://developer.android.com/privacy-and-security/security-tips>
* プライバシー ガイドライン: <https://developer.android.com/privacy-and-security/about>
* Fraud prevention: <https://developer.android.com/security/fraud-prevention>
* Play Integrity: <https://developer.android.com/google/play/integrity>
* Keystore: <https://developer.android.com/privacy-and-security/keystore>
