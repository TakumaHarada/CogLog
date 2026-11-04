---
name: decompose-fat-pr-to-stacked-prs
description: >-
  既存の巨大な Pull Request を、レビュー可能な複数 PR（依存ありは Stacked PR、なしは独立 PR）へ
  再分割・作成する実行系 SKILL。明示コール時、および「この PR を分割して」「fat PR を
  Stacked に直して」「巨大 PR を分解して」など既存 PR の分割が指示されたときは必ず使う。
  分割方針のレビューは split-pull-request-rule と /split-to-prs を基本とする。単純な 1 本 PR
  作成・本文更新だけ、方針提案だけで実行しないとき、元 PR の close/edit 依頼だけでは使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Decompose Fat PR to Stacked PRs

既存の巨大な Pull Request（またはその tip ブランチ上の大きな差分）を、ジュニアが追える粒度の
PR 群へ再分割し、GitHub 上に公開する。依存がある塊は Stacked PR、独立できる塊は独立 PR にする。

## いつ使うか

* ユーザーが本 SKILL を明示的にコールしたとき
* 既存の Pull Request（番号・URL・「この巨大 PR」）の分割・再スタックが指示されたとき
* 「fat PR を Stacked に」「巨大 PR を分解して出し直して」など、既存差分の再分割が論点のとき

## いつ使わないか

* まだ PR が無く、作業中差分を初めて小さく切るだけのとき → 方針は `split-pull-request-rule`、実行は `/split-to-prs`
* 単純な 1 本 PR の作成・本文更新だけ → `/github.create-pull-request`
* Stacked PR の日常運用（rebase / sync / merge）だけ → `gh-stack` SKILL
* 元の巨大 PR を閉じる・本文を直すだけの依頼（本 SKILL は元 PR を変更しない）

## 役割分担

| 役割 | 担当 |
| --- | --- |
| 分割粒度・依存・ブランチ名のルール | `split-pull-request-rule`（必読） |
| 実行時の安全規則（スナップショット、指名ステージ、承認） | `/split-to-prs` |
| Stacked ブランチ / PR の CLI | `gh stack`（`github/gh-stack`。運用詳細は `gh-stack` SKILL） |
| 各 PR の本文テンプレ・作成手順 | `/github.create-pull-request` と `{assets}/template.md` |
| 本 SKILL | 既存 fat PR の調査 → 方針レビュー →（承認後）再分割実行 → 報告 |

開始時に同パッケージの `split-pull-request-rule` を読み、方針判断の正本とする。

## ハードルール

1. **元の巨大 PR は触らない**: close / edit / comment / base 変更 / force 更新を行わない。クローズはユーザー自身が行う。
2. **承認制（既定）**: ブランチ作成・コミット・push・PR 作成は、分割案の承認後にだけ行う。
3. **自律確定の例外**: 次のいずれかが文脈上明らかなときだけ、承認待ちを省略して実行してよい。
   * `/loop` と組み合わせて本 SKILL が回っている
   * ユーザーが決定権を移譲した（「任せる」「承認不要で進めて」「自律で確定して」等）
4. **破壊的 git は禁止（明示承認なし）**: `reset --hard`、`clean -fdx`、履歴書き換え、force push、ブランチ削除はしない。
5. **ステージは指名のみ**: `git add .` / `git add -A` は使わない。含めるパスを明示して stage する。
6. **移動前に復旧可能なスナップショット**を取る（作業ツリーを変えずに）:

```bash
SHA=$(git stash create "pre-decompose-fat-pr")
if [ -n "$SHA" ]; then
  git update-ref "refs/backup/pre-decompose-fat-pr-$(date +%s)" "$SHA"
fi
```

7. **CI のための差分は許容**: 各分割 PR が単独で CI Success になるために必要な最小修正（import、fixture、ビルド設定の追随など）は、元 PR に無い変更でも入れてよい。意図しない機能追加はしない。入れた場合は報告で明示する。

## 前提

* `gh`（推奨 2.90.0 以上）が認証済み
* Stacked 用: `gh extension install github/gh-stack`
* 複数 remote がある場合は `git config remote.pushDefault origin` 等で push 先を確定する
* `gh stack` は**非対話**で呼ぶ（エージェントがハングしないため）:
  * `init` / `add` / `checkout` にはブランチ名（または PR 番号）を必ず渡す
  * `submit` は `--auto` を付ける
  * `view` は `--json` を付ける
  * 詳細はインストール済みの `gh-stack` SKILL に従う

## 作業手順

### 1. 対象の特定

* 既存 PR の番号・URL、または tip ブランチを確定する
* `gh pr view` / `git log` / `git diff <base>...<head>` で差分とコミットを把握する
* base（未指定時はリポジトリの default / `origin/main`）を確定する
* 元 PR の状態は記録するだけにし、**更新しない**

### 2. 分割方針のレビュー

