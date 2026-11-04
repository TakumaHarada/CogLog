---
name: golang-analyze
description: >-
  Go の品質担保（`go fmt` / `golangci-lint` / `go test`）をコーディング後・途中で回す SKILL。
  `go.work` ルートでの一括実行、`//go:build` 時の `-tags`、lint の非破壊自動修正と
  破壊的変更のユーザー確認、テスト失敗時はエラー提示のみ（勝手に直さない）を適用する。
  「fmt して」「lint 回して」「テスト実行」「コーディング後の品質チェック」
  「golangci-lint」「go test の tags」では必ず使う。 規約どおりに *.go を書くだけは
  golang-coding-rules、アーキテクチャ設計は golang.architecture.* を使う。
  Dart/Flutter の analyze・format や CI ワークフロー YAML 編集には使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Golang / コード品質（fmt・lint・test）

Go 実装のあと（または途中の節目）に、**フォーマット → 静的解析 → ユニットテスト**で品質を確認する。
コマンド例は `go` / `golangci-lint` 本体で示す（`mise` 等のラッパーはリポジトリ規約に任せる）。

## いつ使うか

* AI / 人手のコーディング完了後、または区切りのよい途中経過での品質チェック
* `go fmt` / `golangci-lint` / `go test` の実行方針を揃えるとき
* `go.work` があるリポジトリで workspace 全体／個別 package を回すとき
* ビルドタグ付きテスト（`-tags=...`）の付け方を決めるとき

## いつ使わないか

* `*.go` の書き方・コメント・データオブジェクト規約だけ → `golang-coding-rules`
* ConnectRPC / Repository / Usecase 等の設計そのもの → 該当 `golang.architecture.*`
* CI ワークフロー YAML の書き方（GitHub Actions 等の専用 SKILL がある場合はそちら）
* Dart / Flutter の analyze・format（該当言語向けの品質 SKILL がある場合はそちら）

## 作業手順

1. **作業ディレクトリを決める** — 原則 `go.work` があるリポジトリルート（なければ対象 module ルート）
2. **Formatter** を実行する
3. **Analyzer（golangci-lint）** を実行する。指摘のうち **非破壊**なら自動適用してよい
4. **Unit Test** を実行する。Fail したら **エラー内容のみ提示**し、勝手に修正しない
5. 破壊的になりそうな lint 修正案は、ユーザーに提示するだけにとどめる

## Formatter

コーディング完了後（または区切り）に必ず実行する。結果はべき等で、副作用はない。

```bash
# go.work のディレクトリで実施する
go fmt ./...
```

## Analyzer

コーディング完了後（または区切り）に必ず実行する。結果はべき等で、副作用はない。
提示された問題点のうち、**非破壊的**であれば自動的に実施してよい。

```bash
golangci-lint run ./...
```

### ガードレール条項

* [ ] **ロジックの変更等、破壊的変更が生じる場合はユーザーに作業内容を提示するのみで、作業の実施は行わない**

## Unit Test

コーディング完了後（または区切り）に必ず実行する。結果はべき等であり、基本的に副作用はない。
外部 API 等に依存する場合は、環境・状況依存で失敗しうる。

* Fail した場合、**エラー内容のみをユーザーに提示する**（**修正は行わない**）
* リポジトリが `//go:build` タグを使う場合は、`go test` に **`-tags={tags...}`** を付与する。`{tags...}` はプレースホルダであり、実行時にプロジェクト方針どおりのカンマ区切りタグ（例: `dev,test`）へ置き換える

```bash
# ビルドタグが必要な場合は {tags...} をカンマ区切りに置き換える（例: dev,test）
# workspace 全体（go.work があるリポジトリルート）
go test -tags={tags...} ./...

# 個別: パッケージ（ディレクトリ）単位
go test -tags={tags...} ./path/to/module

# 個別: 特定のテスト関数のみ（-run は正規表現）
go test -tags={tags...} ./path/to/module -run '^TestExample$'
```

ビルドタグが不要なプロジェクトでは `-tags=...` を付けない。

## ナレッジベース

### DO: fmt → lint → test の順で区切りごとに回す

* フォーマットと静的解析を先に通してからテスト結果を読むと、ノイズが減る

### DO: go.work ルートを起点にし、必要なら package / `-run` で絞る

* 全体 `./...` が重い・無関係な失敗が多いときは対象を狭める

### DO: ビルドタグ方針があるなら `-tags` を忘れない

* タグ無しだとテスト／コードがそもそもコンパイル対象外になることがある

### DO NOT: テスト失敗を黙って「直して再実行」まで進める

* Fail の内容をユーザーに見せ、修正方針は指示を待つ（勝手な仕様変更を防ぐ）

### DO NOT: lint の破壊的（ロジック変更）提案を確認なしで適用する

* 非破壊（import 整理・単純なスタイル等）と、挙動が変わりうる修正を分ける
