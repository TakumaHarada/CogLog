---
source: https://docs.cloud.google.com/docs/security/security-best-practices-catalog/secure-enterprise-foundations
scopes:
  - test
  - backend
  - gcp
  - infrastructure
  - iam
  - networking
  - logging
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Google Cloud Secure enterprise foundation

## 概要

本ドキュメントは [Secure enterprise foundation controls](https://docs.cloud.google.com/docs/security/security-best-practices-catalog/secure-enterprise-foundations) を蒸留したものである。認証・認可、組織、ネットワーキング、ログ監視、鍵・秘密、セキュリティ姿勢の基盤制御を、実装レビュー観点へ落とす。

* 正本: <https://docs.cloud.google.com/docs/security/security-best-practices-catalog/secure-enterprise-foundations>
* 関連: [`0003-iam.md`](./0003-iam.md)、[`0004-secret-manager-best-practices.md`](./0004-secret-manager-best-practices.md)

## 認証・認可と組織境界を先に固定する

Cloud Identity / IAM と Resource Manager・Organization Policy で、誰が何に触れるかをプロジェクト境界で切る。開発と本番は別プロジェクトを基本とする。

### 認証・認可と組織境界を先に固定するの補足

* 利点: 事故時の影響範囲とクォータを分離できる
* 注意点: Firebase も同一 GCP プロジェクト IAM に乗る
* 適用範囲: ユーザー・サービスアカウント・グループ、Org Policy
* 例外: なし（開発／本番の 2 系統を基本とする）

### 認証・認可と組織境界を先に固定するの実装例

```text
チェック
* Owner / Editor の広い付与を避ける
* 本番データへの人間アクセスを限定
* サービスアカウントはワークロード単位の最小ロール
* Org Policy で許可ドメイン・ロケーション等を制約
```

## ログ・監視・鍵と秘密を基盤として常時有効にする

監査ログ、監視アラート、Cloud KMS / Secret Manager を後付けにしない。保存データは既定の暗号化を前提にし、鍵アルゴリズムは承認済み集合に限定する。

### ログ・監視・鍵と秘密を基盤として常時有効にするの補足

* 利点: 検知と事後追跡、秘密漏洩時の影響制限ができる
* 注意点: データアクセスログは組織／フォルダで強制すると漏れにくい
* 適用範囲: Cloud Audit Logs、Billing / 予算アラート、KMS、Secret Manager
* 例外: なし

### ログ・監視・鍵と秘密を基盤として常時有効にするの実装例

```text
チェック
* Admin Activity 監査ログを確認
* 機微 API（Secret 取得等）は Data Access ログを有効化
* 予算アラートを設定
* 秘密は Secret Manager、鍵は KMS（NIST 承認アルゴリズム）
* 平文のサービスアカウント鍵 JSON をリポジトリに置かない
```

## ナレッジベース

### DO: foundation の IAM・ログ・秘密を Terraform / 手順書の必須項目にする

```text
# 推奨
iam: least privilege
logging: audit (+ data access for secrets)
secrets: Secret Manager / KMS
projects: dev != prod
```

### DO NOT: 本番プロジェクトに広い Editor とローカル鍵ファイル運用を残す

* 理由: foundation の中核が破れる
* 理由: Firebase Console 権限も同一 IAM に波及する

```text
# DO NOT: 個人に roles/editor + SA 鍵を配布

# DO: グループ + 事前定義ロール最小 + Workload Identity / ADC
```

## 参考リンク

* Secure enterprise foundations: <https://docs.cloud.google.com/docs/security/security-best-practices-catalog/secure-enterprise-foundations>
* Catalog: <https://docs.cloud.google.com/docs/security/security-best-practices-catalog>
* 環境解決: 導入先の GCP / Firebase 環境ドキュメントや SKILL があれば併読する
