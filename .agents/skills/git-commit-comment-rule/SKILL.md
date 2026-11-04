---
name: git-commit-comment-rule
description: >-
  Git コミットメッセージの起草・整形ルール用 SKILL。`git commit` の `-m` / HEREDOC 草案、
  複数コミットへのメッセージ付与、`git commit --amend` の文案、`gh` 経由でコミットを伴う操作の
  前後でメッセージを考えるときに必ず使う。「コミットして」「コミットメッセージを書いて」
  「この差分の commit comment」「git commit -m を考えて」では必ず使う。
  `refs #123` の付与は pre-commit hook が行うため Agent は書かない。
  PR 本文・タイトルだけ、ブランチ名だけ、git log の閲覧だけ、push 可否の判断だけでは使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Git Commit Comment Rule

AI Agent が `git commit` や `gh` 経由のコミットを行うとき、リポジトリ慣習に沿った日本語メッセージを書く。

## いつ使うか

* ユーザーがコミットを依頼したとき（メッセージの考案を含む）
* 差分を見てコミットメッセージを提案・確定するとき
* 複数コミットに分割するとき、各コミットの文案を付けるとき
* `git commit --amend` でメッセージを直すとき

## いつ使わないか

* PR のタイトル／本文だけを書くとき（コミットメッセージが不要な場合）
* ブランチ名の決定だけ（`workspace-git-branch-rule` を使う）
* `git log` の閲覧・履歴調査だけ
* ユーザーが「メッセージは自分で書く」と明示したとき

## 全体ルール

* **言語**: 1 行目・箇条書きは **日本語** で書く
* **`refs #` は書かない**: `feature/id/{Issue番号}/...` ブランチでは `.hooks/commit-msg` が 1 行目末尾へ `refs #{Issue番号}` を自動付与する。Agent がメッセージに含めると重複する
* **Agent 署名**: 本文末尾に Git trailer 形式の署名を付ける（後述）

## メッセージ構造

```text
{prefix}: {変更内容を一文で要約}

- {何を変えたか}（{なぜ変えたか}）
- {追加の変更や理由があれば続ける}

Co-authored-by: Cursor Agent
```

* 1 行目と箇条書きの間、箇条書きと署名の間には **空行** を 1 行入れる
* 1 行目は 50 文字前後を目安に簡潔に（厳密上限はないが冗長にしない）
* 箇条書きは `-` で始める。各項目で「何を」「なぜ」の両方が読み取れるようにする

## 1 行目の prefix

先頭は次のいずれか **1 つ** を選び、`{prefix}:` の直後から日本語要約を書く。

| prefix | 使う場面 | 例 |
| --- | --- | --- |
| `add:` | 新規追加（機能・ファイル・公開 API・テストの新設など） | `add: ログイン画面の ViewModel を追加` |
| `chg:` | 既存の振る舞い・仕様・依存関係の変更（ユーザー体験や API 契約が変わる） | `chg: freezed を 4.0.0 stable に更新` |
| `fix:` | バグ修正・クラッシュ・誤動作の是正 | `fix: 未初期化の Repository で落ちる問題を修正` |
| `mod:` | 構造変更・リファクタリング・設定・CI・ドキュメント整備など、上記以外の改修 | `mod: CI ワークフローの対象ブランチを拡張` |
| `del:` | 機能・ファイル・不要コードの削除 | `del: 未使用の legacy 認証モジュールを削除` |

### prefix の選び方

1. **バグを直した** → `fix:`
2. **新しいものを足した**（機能・テスト・型定義の新設）→ `add:`
3. **既存の意味・振る舞いを変えた**（ライブラリ更新で生成コードが変わる、UX 変更）→ `chg:`
4. **コードを削除した** → `del:`
5. **上記に当てはまらない内部整理**（リファクタ、CI 設定、コメント、import 整理）→ `mod:`

迷ったときは「レビュアーがこの PR を読むとき、新機能なのか修正なのかバグ直しなのか」を基準に選ぶ。

### 使わない prefix

`feat:` `test:` `ci:` `docs:` など Conventional Commits の別表記は **使わない**。意味に近いものは上表へマッピングする。

## 箇条書き（2 行目以降）

* **必須**: 変更が自明でない限り、1 行目だけのコミットにしない
* 各 `-` 行は 1 つの論点に絞る
* 「何を」だけでなく「なぜ」を括弧や続きの句で明示する
* 複数ファイルにまたがる場合は、関心ごと（例: Domain / Repository / UI）で分けてもよい

**良い例:**

```text
fix: 通知 Permission 未許可時にクラッシュする

- Permission 拒否後も subscribe を呼んでいたため、結果をチェックして早期 return する（再現クラッシュの防止）
- 拒否パスの Unit Test を追加（回帰防止）

Co-authored-by: Cursor Agent
```

**避ける例:**

* `バグを修正`（何を・なぜか不明）
* `- いろいろ変更`（箇条書きの意味がない）
* 1 行目に `refs #411` を書く（hook が付ける）

## Agent 署名

AI Agent がメッセージ本文を書いたコミットには、末尾に次の trailer を付ける。

```text
Co-authored-by: Cursor Agent
```

* Git / GitHub で広く使われる trailer 形式であり、`=== by Cursor Agent ===` のような装飾行より履歴上自然
* 署名行の直前に空行を 1 行入れる
* ユーザーが手書きしたメッセージをそのまま使う場合は署名を付けない

## コミット実行時の手順

1. `git status` / `git diff` で変更内容を把握する
2. 本 SKILL に従いメッセージを起草する（`refs #` は含めない）
3. HEREDOC で渡す（subject + body + trailer を 1 つのメッセージにまとめる）

```bash
git commit -m "$(cat <<'EOF'
fix: 通知 Permission 未許可時にクラッシュする

- Permission 拒否後も subscribe を呼んでいたため、結果をチェックして早期 return する（再現クラッシュの防止）
- 拒否パスの Unit Test を追加（回帰防止）

Co-authored-by: Cursor Agent
EOF
)"
```

1. hook 実行後、1 行目末尾に `refs #{Issue番号}` が付いていることを確認する（付かない場合はブランチ名が `feature/id/{n}/...` 形式か確認）

## 関連 SKILL

| 論点 | SKILL |
| --- | --- |
| ブランチ名・Issue 番号の読み取り | `workspace-git-branch-rule` |
| 大きな差分の PR 分割方針 | `split-pull-request-rule` |

## ナレッジベース

### DO: hook に任せる `refs #` を Agent が書かない

* `.hooks/commit-msg` が `feature/id/{Issue番号}/...` から Issue 番号を抽出し 1 行目へ追記する

### DO: 1 コミット 1 関心

* メッセージの箇条書きが増えすぎたら、コミット分割も検討する

### DO NOT: 英語だけの 1 行コメント

* 1 行目・箇条書きは日本語。trailer（`Co-authored-by:`）のみ英語

### DO NOT: prefix なし・曖昧な 1 行目

* `update` `fix bug` `WIP` など、prefix 規約外の書き方は使わない
