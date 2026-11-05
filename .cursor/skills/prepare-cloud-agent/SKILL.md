---
name: prepare-cloud-agent
description: >-
  Cloud Agent のチャット開始時に APM のスキルとスラッシュコマンドを導入し、
  コマンドを使える状態で待機する。チャットの最初の作業、環境整備、
  apm install、apm-install、コマンドが見つからない、スラッシュコマンドを
  使いたい、ときは必ずこの SKILL に従う。生成物はリポジトリにコミットしない。
---

# Cloud Agent の開始準備

チャット開始時に、このリポジトリの `apm.yml` からスキルとスラッシュコマンドを VM へ入れる。
入れ終えたら、利用者の別作業には進まず、コマンドを使える状態で待機する。

Cloud Agent はチャット開始時に `~/.cursor/skills` を読む。ここへコピーされるまで、APM 経由のコマンドはこのチャットから見えない。生成物は git に入れない。

## 準備完了の判定

次の両方が真なら、導入は済んでいる。

* `apm.yml` が存在する
* `~/.cursor/skills/coding-design/SKILL.md` が存在し、`apm.yml` より新しい

済んでいる場合は導入を再実行しない。この SKILL はそこで終了し、利用者の依頼へ進んでよい。

## 導入

リポジトリルートで実行する。

```bash
bash .cursor/scripts/apm-install.sh
```

このスクリプトは APM CLI を入れ、`apm.yml` の依存を展開し、スキルとコマンドを `~/.cursor/skills` へコピーする。失敗したら作業を続けず、終了コードと出力を伝えて止まる。

## 確認

導入後、`.cursor/commands/*.md` のファイル名を小文字のハイフン名にしたものが、すべて `~/.cursor/skills/<名前>/SKILL.md` として存在することを確認する。1 つでも欠ける場合は、コマンドを使える状態ではないので待機せず、欠けた名前を伝えて止まる。

確認できた名前が、このチャットで使えるスラッシュコマンドである。呼び出しは `/coding-design` のように、ハイフン名で行う。

## コミットしないもの

次は生成物である。`git add` しない。

* `apm_modules/`
* `apm.lock.yaml`
* `.agents/`
* `.cursor/agents/`
* `.cursor/commands/`
* `~/.cursor/skills/`

この SKILL 自身（`.cursor/skills/prepare-cloud-agent/`）だけはリポジトリに残す。APM が生成したスキルやコマンドは残さない。

## 待機

このターンで導入を実行した場合は、利用者の他の依頼には進まない。確認できたコマンド名を伝え、次の指示を待つ。

利用者が同じメッセージで、確認できたコマンド名をすでに指定している場合だけは、その `~/.cursor/skills/<名前>/SKILL.md` を読んで従う。
