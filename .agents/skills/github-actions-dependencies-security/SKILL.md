---
name: github-actions-dependencies-security
description: >-
  GitHub Actions ワークフロー（`.github/workflows/**/*.{yml,yaml}`）構築・編集用 SKILL。
  外部 Action の **コミット SHA ピン留め**、`# owner/repo@version` コメント、
  `gh` での tag→SHA 確認を必須とする。「workflow を書く」「actions の uses を直す」
  「SHA ピン」「mise-action の書き方」「サプライチェーン対策で actions を固定」では必ず使う。
  `.github/**/*.yaml` 編集時は原則ロードする。 PR チェック失敗の原因調査だけや、
  ブランチ命名だけ、アプリ／Dart 実装そのものでは使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# GitHub Actions / ワークフロー構築

`.github/workflows` の YAML を新規作成・改修するとき、セキュリティ上の基本として **外部 Action はコミット SHA にピン留め**する。
フローティングタグ（`@v2` 等）のままにしない。

## いつ使うか

* Workflow YAML の追加・編集（`uses:` を含む）
* 既存 `uses: owner/action@vX` を SHA ピンに直すとき
* 使う Action の tag / Release と SHA を `gh` で確認するとき

## いつ使わないか

* CI 失敗のログ調査・原因切り分けだけ（必要なら本 SKILL と併用）
* Git ブランチ命名だけ（ブランチ規約向けの SKILL がある場合はそちら）
* アプリケーションコードやテスト実装そのもの
* GitHub 以外の CI（CircleCI 等）だけの作業

## 作業手順

1. 追加／変更する `uses:` を洗い出す（サードパーティ・再利用可能ワークフロー）
2. 使いたい版（tag / Release）を決める
3. `gh` で **その版が指すコミット SHA** を取得する（タグオブジェクトの SHA で止めない）
4. `uses: owner/action@{40文字のコミットSHA}` と書き、横に `# owner/action@version` コメントを付ける
5. レビューしやすいよう、なぜその版かを短く残してよい

## Security / SHA ピン留め

外部 Action・再利用ワークフローは、必ず **コミット SHA** で固定する。タグやブランチ名は動く参照であり、サプライチェーン改ざん時に意図せず新しい成果物を取り込む余地がある。

### DO

* `owner/action@{commit_sha}` を使う
* `# owner/action@version` をコメントし、人間が版を追いやすくする
* `gh` で tag / Release とコミット SHA を突き合わせる

```yaml
- name: Setup mise
  uses: jdx/mise-action@{40-char-commit-sha} # jdx/mise-action@v2
```

```bash
# 最新 Release のタグ名
gh api repos/jdx/mise-action/releases/latest --jq '.tag_name'

# タグ一覧（概要）
gh api repos/jdx/mise-action/git/matching-refs/tags \
  --jq '.[] | {tag: (.ref | sub("^refs/tags/"; "")), sha: .object.sha, type: .object.type}'

# 指定タグが指すコミット SHA（annotated tag でもコミットまで辿る例）
TAG=v2
REF=$(gh api "repos/jdx/mise-action/git/ref/tags/${TAG}")
TYPE=$(echo "$REF" | jq -r .object.type)
SHA=$(echo "$REF" | jq -r .object.sha)
if [ "$TYPE" = "tag" ]; then
  SHA=$(gh api "repos/jdx/mise-action/git/tags/${SHA}" --jq .object.sha)
fi
echo "$SHA"
```

* `actions/checkout` 等の公式 Action も、リポジトリ方針としてピン留め対象に含める

### DO NOT

```yaml
# フローティングタグのみ — サプライチェーンリスクが残る
- name: Setup mise
  uses: jdx/mise-action@v2
```

* `@main` / `@master` などのブランチ参照で外部 Action を取らない
* タグオブジェクト SHA をコミット SHA と取り違えたままピンしない（annotated tag は剥がす）

## ナレッジベース

### DO: ピンはコミット、コメントは人間用の版名

* 実行の信頼は SHA、可読性はコメント、の役割分担

### DO: 版を上げるときも「新 tag → 新コミット SHA」で更新する

* コメントの版名だけ変えて SHA を放置しない

### DO NOT: `@v1` のようなメジャーだけ指定で「十分安全」と判断する

* タグは動かされ得る。固定はコミット SHA
