---
name: github-comment-rule
description: >-
  GitHub の既存 Pull Request へ AI Agent がコメントを書くときの文案・文体ルール用 SKILL。
  PR 本文の追記・更新、`gh pr comment`、`gh pr review`、インライン review comment、
  既存スレッドへの返信、Review への general comment を起草・投稿するときに必ず使う。
  「PR にコメントして」「レビューコメントを書いて」「この指摘に返信して」
  「インラインで指摘を残して」では必ず使う。
  git commit メッセージ、Cursor チャット内のユーザーへの返答だけ、
  PR 分割方針の検討だけでは使わない（それぞれ git-commit-comment-rule、
  チャット応答、split-pull-request-rule を使う）。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# GitHub Comment Rule

AI Agent が **既存 Pull Request** 上にコメントを書くとき、日本語で丁寧かつ端的に書き、末尾に Agent 署名を付ける。

## いつ使うか

* 既存 PR へ `gh pr comment` でコメントを投稿するとき
* `gh pr review` で Review コメント（approve / request changes / comment）を書くとき
* 特定行へのインライン review comment（`gh api` 等）を起草するとき
* 既存の review スレッド・discussion への返信を書くとき
* 既存 PR の body へ追記・一部更新する文案を Agent が書くとき

## いつ使わないか

* `git commit` のコミットメッセージ（`git-commit-comment-rule` を使う）
* Cursor チャット内でユーザーへ返答するだけ（GitHub に投稿しないテキスト）
* PR 分割方針の検討だけ（`split-pull-request-rule` を使う）
* 新規 PR 作成の初回本文をテンプレートに沿って一括起草するとき（`/github.create-pull-request` が主。ただし投稿文案の言語・署名は本 SKILL に合わせてよい）

## 全体ルール

* **言語**: 本文は **日本語** で書く
* **文体**: **丁寧語**（です・ます調）。冗長な敬語の重ねがけは避け、**端的**に要点を伝える
* **Agent 署名**: コメント末尾に署名ブロックを付ける（後述）
* **Markdown**: GitHub Flavored Markdown を前提に書く。インライン code は `` ` `` で囲む

## コメント種別ごとの書き方

### インライン review comment（コード行への指摘）

* 1 論点 1 コメントを基本とする
* 冒頭で指摘の種類が伝わるように書く（例: 懸念、提案、質問）
* 理由と、可能なら具体的な改善方向を 1〜3 文で述べる
* 長い差分引用は避け、必要な行だけ `` ` `` で示す

**例:**

```markdown
ここでは `null` のとき早期 return しているため、後段の `subscribe` が呼ばれない想定で合っていますでしょうか。拒否後も subscribe しているように見えるため、意図を確認させてください。

---
*Cursor Agent*
```

### スレッド返信（既存コメントへの返信）

* 相手の指摘を 1 文で要約してから答える
* 対応済み / 対応予定 / 意図的に見送る、のいずれかが伝わるように書く
* 返信先の @mention は GitHub UI が付ける場合がある。Agent が本文に @ を足す必要は通常ない

**例:**

```markdown
ご指摘ありがとうございます。Permission 拒否時は `subscribe` を呼ばないよう修正済みです。Unit Test も追加しています。

---
*Cursor Agent*
```

### PR discussion コメント（一般コメント）

* 目的（確認依頼、共有、ブロッカー報告など）を最初の 1 文で示す
* 箇条書きは 3 項目以内を目安にし、レビュアーの読み負荷を下げる
* CI 結果・再現手順・スクショ言及など、事実と依頼内容を分けて書く

**例:**

```markdown
CI の `analyze` が失敗しています。`UserRepository` の import 漏れが原因のため、次のコミットで修正します。

- 失敗ジョブ: `dart analyze`
- 対応: 未使用 import 削除とスタブ追加

---
*Cursor Agent*
```

### PR body の追記・部分更新

* `/github.create-pull-request` のテンプレート構造（Summary / Features 等）がある場合は **構造を壊さない**
* 追記する段落だけ本 SKILL の文体・署名に従う
* body 全体の末尾に署名を 1 回だけ付ける（セクションごとに署名しない）

## Agent 署名

GitHub コメントの末尾に、空行 1 行のあと次のブロックを付ける。

```markdown
---
*Cursor Agent*
```

* 水平線（`---`）で本文と署名を視覚的に分ける
* `Co-authored-by:` は **コミットメッセージ専用**（`git-commit-comment-rule`）であり、PR コメントには使わない
* ユーザーが手書きした文案をそのまま投稿する場合は署名を付けない
* 1 投稿あたり署名は **1 回**（スレッド返信ごとに付ける）

## 丁寧さと端さのバランス

| 避ける | 推奨 |
| --- | --- |
| 「恐れ入りますが、もしよろしければ、お時間のある際に…」のような長い前置き | 「確認させてください。」「対応しました。」 |
| 英語だけの指摘 | 日本語で理由まで述べる |
| 絵文字・スラング・過度な感嘆 | フラットで礼儀正しい文体 |
| 問題の説明なしの「直してください」 | 何が問題で、どう直すとよいかを短く述べる |

## 投稿時の手順

1. コメント種別（インライン / 返信 / 一般 / body 追記）を判断する
2. 本 SKILL に従い文案を起草する
3. `gh pr comment`、`gh pr review`、`gh api` 等で投稿する
4. 投稿後、署名が含まれていることを確認する

**`gh pr comment` の例:**

```bash
gh pr comment 123 --body "$(cat <<'EOF'
CI の analyze 失敗は import 漏れが原因です。次のコミットで修正します。

---
*Cursor Agent*
EOF
)"
```

## 関連 SKILL / Command

| 論点 | 参照先 |
| --- | --- |
| コミットメッセージ | `git-commit-comment-rule` |
| PR 新規作成・body テンプレート | `/github.create-pull-request` |
| PR 分割方針 | `split-pull-request-rule` |

## ナレッジベース

### DO: 1 コメント 1 論点

* 複数の無関係な指摘はコメントを分ける

### DO: 事実と意見を分ける

* 「〜のように見えます」は観察、「〜すべきです」は提案、と読み手が区別できるように書く

### DO NOT: チャット用の長文をそのまま PR に貼る

* GitHub コメントはレビュアーがスキャンしやすい長さに抑える

### DO NOT: 署名の重複

* 本文中と末尾の両方に Agent 名を繰り返さない。末尾ブロックに集約する
