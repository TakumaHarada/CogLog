---
name: fix-github-pr-comment
description: >-
  既存 Pull Request のレビューコメント（インライン指摘・スレッド・一般コメント）に従い、
  コード修正・コミット・push・返信・Resolved 化までを一連で行う実行系 SKILL。
  「PR の指摘を直して」「レビューコメントに対応して」「このコメント thread を resolve して」
  「PR #123 のフィードバックを反映して push まで」など、修正作業が伴う PR 対応では必ず使う。
  文案だけ・コミットメッセージだけ・Stacked PR の日常 rebase だけ・fat PR 分割だけでは使わない
  （それぞれ github-comment-rule、git-commit-comment-rule、gh-stack、
  decompose-fat-pr-to-stacked-prs を使う）。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Fix GitHub PR Comment

既存 Pull Request 上のレビュー指摘を読み、コードを直し、コミットして push し、
GitHub 上で返信してスレッドを Resolved にする。Stacked PR の場合は後続 PR へ変更を伝搬する。

## いつ使うか

* ユーザーが **既存 PR 全体** のレビュー指摘対応を依頼したとき
* ユーザーが **特定コメント / スレッド** の修正を依頼したとき
* 「指摘を直して push まで」「Resolved にして」など、**修正 + GitHub 返信** がセットのとき

## いつ使わないか

* 返信文案だけ・コメント起草だけ → `github-comment-rule`
* コミットメッセージだけ → `git-commit-comment-rule`
* Stacked PR の rebase / sync / merge だけ → `gh-stack`
* 巨大 PR の分割・再スタック → `decompose-fat-pr-to-stacked-prs`
* 新規 PR 作成 → `/github.create-pull-request`

## 役割分担

| 役割 | 参照先 |
| --- | --- |
| コミットメッセージ | `git-commit-comment-rule`（必読・必須） |
| GitHub 返信文案・署名 | `github-comment-rule`（必読・必須） |
| Stacked PR の伝搬 | `gh-stack` SKILL |
| ブランチ名・Issue 番号 | `workspace-git-branch-rule` |
| 本 SKILL | チェックアウト → 修正 → 検証 → コミット → push → 返信 → Resolved → 伝搬 |

開始時に同パッケージの `git-commit-comment-rule` と `github-comment-rule` を読む。

## ハードルール

1. **作業ツリーはクリーン必須**: 未コミット変更（staged / unstaged / untracked で作業に干渉するもの）がある状態では checkout しない。**エラーとして停止**し、ユーザーに stash / commit / discard を促す。
2. **PR ブランチの最新 HEAD で作業**: checkout 後、`origin` の tip と fast-forward 同期する。
3. **CI Success は待たない**（ユーザーが明示指示した場合のみ待つ）。
4. **破壊的 git は禁止**: `reset --hard`、`clean -fdx`、force push、履歴書き換えはしない（明示承認なし）。
5. **ステージは指名のみ**: `git add .` / `git add -A` は使わない。
6. **Resolved は対応済みスレッドだけ**: 修正・返信したスレッドのみ resolve する。未対応の指摘を resolve しない。

## 前提

* `gh` が認証済み
* 対象リポジトリの作業ディレクトリにいる（または `--repo owner/name` を明示）
* Stacked PR 伝搬には `gh extension install github/gh-stack` が必要
* `gh stack` は**非対話**で呼ぶ（`view --json`、`submit --auto` 等）。詳細は `gh-stack` SKILL

## 作業手順

### 0. 対象の特定

ユーザー入力から次を確定する。

| 項目 | 例 |
| --- | --- |
| PR 番号 / URL | `#123`, `https://github.com/org/repo/pull/123` |
| スコープ | PR 全体 / 特定スレッド（URL・コメント ID・引用） |
| リポジトリ | カレント repo または `--repo` |

```bash
PR=123
gh pr view "$PR" --json number,title,headRefName,baseRefName,url
```

