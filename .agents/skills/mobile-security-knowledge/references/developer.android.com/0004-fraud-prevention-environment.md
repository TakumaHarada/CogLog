---
source: https://developer.android.com/security/fraud-prevention/environment
scopes:
  - test
  - android
  - backend
  - mobile
  - fraud-prevention
  - play-integrity
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Android Fraud Prevention: 環境を保護する

## 概要

本ドキュメントは [環境を保護する](https://developer.android.com/security/fraud-prevention/environment) を蒸留したものである。Play Integrity API を中心に、正規バイナリ・正規デバイス・アクセスリスク・Play プロテクト等のシグナルを**サーバ側で評価**し、不正操作を緩和する。

* 正本: <https://developer.android.com/security/fraud-prevention/environment>
* 関連: `0001-security.md`、Firebase App Check / Play Integrity 実装

## Play Integrity をサーバ検証前提で組み込む

クライアント取得トークン alone で権限を決めず、バックエンドで判定し追加確認や拒否を行う。

### Play Integrity をサーバ検証前提で組み込むの補足

* 利点: 改変アプリ・非正規端末・高リスク環境からの不正を抑えられる
* 注意点: エラー処理と再試行戦略が必要。クォータと標準/クラシック依頼の使い分けがある
* 適用範囲: ログイン、課金、アカウント変更等の価値の高い操作
* 例外: なし（未導入なら脅威モデルで根拠を残す）

### Play Integrity をサーバ検証前提で組み込むの実装例

```text
判定で見るもの（要約）
* 正規アプリバイナリ（改変なし）
* 正規 Play インストール / ライセンス
* 真正な Android デバイス
* 既知マルウェアなし（Play プロテクト）
* 他アプリによるアクセスリスク（画面キャプチャ / 制御）

フロー
1. 重要操作の直前にトークン取得（標準リクエストを基本）
2. サーバで検証
3. リスクに応じ step-up / 拒否 / ユーザへ是正依頼

実装例（本番で Play Integrity プロバイダ）
```

```dart
// App Check activation (example)
if (debugToken.isEmpty) {
  return const AndroidPlayIntegrityProvider();
}
```

## アクセスリスクと Play プロテクトを段階的に扱う

全面拒否より、価値の高い操作の前にリスク低減（キャプチャ可能なアプリ停止依頼等）を検討する。

### アクセスリスクと Play プロテクトを段階的に扱うの補足

* 利点: UX を壊しすぎずに不正面を減らせる
* 注意点: 検証済みユーザー補助アプリは自動除外される。判定はユーザ/デバイス ID に紐づけない設計
* 適用範囲: 機微操作、ゲーム不正対策、バンキング相当機能
* 例外: デバイス信頼が不足し評価不能な場合のフォールバック方針を決める

### アクセスリスクと Play プロテクトを段階的に扱うの実装例

```text
例
* UNKNOWN_CAPTURING → 画面キャプチャ可能なアプリを閉じるよう案内してから継続
* Play Protect HIGH_RISK → 警告対応を依頼、満たせなければサーバでブロック
* recentDeviceActivity が高すぎる → 再試行延期または強化対策
```

## Automatic Integrity Protection は制約を理解して使う

改ざん・再配布対策の自動保護はパートナー限定の場合がある。Play App Signing 必須、保護版の事前テスト必須。

### Automatic Integrity Protection は制約を理解して使うの補足

* 利点: サーバ統合無しで改ざん耐性を足せる場合がある
* 注意点: 未保護版を公開しない、他の改ざん対策との併用に注意、クラッシュ監視
* 適用範囲: Play 配信アプリ
* 例外: 機能が Console で利用できない場合は対象外

### Automatic Integrity Protection は制約を理解して使うの実装例

```text
運用
* 本番昇格前に保護ビルドをテスト
* 未保護版を並行公開しない
* クラック版は Play へ報告可能
```

## ナレッジベース

### DO: Integrity トークンの合否ロジックをサーバに置き、クライアント表示は補助にする

```text
# 推奨
client: request token
server: verify + decide allow/step-up/deny
telemetry: error codes + retry policy
```

### DO NOT: クライアントの「Integrity OK」フラグ alone で機微 API を通す

* 理由: クライアントは改ざん前提である
* 理由: 公式フローもサーバ判定を前提にする

```text
# DO NOT: if (localIntegrityOk) grantAdmin()

# DO: サーバ検証結果でのみ機微操作を許可
```

## 参考リンク

* 環境を保護する: <https://developer.android.com/security/fraud-prevention/environment>
* Play Integrity: <https://developer.android.com/google/play/integrity>
* Fraud prevention: <https://developer.android.com/security/fraud-prevention>