`split-pull-request-rule` の優先度（10 分レビュー、低レイヤー先行、interface → 実装+Unit Test、UI 境界、前提整備の切り出し等）と、`/split-to-prs` のレビューア境界・所有権シグナルを使い、スライス案を作る。

* **blocking 依存がある一連**: 1 つの Stacked PR チェーンにまとめる
* **論理的に独立**: スタックせず、それぞれ default base への独立 PR にする
* ブランチ名: `{元のブランチ名}-{通し番号}-{内容}`（`split-pull-request-rule` と同じ）
* 出力は同 SKILL のフォーマット（要約 / PR 一覧 / 依存グラフ）に合わせる

### 3. 承認ゲート

* **既定**: 分割案（タイトル・ブランチ名・含む変更・依存・Stacked か独立か）を提示し、ユーザー承認を待つ
* **例外**（`/loop` または決定権移譲）: 案を短くログしたうえで実行に進む

### 4. 実行（承認後または自律確定時）

スナップショット取得後:

#### 4-A. Stacked（依存あり）

1. trunk（通常は元 PR の base）から、下層→上層の順でブランチを用意する
2. 各層に、そのスライスの変更だけを指名 stage → commit する
3. `gh stack init` / `gh stack add` で層を繋ぐ（既存ブランチ採用可）
4. `gh stack submit --auto`（ready にするなら `--open`）で Stacked PR を作成・リンクする
5. 各 PR 本文が薄い・英語のみ等なら、`/github.create-pull-request` のテンプレに沿い日本語本文へ整える（**元の巨大 PR は edit しない**。新規に作った分割 PR のみ）

#### 4-B. 独立 PR（依存なし）

1. 各スライス用ブランチを trunk から切る
2. 指名 stage → commit → push
3. `/github.create-pull-request` 相当で `gh pr create --base <trunk>`（本文は `{assets}/template.md` を日本語で埋める）

同一作業に Stacked 群と独立 PR が混在してよい。独立群を無理に 1 スタックへ入れない。

### 5. CI 追随（必要時）

* 分割した各 PR で明らかに壊れるビルド/テストがあれば、その PR ブランチに最小修正を追加コミットする
* 元 PR ブランチや元 PR 自体には書き戻さない
* 報告に「元差分に無い CI 追随」を列挙する

### 6. 報告

短く返す。最低限:

* 分割方針の一言
* 作成した PR のタイトルと URL（Stacked なら stack 番号または並び順）
* 独立 PR の一覧
* 元の巨大 PR へのリンク（**未変更である旨**と、クローズはユーザー作業である旨）
* バックアップ ref（取った場合）
* CI 追随で入れた追加差分（あれば）

## PR 本文

分割後の各 PR について:

* テンプレ正本: `github.create-pull-request` の `{assets}/template.md`（`workspace-resolve-agent-assets` で解決）
* 言語: 日本語
* Summary / Features / Fixed / Deleted は、その PR の diff に基づく事実のみ（捏造しない）
* 一時本文は `workspace-agent-temporary`（`.ai-agent/tmp/`）に置き、利用後に削除する

Stacked の `gh stack submit --auto` が付けたタイトル・本文が不十分なときは、分割で作った PR に対してのみ `gh pr edit` で本文を揃える。

## 出力例（報告）

```markdown
## 分割結果
元 PR #396 は変更していません（クローズはユーザー側）。

### Stacked
1. [#401 …](url) ← base: main
2. [#402 …](url) ← base: …-01-…
3. [#403 …](url)

### 独立
- [#404 …](url)

### CI 追随（元 PR に無かった差分）
- `foo_test.dart`: 分割後に足りない mock を追加（PR #402）

backup: refs/backup/pre-decompose-fat-pr-…
```

## ナレッジベース

### DO: 方針レビューを実行より先に完了させる

* スライスが曖昧なまま `gh stack` すると、後から層の組み直しコストが大きい

### DO: 本当に依存があるときだけ Stack する

* 独立して trunk に出せるものは独立 PR。レビュー並列とコンフリクト低減のためである

### DO: 元 PR を参照用の正として残す

* 比較・差分確認のアンカーになる。本 SKILL は新しい PR 群だけを増やす

### DO: CI 追随は最小・明示

* green のための必要最小限に留め、報告で可視化する

### DO NOT: 元の巨大 PR を close / edit / 更新する

* クローズ判断と操作はユーザーに残す

### DO NOT: 承認前に push / PR 作成する（例外条件を除く）

* `/loop` または明示的な決定権移譲があるときだけ自律確定する

### DO NOT: `git add -A` や force push で一気に載せ替える

* スライス境界が壊れ、復旧不能な履歴操作につながる

### DO NOT: `gh pr merge` で Stacked をマージする

* Stacked のマージは `gh stack merge`（ユーザーがマージを依頼したときに限る。本 SKILL の既定スコープ外）
