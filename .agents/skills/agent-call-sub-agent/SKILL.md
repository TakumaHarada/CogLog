---
name: agent-call-sub-agent
description: >-
  Sub Agent（Task tool）呼び出し時に、委任内容に必要な SKILL を選定し、
  子 Agent の prompt へ「SKILLサジェスト」ブロックとして明示追加する SKILL。
  Task / subagent / 子 Agent / 委任 / 委譲を行う直前、および
  「Sub Agent に SKILL を渡す」「関連 SKILL を載せて起動」では必ず使う。
  親だけの作業・Sub Agent を起動しない調査・単なる会話では使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Agent / Call Sub Agent

Sub Agent はクリーンコンテキストで起動し、親の Skills カタログを自動継承しない。
必要な手順書を渡さないと、子は関連規約を知らないまま作業する。
本 SKILL は親が起動直前に関連 SKILL を選定し、パスと description だけを prompt に載せる。
子は記載された description を見て、必要に応じて Apply（本文ロード）する。

## いつ使うか

* Task tool で Sub Agent を起動する直前
* カスタム Agent（`.cursor/agents/*.md`）へ委任する直前

## 手順

### 1. 選定ソースを集める

次の2系統を必ず見る。

1. **親の利用可能 SKILL**（`available_skills` 等に提示されている一覧）
2. **起動先 Sub Agent 定義の必須 SKILL**
   * 第一ソース: 本文 `## 追加コンテキスト` の `Required:` 行（SKILL の `name`）
   * 後方互換: `metadata.required_skills`、本文の「必須ロード」「関連SKILL」等（現行テンプレ以前の定義向け）
   * これらに記載があるものは **必須**（description 照合の結果によらず必ず含める）
   * `Optional:` は必須ではない。委任内容に応じて親が追加選定してよい

本 SKILL（`agent-call-sub-agent`）自身は子へ渡さない。親専用である。

### 2. 親の判断で追加選定する

必須分以外は、各 SKILL の `description` と **今回の委任内容（prompt / 作業範囲）** を照合し、
子が作業を完遂するために参照すべきものを親が選ぶ。

* 関連が薄いものは載せない（ノイズを避ける）
* 件数の上限はない。必要なら複数すべて載せる
* 迷ったら「子が読んで損しないか」より「読まないと規約違反・手順欠落になりそうか」で決める

### 3. Path を絶対パスにする

* `Path` は **SKILL ディレクトリ** の絶対パスとする（`SKILL.md` ファイルパスではない）
* Sub Agent 定義の相対リンク（例: `../skills/foo/SKILL.md`）は、定義ファイル位置から解決してディレクトリ絶対パスにする

### 4. prompt 末尾へブロックを追加する

選定結果が **1件以上** あるときだけ、Sub Agent への prompt 末尾に次を付ける。
**0件ならブロック全体を省略する**（「該当なし」等も書かない）。

```markdown
---
# 追加コンテキスト

## SKILLサジェスト

* 記載されたDescriptionから、必要に応じてApplyすること

### {SKILL名}

* Path: {SKILLディレクトリの絶対パス}

{そのSKILLのdescription}
```

複数ある場合は `### {SKILL名}` セクションを並べる。

#### 記入例

```markdown
---
# 追加コンテキスト

## SKILLサジェスト

* 記載されたDescriptionから、必要に応じてApplyすること

### example-domain-rules

* Path: /path/to/repo/.agents/skills/example-domain-rules

ドメイン固有の規約を定義する SKILL。
「この領域のルールに従って」…（description全文）

### example-workflow-design

* Path: /path/to/repo/.agents/skills/example-workflow-design

（description全文）
```

### 5. 子側の期待動作（親は本文を埋め込まない）

* 親は **Path と description のみ** を渡す。SKILL 本文の要約・全文埋め込みはしない
* 子は `## SKILLサジェスト` の指示どおり、description を見て必要なら Path 先の `SKILL.md` を Apply する

## ガードレール

* Sub Agent を起動しないターンでは、本 SKILL のブロックを作らない
* 必須（Sub Agent 定義記載）を description 照合で落とさない
* description を勝手に言い換えない（frontmatter / 提示文言をそのまま載せる）
* Path を相対のまま残さない
