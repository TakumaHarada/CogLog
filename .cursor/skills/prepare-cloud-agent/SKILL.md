---
name: prepare-cloud-agent
description: >-
  Cloud Agent のチャット開始時に APM のスキルとスラッシュコマンドを導入し、
  コマンドを使える状態で待機する。チャットの最初の作業、環境整備、
  apm install、apm-install、コマンドが見つからない、スラッシュコマンドを
  使いたい、ときは必ずこの SKILL に従う。生成したスキルとコマンドは
  リポジトリにコミットしない。
---

# Cloud Agent の開始準備

チャット開始時に、このリポジトリの `apm.yml` からスキルとスラッシュコマンドを VM へ入れる。
入れ終えたら、利用者の別作業には進まず、コマンドを使える状態で待機する。

Cloud Agent はチャット開始時に `~/.cursor/skills` を読む。このリポジトリのコマンドがそこへコピーされるまで、APM 経由のコマンドはこのチャットから見えない。

## 準備完了の判定

リポジトリルートで次を実行する。終了コードが 0 なら導入は済んでいる。

```bash
python3 .cursor/scripts/publish-cursor-skills.py --check
```

このコマンドは `~/.cursor/apm-skill-manifests/` にある、現在のリポジトリ専用のマーカーを読む。マーカーはリポジトリ識別子、`apm.yml` の SHA-256、期待する全コマンド一覧、このリポジトリが配置した項目を持つ。終了コード 0 は、マーカーが今のリポジトリと一致し、一覧のコマンドが `~/.cursor/skills` にあることを意味する。

済んでいる場合は導入を再実行しない。この SKILL はそこで終了し、利用者の依頼へ進んでよい。

## 導入

リポジトリルートで実行する。

```bash
bash .cursor/scripts/apm-install.sh
```

このスクリプトは `apm.lock.yaml` の `apm_version` に固定した APM CLI を入れ、`apm.yml` の依存をロックファイルのコミットで展開し、このリポジトリが管理するスキルとコマンドだけを `~/.cursor/skills` へコピーする。マーカーに無い項目は削除しない。失敗したら作業を続けず、終了コードと出力を伝えて止まる。

導入のあと、もう一度準備完了の判定を実行する。終了コードが 0 でない場合は、コマンドを使える状態ではないので待機せず、出力を伝えて止まる。

標準出力の `commands:` 行が、このチャットで使えるスラッシュコマンドである。呼び出しは `/coding-design` のように、ハイフン名で行う。

## コミットしないもの

次は生成物である。`git add` しない。

* `apm_modules/`
* `.agents/`
* `.cursor/agents/`
* `.cursor/commands/`
* `~/.cursor/skills/`
* `~/.cursor/apm-skill-manifests/`

`apm.lock.yaml` は追跡する。この SKILL 自身（`.cursor/skills/prepare-cloud-agent/`）もリポジトリに残す。APM が生成したスキルやコマンドは残さない。

## 待機

このターンで導入を実行した場合は、利用者の他の依頼には進まない。`commands:` 行の名前を伝え、次の指示を待つ。

利用者が同じメッセージで、その名前をすでに指定している場合だけは、`~/.cursor/skills/<名前>/SKILL.md` を読んで従う。