### 1. 作業ツリーの検証（Checkout 前）

```bash
if [ -n "$(git status --porcelain)" ]; then
  echo "ERROR: Working tree is not clean. Commit, stash, or discard changes first."
  exit 1
fi
```

クリーンでなければ **ここで停止**。ユーザーへ状況を報告する。

### 2. Checkout（PR ブランチ + 最新 HEAD）

```bash
gh pr checkout "$PR"
BRANCH=$(git branch --show-current)
git fetch origin "$BRANCH"
git merge --ff-only "origin/$BRANCH"
```

* checkout 失敗（競合ブランチ名、fetch 失敗等）も **エラー停止**し、原因を報告する
* 既に対象ブランチにいる場合も、上記 fetch + ff-only merge で最新化する

### 3. 指摘の収集

未対応の review thread を GraphQL で取得する。

```bash
OWNER=$(gh repo view --json owner -q .owner.login)
REPO=$(gh repo view --json name -q .name)

gh api graphql -f query='
query($owner: String!, $name: String!, $number: Int!) {
  repository(owner: $owner, name: $name) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          path
          line
          comments(first: 20) {
            nodes {
              id
              body
              author { login }
              createdAt
            }
          }
        }
      }
    }
  }
}' -f owner="$OWNER" -f name="$REPO" -F number="$PR"
```

* **PR 全体**: `isResolved == false` の thread をすべて対象
* **特定コメント**: ユーザー指定（URL、thread id、引用文、ファイル+行）に一致する thread のみ
* 一般 PR コメント（discussion）でコード修正が要る場合は本文を読み、対応後 `gh pr comment` で返信（thread resolve は対象外）

各 thread について「何を直すか」を短くメモし、修正計画を立てる。

### 4. コード修正

* 指摘内容に沿って最小限の diff を作る
* 1 thread 1 論点を基本とし、関連する指摘はまとめてよい
* 意図が不明な指摘は、推測で大きく変えずユーザー確認を優先する

### 5. ローカル検証（最小限）

リポジトリ種別に応じた **最小** チェックを行う。失敗したら commit / push 前に直す。

| リポジトリ | 例 |
| --- | --- |
| Flutter / Dart (`pocket_kosodate`) | `mise exec -- dart analyze <変更パス>`、`mise exec -- dart format <変更パス>`、関連 Unit Test |
| Backend 等 | 該当 package の linter / formatter / 関連 test |

* 変更ファイル全体の analyze / format を優先
* 指摘箇所に直接関係する test があれば実行
* E2E や CI 全件は **実行しない**（明示指示時のみ）

### 6. コミット

`git-commit-comment-rule` に従いメッセージを書く。

* 1 コミット 1 関心が理想。複数 thread 対応でも「同じ論点」なら 1 コミット可
* `refs #` は書かない（hook が付与）
* Agent が書いたメッセージには `Co-authored-by: Cursor Agent` を付ける

```bash
git add path/to/changed_file.dart
git commit -m "$(cat <<'EOF'
fix: レビュー指摘の Permission 拒否パスを修正

- subscribe 前に Permission 結果を確認するよう変更（拒否時クラッシュの防止）
- 拒否パスの Unit Test を追加（回帰防止）

Co-authored-by: Cursor Agent
EOF
)"
```

### 7. Push

```bash
git push origin "$(git branch --show-current)"
```

### 8. GitHub 返信 + Resolved

`github-comment-rule` に従い、**対応した各 thread** に返信して resolve する。

**返信（スレッド reply）:**

```bash
THREAD_ID="PRRT_..."   # 手順 3 で取得した node id

gh api graphql -f query='
mutation($input: AddPullRequestReviewThreadReplyInput!) {
  addPullRequestReviewThreadReply(input: $input) {
    comment { id url }
  }
}' -f input="{\"pullRequestReviewThreadId\":\"$THREAD_ID\",\"body\":\"ご指摘ありがとうございます。Permission 拒否時は subscribe を呼ばないよう修正しました。Unit Test も追加しています。\\n\\n---\\n*Cursor Agent*\"}"
```

