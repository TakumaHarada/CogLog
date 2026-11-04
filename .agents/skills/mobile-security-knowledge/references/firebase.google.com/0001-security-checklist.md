---
source: https://firebase.google.com/support/guides/security-checklist
scopes:
  - test
  - backend
  - firebase
  - gcp
  - mobile
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Firebase security checklist

## 概要

本ドキュメントは [Firebase security checklist](https://firebase.google.com/support/guides/security-checklist) を蒸留したものである。乱用対策、API キーの扱い、Rules、Auth、Cloud Functions、環境分離の必須観点をまとめる。

* 正本: <https://firebase.google.com/support/guides/security-checklist>
* 関連: [`0002-app-check.md`](./0002-app-check.md)、[`0003-security-rules.md`](./0003-security-rules.md)

## 乱用トラフィックを監視し App Check で抑止する

Firestore / RTDB / Storage / Hosting の監視とアラートを置き、対応プロダクトで App Check を有効化する。Functions は通常トラフィックに合わせた同時実行上限と予算アラートを設定する。

### 乱用トラフィックを監視し App Check で抑止するの補足

* 利点: DoS と不正クライアントによる課金・データ搾取を抑えられる
* 注意点: App Check は全乱用を消さないが重要な一歩である
* 適用範囲: バックエンド課金面、公開 API
* 例外: なし

### 乱用トラフィックを監視し App Check で抑止するの実装例

```text
チェック
* 監視・アラートを設定
* App Check を対応サービスで有効化・強制
* Functions 同時実行数を制限
* 予算アラート
* 無限トリガは Emulator で検証
```

## API キーと本当の秘密を区別する

Firebase クライアント向け API キーはプロジェクト／アプリ識別子であり、認可は IAM・Rules・App Check が担う。一方 FCM server key（レガシー）とサービスアカウント秘密鍵は秘匿する。

### API キーと本当の秘密を区別するの補足

* 利点: 誤った「キー隠蔽だけ」の対策を避けられる
* 注意点: Firebase 以外の Google API には別キー＋制限を使う
* 適用範囲: モバイル設定、Admin SDK、CI
* 例外: なし

### API キーと本当の秘密を区別するの実装例

```text
公開してよい（制限付き）: Firebase プロビジョニング API キー
秘匿: SA private key、FCM server key
制限: アプリ／API スコープの API key restrictions
```

## Rules・Auth・環境・依存関係を開発と同時に守る

Rules は本番／locked 初期化しスキーマ同様に追加する。OAuth を優先し、匿名はオンボーディング限定。開発／ステージング／本番を別プロジェクトにし、ライブラリ供給連鎖にも注意する。

### Rules・Auth・環境・依存関係を開発と同時に守るの補足

* 利点: ローンチ直前の一括 Rules 書きを防げる
* 注意点: Cloud Functions に秘密を環境変数で常駐させない（Secret Manager）
* 適用範囲: Firestore / Storage / Auth / Functions
* 例外: なし

### Rules・Auth・環境・依存関係を開発と同時に守るの実装例

```text
* Rules: deny default → パス追加時にルール追加 → Emulator + CI
* Auth: OAuth 優先、email/password はクォータと列挙保護
* Anonymous: 非公開データは sign_in_provider / email_verified で制限
* Projects: dev / staging / prod 分離
* Functions: 複雑なら Cloud Run 検討、秘密は Secret Manager
```

## ナレッジベース

### DO: Checklist の監視・App Check・Rules・秘密区分をリリース必須にする

```text
# 推奨
monitoring: on
app_check: enforced
rules: tested in CI
secrets: SA/FCM only in Secret Manager
```

### DO NOT: allow all Rules や SA 鍵のリポジトリ混入を「後で直す」まま本番公開する

* 理由: Checklist が明示する最悪系である
* 理由: API キー秘匿では代替できない

```text
# DO NOT: match /{document=**} { allow read, write: if true; }

# DO: production/locked 初期化 + App Check + 最小 IAM
```

## 参考リンク

* Security checklist: <https://firebase.google.com/support/guides/security-checklist>
* App Check: <https://firebase.google.com/docs/app-check>
* Security Rules: <https://firebase.google.com/docs/rules>
