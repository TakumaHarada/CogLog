---
source: https://firebase.google.com/docs/app-check
scopes:
  - test
  - backend
  - firebase
  - mobile
  - app-check
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Firebase App Check

## 概要

本ドキュメントは [Firebase App Check](https://firebase.google.com/docs/app-check) と enforcement / metrics ガイドを蒸留したものである。正規アプリ／デバイス証明でバックエンド乱用を抑え、Auth とは役割を分ける。

* 正本: <https://firebase.google.com/docs/app-check>
* Enforcement: <https://firebase.google.com/docs/app-check/enable-enforcement>
* Metrics: <https://firebase.google.com/docs/app-check/monitor-metrics>
* 関連: 導入先バックエンドの API セキュリティ文書（存在すれば）

## App Check と Authentication を併用する

Authentication はユーザー保護、App Check は開発者側リソース保護である。両方を要求し、サーバで検証する。クライアント表示 alone で通さない。

### App Check と Authentication を併用するの補足

* 利点: 改変クライアントや不正スクリプトからの API 乱用を減らせる
* 注意点: 全攻撃を防ぐ保証はない。Rules / IAM と多層にする
* 適用範囲: Firestore / Storage / Auth / カスタムバックエンド
* 例外: 公開読み取り専用の管理キー等、プロダクト仕様で App Check を適用しない経路がある場合は文書化し限定する

### App Check と Authentication を併用するの実装例

本番では Play Integrity / App Attest を使う例である。

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

カスタムバックエンドへはヘッダで付与する。

```dart
// RPC / API client (example)
const _appCheckHeaderName = "X-Firebase-AppCheck";
```

## メトリクスを見てから enforcement する

SDK 導入後、Verified 比率が十分になるまで監視し、その後に強制する。未リリースなら即強制してよい。リプレイ保護は機微 API に限定し、limited-use token 対応を先に広げる。

### メトリクスを見てから enforcement するの補足

* 利点: 旧バージョン切断による大量障害を避けられる
* 注意点: 強制後は未統合クライアントが拒否される
* 適用範囲: 本番 Firebase プロダクトとカスタム API
* 例外: 新規アプリでユーザーがいない段階は即 enforced

### メトリクスを見てから enforcement するの実装例

```text
判断
* ほぼ Verified → enforcement 検討
* 古いクライアントが多い → 更新浸透を待つ
* 未ローンチ → すぐ enforced
* Replay: 機微のみ、先に limited-use 対応
```

## ナレッジベース

### DO: 対応プロダクトとカスタム API の両方で App Check をサーバ検証する

```text
# 推奨
client: Play Integrity / App Attest
server: verify App Check JWT then ID token
debug provider: non-prod only
```

### DO NOT: Debug provider や未検証トークンを本番の通過条件にする

* 理由: 証明の意味が消える
* 理由: 公式もメトリクス後の強制と正規プロバイダを前提にする

```text
# DO NOT: 本番で AndroidDebugProvider を常時使用

# DO: 空 debugToken のときのみ Integrity / App Attest
```

## 参考リンク

* App Check: <https://firebase.google.com/docs/app-check>
* Enable enforcement: <https://firebase.google.com/docs/app-check/enable-enforcement>
* Monitor metrics: <https://firebase.google.com/docs/app-check/monitor-metrics>
