---
source: https://cloud.google.com/secret-manager/docs/best-practices
scopes:
  - test
  - backend
  - gcp
  - secrets
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Secret Manager ベストプラクティス

## 概要

本ドキュメントは [Secret Manager best practices](https://cloud.google.com/secret-manager/docs/best-practices) を蒸留したものである。秘密の保管場所、アクセス制御、バージョン運用、ローテーションを実装レビューへ落とす。

* 正本: <https://cloud.google.com/secret-manager/docs/best-practices>
* 関連: [`0003-iam.md`](./0003-iam.md)、Firebase checklist の SA 鍵扱い

## 秘密は Secret Manager に置き、環境変数やファイルを既定にしない

アプリは API／クライアントライブラリで必要なときだけ取得する。ファイルシステムや環境変数への常駐はディレクトリトラバーサルやデバッグ露出で漏洩しやすい。

### 秘密は Secret Manager に置き、環境変数やファイルを既定にしないの補足

* 利点: 監査（AccessSecretVersion）と IAM を秘密単位で効かせられる
* 注意点: サーバレス連携で env 注入が必要な場合は公式の製品連携手順に限定する
* 適用範囲: API キー（秘匿扱いのもの）、サードパーティ資格情報、署名鍵
* 例外: Firebase クライアント API キーは「秘密ではない」公式方針（別文書）

### 秘密は Secret Manager に置き、環境変数やファイルを既定にしないの実装例

```text
チェック
* リポジトリ / .env に SA 鍵・FCM server key を置かない
* ローカルは ADC、実行環境はメタデータ / WIF
* 他ストアへ同期する場合は ACL・監査・暗号化要件を評価
```

## バージョン固定・無効化先行・ローテーション

`latest` エイリアス依存を避け、リリースプロセスでバージョン番号を上げる。破棄前に disable して依存切れを確認する。定期ローテーションで漏洩影響を限定する。

### バージョン固定・無効化先行・ローテーションの補足

* 利点: 悪い版の即時全面障害を避け、ロールバックできる
* 注意点: 本番秘密に安易な expiration を付けない（一時環境向け）
* 適用範囲: 本番シークレット運用
* 例外: 一時環境の自動掃除のみ expiration を検討

### バージョン固定・無効化先行・ローテーションの実装例

```text
運用
1. 新バージョン追加
2. アプリ設定をバージョン番号へ更新してデプロイ
3. 旧版を disable → 待機 → destroy
4. Data Access ログで AccessSecretVersion を監視
```

## ナレッジベース

### DO: 秘密ごとに最小 IAM とバージョン付き参照を必須にする

```text
# 推奨
iam: secret-level least privilege
ref: projects/.../secrets/NAME/versions/N
logging: AccessSecretVersion
```

### DO NOT: 共有 .env や latest 固定で秘密を運用する

* 理由: 公式が env／FS 経由の漏洩経路を明示している
* 理由: latest は問題版の即時伝播を招く

```text
# DO NOT: SECRET=... を全環境の .env にコミット

# DO: Secret Manager + バージョン固定 + ローテーション
```

## 参考リンク

* Secret Manager best practices: <https://cloud.google.com/secret-manager/docs/best-practices>
* Use IAM securely: <https://cloud.google.com/iam/docs/using-iam-securely>
