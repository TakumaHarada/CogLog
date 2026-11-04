---
name: workspace-resolve-file-path
description: >-
  ドキュメントの通常パス表記を実ファイルへ解決する SKILL。
  クォート `path/to/file`（リポジトリルート相対）、Markdown リンク `[text](rel)`
  （リンク元相対）を扱う。
  「この MD のリンク先はどこ？」「path/to/file の実体」
  「相対パスを解決してから読んで」では必ず使う。
  `{assets}/...` は絶対にこの SKILL では解かず workspace-resolve-agent-assets を使う。
  `@{name}/...` / `repo:{name}/...` は workspace-resolve-root-directory。
  `.ai-agent/` の置き場・実パスは workspace-layout / workspace-agent-temporary。
  GitHub Issue URL のメタデータ取得や、整形のみは markdown.format では使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Workspace / Resolve File Path

ドキュメントに書かれたパスを、**実際に開くべき絶対パス（またはリポジトリルート相対の確定パス）**へ変換する。
解決を誤ると参照先を読み違え、出力品質が落ちるため、パス付きの参照を扱う前にこの SKILL を適用する。

## いつ使うか

* Markdown / 文書内の `path/to/file` や `[label](path)` の実体を探すとき
* 「ドキュメントの参照先を開いて」と言われ、表記が相対・リンク混在のとき

## いつ使わないか

* `{assets}/...` メタ変数の実体解決 → `workspace-resolve-agent-assets`
* `@{name}/...` / `repo:{name}/...`（ルート解決）→ `workspace-resolve-root-directory`
* `.ai-agent/` の導入・実パス・`tmp`/`plan`/`memory` の置き場 → `workspace-layout` / `workspace-agent-temporary`
* GitHub Issue URL から ID/タイトルを取る（本 SKILL の範囲外）
* Markdown の体裁整形だけ → `markdown.format`
* キーワードで文書を探すだけ（パス表記の解決が不要）→ `markdown-search`

## 作業手順

1. 表記がどれかを判別する（クォート相対 / Markdown リンク）。`{assets}/` なら `workspace-resolve-agent-assets`、`@` / `repo:` なら `workspace-resolve-root-directory`、`.ai-agent/` の置き場なら `workspace-layout` / `workspace-agent-temporary`
2. 対応ルールで候補パスを組み立てる
3. 存在確認してから読む・書く（無ければ候補と解決ルールを報告する）

## `path/to/file` 形式

クォートされた `path/to/file` は、**Git リポジトリルートからの相対パス**で解決する。

```bash
# リポジトリルートからの相対パス
cat "$(git rev-parse --show-toplevel)/path/to/file"
```

## `[リンク](path/to/file)` 形式

Markdown リンクのパスは、**そのリンクが書かれているファイルからの相対パス**で解決する（リポジトリルート基準ではない）。

```bash
# example/markdown/file.md に [example](../doc.txt) とある場合
SOURCE_MD="$(git rev-parse --show-toplevel)/example/markdown/file.md"
RELATIVE_PATH="../doc.txt"
cat "$(dirname "$SOURCE_MD")/$RELATIVE_PATH"
```

## ナレッジベース

### DO: 表記の種類を先に分けてから解決する

* ルート相対とリンク元相対を混ぜると、別ファイルを開いてしまう
* `{assets}/`・`@` / `repo:`・`.ai-agent/` 置き場は本 SKILL で無理に解かず、対応 SKILL へ渡す

### DO NOT: Markdown リンクをリポジトリルート相対だと決めつける

* `[text](../x.md)` はリンク元ディレクトリ基準

### DO NOT: パスを解決せずに「たぶんこのファイル」で読み進める

* 解決失敗時は候補とルールを示し、推測読みを避ける
