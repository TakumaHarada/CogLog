---
name: workspace-git-branch-rule
description: >-
  リポジトリの Git ブランチ命名・役割ルール用 SKILL。`main`・
  `feature/id/{Issue番号}/{名称}`・`release/{バージョン}/main` の意味を解釈し、
  新規ブランチ名の提案や、feature ブランチから Issue 内容の推測（`gh`）に使う。
  「ブランチ名どうする」「この feature ブランチは何の作業？」「release ブランチの付け方」
  「Issue 番号付きブランチ」では必ず使う。コミットメッセージ規約だけ、PR 本文作成だけ、
  push/force 操作の可否判断だけ、コード実装そのものでは使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Workspace / Git Branch Rule

ブランチ名から役割を読み取り、新規ブランチをこの慣習に合わせて付ける。
名前から作業内容を追うときは、feature の Issue 番号を手がかりに `gh` で Issue を取る。

## いつ使うか

* 作業用／リリース用ブランチの名前を決める・検証するとき
* 既存ブランチ名から「何の作業か」を推測するとき（特に `feature/id/...`）
* `main` / feature / release の役割の違いを揃えるとき

## いつ使わないか

* コミットメッセージの書き方だけ
* PR のタイトル／本文の起草だけ（ブランチ名解釈が必要な場合は併用可）
* 実装・レビュー・テストそのもの
* 破壊的 git 操作（force push 等）の許可判断そのもの

## ブランチ種別

### `main`

* 開発中の最新コードを置く幹線
* 各リポジトリは、常に `main` の最新を作業の起点とする

### `feature/id/{Issue番号}/{任意の名称}`

* 作業用ブランチ。リポジトリの Issue に紐づける
* `{Issue番号}` があるため、`gh` でタスク内容を取得できる

```bash
# 例: feature/id/123/add-login なら
gh issue view 123
```

* `{任意の名称}` は短く内容が分かる英数字・ハイフン程度にする（例: `add-login`, `fix-crash-on-launch`）

### `release/{リリースバージョン}/main`

* リリース用ブランチ
* バージョン名はプロダクトの慣習に合わせる
  * アプリなど semver が明示される場合: `release/v1.0.0/main`
  * 日付ベース等の場合: `release/v2025-12-31/main`

## 作業手順（名前から内容を読む）

1. ブランチ名を上記パターンに当てはめる
2. `feature/id/{n}/...` なら Issue `n` を `gh issue view`（必要ならリポジトリ指定）で確認する
3. `release/...` なら対象バージョン／日付を読み、リリース作業文脈と捉える
4. どれにも当てはまらない名前は、慣習外としてユーザーに確認する

## 作業手順（新規ブランチを付ける）

1. 幹線は `main` から切る（特に指示がなければ）
2. Issue がある作業は `feature/id/{Issue番号}/{短い名称}`
3. リリースラインは `release/{バージョン}/main`
4. Issue 無しの一時作業でも、可能な限り Issue を立ててから feature 名に載せる

## ナレッジベース

### DO: ブランチ名で種別と Issue を一意に読めるようにする

* 後から `gh` や履歴で辿れることが目的である

### DO: feature なら先に Issue 番号を確定してから命名する

* 番号無しの `feature/foo` は本ルール外になりやすい

### DO NOT: `main` に直接大きな作業を積み続ける前提で進める

* 作業は feature（または release）に切り出す

### DO NOT: release 名に曖昧なラベルだけを使う

* `release/new/main` より、バージョンまたは日付が入った形を優先する
