---
name: tool-sub-agent-creator
description: >-
  Cursor のカスタム Sub Agent（`.cursor/agents/*.md`）を新規作成・改訂する SKILL。
  「Sub Agent を作って」「.cursor/agents にエージェント定義を追加」「junior/senior 用 Agent を書いて」、
  agents 定義のテンプレート準拠化・職能と実施タスクの明文化・アセットディレクトリ追記のときは必ず使う。
  slash-command（`.cursor/commands`）は tool-command-creator、SKILL 本体は skill-creator /
  tool-skill-creator-extension、親からの SKILL 受け渡しは agent-call-sub-agent を使う。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Tool / Cursor Sub Agent Creator

Sub Agent はクリーンコンテキストで動く特化 Agent である。
ロール・職能・実施タスク・出力・ガードレールを定義ファイルに固定し、親が Task で委任したとき迷わず動けるようにする。

## いつ使うか / 使わないか

* 使う: `.cursor/agents/` に配置するカスタム Sub Agent の作成・改訂
* 使わない: slash-command（`tool-command-creator`）
* 使わない: Agent Skill（`skill-creator` / `tool-skill-creator-extension`）
* 使わない: 親が Task 起動時に SKILL をサジェストする手順そのもの（`agent-call-sub-agent`）

## 出力先と命名

* プロジェクト共有のみ: `.cursor/agents/{agent-name}.md`
* ファイル名（拡張子除く）と frontmatter `name` を一致させる
* 命名は `{領域}.{役割}` のドット区切りを推奨する
  * 例: `docs-assistant.writer`、`docs-assistant.plan-reviewer`
* 本文 H1 はファイル名ではなく `{ロール} / {職能} / {実施するタスク}` の三段とする
  * 例: `ジュニアエンジニア / 実装アシスタント / 承認済み計画ステップの実装`

## 必須: テンプレート準拠

出力は必ず [assets/subagent.md](./assets/subagent.md) に従う。
プレースホルダ（`{...}`）と HTML コメントは最終成果物から除去する。

## frontmatter の書き方

| フィールド | 役割 | デフォルト |
| --- | --- | --- |
| `name` | Sub Agent 識別子。ファイル名と一致 | （必須・個別） |
| `model` | 使用モデル。`inherit` または具体 ID | `inherit` |
| `description` | 親が委譲判断に使う。ロール・入出力・いつ使うかを具体的に | （必須・個別） |
| `readonly` | 書き込み制限 | `true` |
| `is_background` | 親をブロックせず背景実行するか | `false` |
| `license` | 任意 | 省略可。入れるなら `MIT License` 等 |
| `metadata.author` | 任意 | ユーザー指定時のみ |

`readonly` / `is_background` / `model` は用途に応じて個別判断する。
判断材料が無いときの初期値は上表（テンプレートどおり）とする。
`metadata.author` は省略してよい。ユーザーが指示したときだけ書く。

必須・任意の SKILL は frontmatter ではなく本文 `## 追加コンテキスト` に書く（後述）。
`{assets}/` の探索先は frontmatter ではなく本文 `## アセットディレクトリ` に書く。
旧 `metadata.required_skills` / `metadata.assets` / `metadata.references` は新規・改訂の正本にしない（後方互換で読まれる場合があっても、こちらから新規に書かない）。

### description の記載規則

親 Agent の委譲判断に使われるため、曖昧な一文にしない。

* ロール（誰として動くか）
* 主タスク（何をするか）
* 入出力の概略（何を受け何を返すか）
* トリガー語（いつ委任すべきか）

```yaml
# DO NOT
description: コードを手伝う Agent

# DO
description: >-
  ジュニアエンジニアとして承認済み計画の指定ステップのみ実装する Sub Agent。
  計画ファイルとステップ番号を受け取り、範囲外変更なしで実装差分と検証結果を返す。
  「ジュニアに実装委任」「ステップ単位で実装」では使う。
```

## 本文セクション

テンプレートの見出し順を守る。slash-command のような Mermaid 必須・バリデーション表・非対話エラー終了契約は **載せない**。

1. **タイトル（H1）** — `{ロール} / {職能} / {実施するタスク}`
2. **専門性** — 役割・職能・自立性の有無などを箇条書き
3. **追加コンテキスト** — **必須**。次を含める

   ```markdown
   * 親Agentから指示されたSKILLやドキュメントを自己判断によりロードする
     * Required: {SKILL名}
     * Optional: {SKILL名}
   ```

   * 先頭の一文は文言を変えず残す
   * `Required:` / `Optional:` は SKILL の `name`（ディレクトリ名）を書く。実在確認できない名前を推測で埋めない
   * Required が無い Agent（単純な探索専用など）は `Required:` 行を書かず、一文だけでもよい
   * Optional も無いなら `Optional:` 行は省略してよい
   * 親の `agent-call-sub-agent` は `Required:` を必須サジェストの第一ソースとして扱う
   * 必要なら、よく使うドキュメントへのリンクを同セクションに追記してよい

4. **アセットディレクトリ** — `{assets}/...` を使う場合のみ。探索先ディレクトリを箇条書き。使わないならセクションごと省略
5. **実施タスク** — やるべき作業。手順が固いなら詳細手順・チェックリスト。固くないなら期待役割と完了条件
6. **出力フォーマット** — 親へ返す結果の書式。可能な限り固定。フリーならその旨を明記
7. **ガードレール** — 逸脱禁止・中断条件・権限外作業の扱いなど
8. **ナレッジベース** — `markdown-documentation` と同じ `### DO:` / `### DO NOT:`。不要ならセクション省略可

