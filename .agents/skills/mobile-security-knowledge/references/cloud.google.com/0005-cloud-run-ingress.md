---
source: https://cloud.google.com/run/docs/securing/ingress
scopes:
  - test
  - backend
  - gcp
  - cloud-run
  - networking
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Cloud Run ingress の制限

## 概要

本ドキュメントは [Restrict network endpoint ingress for Cloud Run services](https://cloud.google.com/run/docs/securing/ingress) を蒸留し、Firebase Hosting rewrite と組み合わせる際の注意をまとめたものである。

* 正本: <https://cloud.google.com/run/docs/securing/ingress>
* 関連: 導入先バックエンドの API セキュリティ文書（存在すれば）

## ingress 設定の意味を取り違えない

`internal` は「同一プロジェクト／VPC-SC 内の特定 Google プロダクトからの呼び出し」等に限定する設定であり、インターネットからの直接到達を拒否する。`all` は最も緩い。

### ingress 設定の意味を取り違えないの補足

* 利点: ネットワーク到達面を意図どおりに絞れる
* 注意点: Firebase Hosting rewrite は `internal` の許可呼び出し元として想定されていない
* 適用範囲: Cloud Run サービス設定、Hosting 連携
* 例外: Hosting を使わない Internal LB 専用構成は別設計

### ingress 設定の意味を取り違えないの実装例

```text
選択肢（要約）
* all … インターネット含む（最も緩い）
* internal-and-cloud-load-balancing … 外部 ALB 等の特定経路
* internal … 列挙された内部呼び出し元のみ

典型構成（Hosting rewrite 利用時）
* Hosting rewrite を使う通常構成では internal のみにしない
* 到達制御の主はアプリ層（Firebase Auth + App Check）と必要なら Cloud Run IAM
```

## ネットワーク制限とアプリ層検証を多層で組み合わせる

ingress だけで完結させず、認証・App Check・API キー方針を併用する。`run.app` 直接公開を減らす場合はカスタムドメイン／LB 設計を別途検証する。

### ネットワーク制限とアプリ層検証を多層で組み合わせるの補足

* 利点: 単一層の設定ミスでも全面漏洩しにくくなる
* 注意点: 設定変更は Staging で Hosting → Cloud Run 経路を実機確認する
* 適用範囲: 本番 API、管理系エンドポイント
* 例外: App Check 非適用と文書化した限定経路がある場合のみ、その仕様に従う

### ネットワーク制限とアプリ層検証を多層で組み合わせるの実装例

```text
推奨スタック
1. TLS（本番は Hosting 終端）
2. 必要に応じた IAM / ingress
3. Firebase ID Token + App Check（サーバ検証）
4. ログにトークン生値を出さない
```

## ナレッジベース

### DO: Hosting 連携有無を明示したうえで ingress を選ぶ

```text
# 推奨
hosting_rewrite: yes → internal 単独は採用しない
app_layer: Auth + App Check 必須
verify: staging E2E on rewrite path
```

### DO NOT: 「internal にすれば安全」だけで Hosting rewrite を維持する

* 理由: 公式の internal 許可元に Hosting が含まれない前提で失敗する
* 理由: Hosting rewrite と ingress=internal の組み合わせは公式の想定外になりやすい

```text
# DO NOT: ingress=internal + Firebase Hosting rewrite を未検証で本番化

# DO: 経路設計を文書化し、アプリ層検証を必須にする
```

## 参考リンク

* Cloud Run ingress: <https://cloud.google.com/run/docs/securing/ingress>
* API セキュリティ（導入先）: バックエンドの API セキュリティ文書（存在すれば）
* Firebase App Check: [`../firebase.google.com/0002-app-check.md`](../firebase.google.com/0002-app-check.md)
