---
source: https://cloud.google.com/security/best-practices
scopes:
  - test
  - backend
  - gcp
  - firebase
  - infrastructure
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Google Cloud セキュリティ（索引）

## 概要

Google Cloud 公式のセキュリティベストプラクティスを、DO / DO NOT 監査向けに蒸留した索引である。GCP（Cloud Run 等）と Firebase を同一プロジェクトで運用する場合は、[firebase.google.com](../firebase.google.com/0000-index.md) と併読する。

* 入口: [Security Best Practices Center](https://cloud.google.com/security/best-practices)
* 制御カタログ: [Security best practices catalog](https://docs.cloud.google.com/docs/security/security-best-practices-catalog)

## 読み順

基盤（IAM・組織・秘密・ネットワーク）→ 実行環境（Cloud Run）→ Firebase 層の順で辿る。

### 読み順の補足

* 利点: アプリ層だけの対策で基盤の穴を見落とさない
* 注意点: Catalog の Required / Recommended / Optional を混同しない
* 適用範囲: Terraform、IAM、Secret Manager、Cloud Run、監査
* 例外: なし

### 読み順の実装例

```text
1. 0001 Catalog（全体地図）
2. 0002 Foundations / 0003 IAM / 0004 Secret Manager
3. 0005 Cloud Run ingress
4. firebase.google.com（App Check / Rules / Checklist）
```

## ナレッジベース

### DO: PR に GCP 制御 ID または本ツリーの 000x を併記する

```text
# 推奨
refs:
  - docs/security/cloud.google.com/000x-...
  - docs.cloud.google.com/...
```

### DO NOT: Firebase 対策だけで GCP IAM・秘密・ingress を省略する

* 理由: 共有責任／共有運命モデルでは顧客側の基盤設定が必須である
* 理由: API キーや Hosting 経路はアプリ層検証とセットである

```text
# DO NOT: App Check があるので Editor ロールを全員に付与

# DO: 最小権限 IAM + 秘密は Secret Manager + アプリ層検証
```

## 一覧

| No | Source | Title | Path |
| --- | --- | --- | --- |
| 0001 | [catalog](https://docs.cloud.google.com/docs/security/security-best-practices-catalog) | Security best practices catalog | [`0001-security-best-practices-catalog.md`](./0001-security-best-practices-catalog.md) |
| 0002 | [foundations](https://docs.cloud.google.com/docs/security/security-best-practices-catalog/secure-enterprise-foundations) | Secure enterprise foundation | [`0002-secure-enterprise-foundations.md`](./0002-secure-enterprise-foundations.md) |
| 0003 | [IAM securely](https://cloud.google.com/iam/docs/using-iam-securely) | IAM を安全に使う | [`0003-iam.md`](./0003-iam.md) |
| 0004 | [Secret Manager](https://cloud.google.com/secret-manager/docs/best-practices) | Secret Manager ベストプラクティス | [`0004-secret-manager-best-practices.md`](./0004-secret-manager-best-practices.md) |
| 0005 | [Cloud Run ingress](https://cloud.google.com/run/docs/securing/ingress) | Cloud Run ingress | [`0005-cloud-run-ingress.md`](./0005-cloud-run-ingress.md) |

## 参考リンク

* Best Practices Center: <https://cloud.google.com/security/best-practices>
* Firebase 索引: [`../firebase.google.com/0000-index.md`](../firebase.google.com/0000-index.md)
* API セキュリティ: 導入先バックエンドの API セキュリティ文書（存在すれば併読）
