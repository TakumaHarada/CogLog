---
source: https://firebase.google.com/docs/rules
scopes:
  - test
  - backend
  - firebase
  - firestore
  - storage
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Firebase Security Rules

## 概要

本ドキュメントは [Firebase Security Rules](https://firebase.google.com/docs/rules)、[Get started](https://firebase.google.com/docs/rules/basics)、[Rules and Auth](https://firebase.google.com/docs/rules/rules-and-auth) を蒸留したものである。デフォルト拒否、Auth 連携、スキーマ同時更新、Emulator／CI テストを監査観点へ落とす。

* 正本: <https://firebase.google.com/docs/rules>
* 関連: [`0001-security-checklist.md`](./0001-security-checklist.md)

## デフォルト拒否で始め、パス追加と同時にルールを書く

Cloud Firestore は production mode、Realtime Database は locked mode、Storage は明示的 deny から始める。ドキュメント型やパスを増やすときは、まずルールを書いてからクライアントを足す。

### デフォルト拒否で始め、パス追加と同時にルールを書くの補足

* 利点: 公開前の「全部開く」事故を防げる
* 注意点: ルールはサーバ側の最終認可であり App Check の代替ではない
* 適用範囲: Firestore / RTDB / Storage
* 例外: なし

### デフォルト拒否で始め、パス追加と同時にルールを書くの実装例

```text
方針
* allow read, write: if false を起点
* オーナー一致: request.auth.uid == resource / userId
* カスタムクレームでロール制御（auth.token.*）
* 匿名だけの書込を機微パスで禁止
```

```javascript
// 公式例の要約（管理者クレーム）
allow write: if request.auth.token.admin == true;
```

## Emulator でユニットテストし CI に載せる

ルール変更は Local Emulator Suite でテストし、アプリ変更と同時に CI で回帰させる。

### Emulator でユニットテストし CI に載せるの補足

* 利点: 本番データに当てる前に認可回帰を検知できる
* 注意点: 開発／本番でルール方針は揃え、パイプライン差は意図的差分だけにする
* 適用範囲: Rules 変更、データモデル変更
* 例外: なし

### Emulator でユニットテストし CI に載せるの実装例

```text
チェック
* Firestore / RTDB Rules テストを CI 必須に
* 「テスト無しの Rules 緩和」を PR で拒否
```

## ナレッジベース

### DO: Security Rules をデータモデルのスキーマとして扱う

```text
# 推奨
default: deny
auth: uid / claims based
ci: emulator rules tests
```

### DO NOT: ローンチ直前にまとめて Rules を書き、一時的に allow all で開発する

* 理由: Checklist / Rules ガイドが明示禁止に近い最悪パターンである
* 理由: キャッシュされたクライアントや並行ブランチで本番に混入しやすい

```text
# DO NOT: allow read, write: if request.auth != null; を全パスに広げる

# DO: パス単位の最小許可 + テスト
```

## 参考リンク

* Security Rules: <https://firebase.google.com/docs/rules>
* Rules basics: <https://firebase.google.com/docs/rules/basics>
* Rules and Auth: <https://firebase.google.com/docs/rules/rules-and-auth>
* Firestore get started: <https://firebase.google.com/docs/firestore/security/get-started>