**Resolved 化:**

```bash
gh api graphql -f query='
mutation($input: ResolveReviewThreadInput!) {
  resolveReviewThread(input: $input) {
    thread { id isResolved }
  }
}' -f input="{\"threadId\":\"$THREAD_ID\"}"
```

* 返信 → resolve の順で行う
* PR 全体対応では、修正した thread それぞれに返信 + resolve
* 一般コメントへの返信は `gh pr comment "$PR" --body "..."`（resolve なし）

### 9. Stacked PR への伝搬

主題 PR が Stacked PR か判定する。

```bash
gh stack view --json 2>/dev/null || true
```

`gh stack view --json` で現在ブランチが stack に含まれ、かつ上に子ブランチがある場合:

1. `gh stack rebase --upstack` で後続ブランチへ変更を rebase 伝搬
2. 各 upstack ブランチで conflict があれば解消 → `gh stack rebase --continue`
3. `gh stack push` で remote 更新
4. 後続 PR ごとに必要なら `github-comment-rule` に従い「上位 PR の修正を rebase 伝搬済み」とコメント

Stacked でない場合はこのステップをスキップする。

### 10. 完了報告

ユーザーへ次を伝える。

* 対応した PR / thread 一覧
* コミット SHA（短 hash）
* push 済みブランチ名
* resolve した thread 数
* Stacked 伝搬の有無
* ローカル検証結果（analyze / test）
* CI は未待機であること（明示指示がなければ）

## フロー概要

```text
[作業ツリー clean?] ─no→ ERROR 停止
        │
       yes
        ↓
[PR checkout + ff-only 最新化]
        ↓
[未 resolve thread 収集 → 修正計画]
        ↓
[コード修正 → ローカル最小検証]
        ↓
[git commit (git-commit-comment-rule)]
        ↓
[git push]
        ↓
[thread 返信 (github-comment-rule) → resolve]
        ↓
[Stacked?] ─yes→ [rebase --upstack → push → 後続 PR 通知]
        ↓
[完了報告]
```

## エラー時の扱い

| 状況 | 動作 |
| --- | --- |
| 作業ツリーが dirty | 即停止。checkout しない |
| ff-only merge 不可 | 停止。ユーザーに rebase / 手動整理を依頼 |
| push 拒否 | 停止。remote との差分を報告（force はしない） |
| rebase conflict（stack） | 解消を試み、不能なら `gh stack rebase --abort` して報告 |
| 指摘の意図が不明 | 推測修正せず、確認事項をユーザーに返す |

## 関連 SKILL / Command

| 論点 | 参照先 |
| --- | --- |
| コミットメッセージ | `git-commit-comment-rule` |
| GitHub コメント文案 | `github-comment-rule` |
| Stacked PR CLI | `gh-stack` |
| ブランチ規約 | `workspace-git-branch-rule` |
| Dart 静的解析 | `dart-run-static-analysis`（Flutter リポジトリ） |

## ナレッジベース

### DO: checkout 前に必ず clean 確認

* 未コミット変更があると、意図しないファイル混在や checkout 失敗の原因になる

### DO: 返信と resolve をセットで

* 修正だけ push して thread を open のまま残さない（レビュアーの認知負荷を下げる）

### DO: Stacked PR では upstack 伝搬を忘れない

* 下位 PR の修正が上位 PR に載らないと、後続レビューが古いコードを見続ける

### DO NOT: 未対応 thread を resolve

* 対応していない指摘を Resolved にすると、レビュー品質が下がる

### DO NOT: CI 完了を暗黙待ち

* ユーザーが指示しない限り `gh pr checks --watch` 等で待機しない

### DO NOT: force push

* レビュー中 PR の履歴を書き換えない（明示承認なし）
