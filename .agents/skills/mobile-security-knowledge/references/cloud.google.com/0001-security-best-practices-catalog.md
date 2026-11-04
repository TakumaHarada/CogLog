---
source: https://docs.cloud.google.com/docs/security/security-best-practices-catalog
scopes:
  - test
  - backend
  - gcp
  - infrastructure
  - compliance
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Google Cloud Security best practices catalog

## 概要

本ドキュメントは [Google Cloud security best practices catalog](https://docs.cloud.google.com/docs/security/security-best-practices-catalog) を蒸留したものである。NIST 800-53 / CRI に整合した制御カタログの読み方と、実装優先度（Required / Recommended / Optional）の扱いを固定する。

* 正本: <https://docs.cloud.google.com/docs/security/security-best-practices-catalog>
* 関連: [`0002-secure-enterprise-foundations.md`](./0002-secure-enterprise-foundations.md)

## 制御スタックを層ごとに割り当てる

Catalog は Secure enterprise foundation → インフラ → データ → ツール／推論 → Agents／Apps の層で制御を積む。まず foundation を満たし、その上にワークロード固有制御を載せる。

### 制御スタックを層ごとに割り当てるの補足

* 利点: AI／アプリ層だけを強化して基盤が空になるのを防げる
* 注意点: 層名に AI が含まれるが、非 AI ワークロードでも foundation は必須である
* 適用範囲: 組織・プロジェクト設計、Terraform、監査計画
* 例外: なし

### 制御スタックを層ごとに割り当てるの実装例

```text
優先順（モバイル + Firebase / GCP 向けの例）
1. Secure enterprise foundation（IAM / 組織 / NW / 鍵・秘密 / ログ）
2. 実行基盤（Cloud Run / コンテナ）
3. データ（Firestore / Storage 等は Firebase Rules と併せて）
4. アプリ層（Auth / App Check）… firebase.google.com 側
```

## Required / Recommended / Optional を区別して追跡する

実装レベルを混同せず、Required を未達のまま本番公開しない。

### Required / Recommended / Optional を区別して追跡するの補足

* 利点: リスク許容と必須作業を文書化できる
* 注意点: Recommended を「任意」と誤読しない（ユースケース依存の高推奨）
* 適用範囲: セキュリティバックログ、リリースゲート
* 例外: Optional のみ、脅威モデルで根拠を残して延期可

### Required / Recommended / Optional を区別して追跡するの実装例

```text
追跡例
* Required: 未達ならブロック
* Recommended: 該当ユースケースなら必須扱い
* Optional: リスク許容を明記して採否
```

## ナレッジベース

### DO: Catalog の foundation 制御をランディングゾーン／Terraform の受け入れ条件にする

```text
# 推奨
gate: foundation Required 完了
evidence: Terraform plan + IAM 差分 + ログ有効化
```

### DO NOT: Catalog を「参考リンク集」として読み飛ばし、個別プロダクト設定だけ進める

* 理由: 公式が監査可能な制御として構造化している
* 理由: 共有運命モデルは運用・デプロイ側の顧客責務を含む

```text
# DO NOT: Cloud Run だけデプロイして IAM / ログ / 秘密を後回し

# DO: foundation → ワークロードの順で制御を埋める
```

## 参考リンク

* Catalog: <https://docs.cloud.google.com/docs/security/security-best-practices-catalog>
* Best Practices Center: <https://cloud.google.com/security/best-practices>
* Secure enterprise foundations: <https://docs.cloud.google.com/docs/security/security-best-practices-catalog/secure-enterprise-foundations>