### アセットディレクトリの記載規則

`{assets}/...` を本文で使う場合に限り、`## アセットディレクトリ` を置く。使わない Agent ではセクションごと省略する。

* 各行はディレクトリパス（ファイルパスではない）
* 文書相対（この Agent 定義ファイルから）またはリポジトリルート相対
* 開発時と install 後の両方を並べると、APM 展開先でも解決しやすい
* Markdown リンク `[label](path)` 形式でもよい（`path` をディレクトリとして使う）
* `{assets}/foo.md` の解決は `workspace-resolve-agent-assets` が本セクション（および互換の旧 `metadata.assets`）から候補を読む

```markdown
## アセットディレクトリ

* `../assets/`
* `apm_modules/**/agent-creator/.apm/assets/`
```

## 親 Agent・SKILL との関係

* 子は親の Skills カタログを自動継承しない
* 親は起動時に `agent-call-sub-agent` で SKILL サジェストを付けうる
* 本文 `Required:` は親にとっての必須サジェスト一覧であり、子にとっても必須 Apply 対象である
* 本定義の「追加コンテキスト」は、サジェスト（および親が渡した文書）を子が自己判断で Apply するための受け皿である（Required 分は判断で落とさない）
* 本 SKILL は Sub Agent **定義ファイル**を書く。親の起動手順そのものは書かない

## 作業手順

### ステップ1: 要件の収集

ユーザー依頼と既存 `.cursor/agents/*.md` から次を確定する。

* Agent 名（`{領域}.{役割}`）
* H1（ロール / 職能 / 実施タスク）
* 専門性・自立性の境界
* 実施タスクの固さ（詳細手順か役割記述か）
* 出力フォーマット
* `model` / `readonly` / `is_background`（判断材料が無ければデフォルト）
* `## 追加コンテキスト` の Required / Optional（無ければ省略）
* `{assets}/` 利用の有無と、ある場合の `## アセットディレクトリ` 候補
* （任意）`metadata.author` — ユーザーが求めた場合のみ

不足は推測で埋めず、質問してからドラフトする。

### ステップ2: frontmatter の下書き

`name` / `description` / `model` / `readonly` / `is_background` を先に固定する。
`author` はユーザー入力があるときだけ含める。
旧 `metadata.required_skills` / `metadata.assets` / `metadata.references` は書かない。
`description` で委譲判断が足りるか確認する。

### ステップ3: 本文の完成と配置

* [assets/subagent.md](./assets/subagent.md) に沿って Markdown を完成させる
* `## 追加コンテキスト` に必須一文と、必要な `Required:` / `Optional:` があることを確認する
* `{assets}/` を使うなら `## アセットディレクトリ` を書き、使わないならセクションを置かない
* Required / Optional と専門性・実施タスクが矛盾しないことを確認する
* ナレッジベースを置く場合は `### DO:` / `### DO NOT:` 形式にする
* `.cursor/agents/{agent-name}.md` へ書き出す（改訂時は差分の意図を保つ）
* プレースホルダ・説明用 HTML コメントが残っていないことを確認する

### ステップ4: 自己レビュー

* [ ] 出力先が `.cursor/agents/{name}.md` で、`name` とファイル名が一致する
* [ ] 命名が `{領域}.{役割}` になっている（推奨に沿う）
* [ ] H1 が `{ロール} / {職能} / {実施するタスク}` である
* [ ] `model` / `readonly` / `is_background` が意図どおり（未指定時は inherit / true / false）
* [ ] `description` にロール・タスク・入出力・トリガーが含まれる
* [ ] 必須ロードがある場合: `## 追加コンテキスト` に `Required: {実在SKILL名}` がある
* [ ] 必須ロードを frontmatter の旧 `required_skills` だけに書いて本文を空にしていない
* [ ] `## 追加コンテキスト` に必須一文がある
* [ ] `{assets}/` を使う場合: `## アセットディレクトリ` に探索先が列挙されている（使わないならセクション無し）
* [ ] 旧 `metadata.assets` / `metadata.required_skills` / `metadata.references` を新規に書いていない
* [ ] 実施タスクと出力フォーマットが具体的である
* [ ] ガードレールが実行時の禁止・中断として読める
* [ ] ナレッジベースがある場合: `### DO:` / `### DO NOT:` 形式である
* [ ] `author` を書いた場合のみ: ユーザー指定どおり
* [ ] テンプレのプレースホルダ・HTML コメントが残っていない
* [ ] slash-command 用の Mermaid / バリデーション表 / 非対話エラー契約を誤って入れていない

## 品質の目安

別セッションの親 Agent が、会話履歴なしでもこの定義と Task prompt（および SKILL サジェスト）だけで、同じ職能境界の成果を返せること。
子が「何をしてよいか分からない」「親の Skills を勝手に全ロードする」状態にならないこと。

## 関連

* 起動時の SKILL 受け渡し: `agent-call-sub-agent`
* `{assets}/` 解決: `workspace-resolve-agent-assets`
* slash-command 作成: `tool-command-creator`
* DO/DO NOT 書式: `markdown-documentation`
* Cursor 組み込みの汎用 create-subagent とは別物。本リポジトリでは本テンプレートを正とする
