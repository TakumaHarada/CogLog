---
name: tool-read-document-skill-creator
description: >-
  特定ドキュメント群を Context 最適化して読むための SKILL（索引 SKILL）を新規作成・改訂する。
  「ドキュメント読み込み用 SKILL を作って」「docs 索引スキルを書いて」
  「references を Stage 1 から読む SKILL にして」「アーキテクチャ把握 SKILL を markdown-search 対応で」
  「repo-knowledge 系の SKILL を作って」のときは必ず使う。
  生成物は対象 path と description トリガーに留め、読み方は markdown-search へ誘導する（手順の再掲はしない）。
  汎用の SKILL 作成フローは skill-creator、コマンド記述・APM 依存は tool-skill-creator-extension、
  slash-command / Sub Agent は tool-command-creator / tool-sub-agent-creator を使う。
license: MIT License
metadata:
  author: "@eaglesakura"
---

# Tool / Read-Document Skill Creator

ドキュメント索引 SKILL は、長い docs / references を Agent が **いきなり全文ロードしない** ための入口である。
「どの文書を、いつ、どの深さまで読むか」を SKILL に固定し、実行時の把握は常に `markdown-search` に委譲する。

本 SKILL は **そうした索引 SKILL の定義ファイルを書く**。`markdown-search` 本体の手順は書かない。

## いつ使うか / 使わないか

* 使う: 複数 Markdown（`docs/`・`references/`・設計資料など）を束ねて読む専用 SKILL の作成・改訂
* 使う: 既存の「リンク列挙だけ」の知識 SKILL を、Stage 1 必須の契約へ更新するとき
* 使わない: 汎用の任意 Markdown 探索そのもの（→ `markdown-search`）
* 使わない: slash-command / Sub Agent 定義（→ `tool-command-creator` / `tool-sub-agent-creator`）
* 使わない: ドキュメントの新規執筆・lint（→ `markdown-documentation` / `markdown-fix`）

## 出力先と命名

* プロジェクト共有: `.cursor/skills/{skill-name}/SKILL.md` または `.agents/skills/{skill-name}/SKILL.md`
* APM パッケージのソース: `.apm/skills/{skill-name}/SKILL.md`
* ディレクトリ名と frontmatter `name` を一致させる
* **SKILL 名が未確定なら文脈から提案し、ユーザー確認後に確定する**。ユーザーが既に指定しているならそれに従う

### 命名の目安

| パターン | 例 | 向いているとき |
| --- | --- | --- |
| `{領域}-knowledge-{主題}` | `repo-knowledge-architecture` | リポジトリ固有の知識索引 |
| `{領域}-spec-{主題}` | `hq-spec-generative-ai-law` | 仕様・制約の正本索引 |
| `{領域}-{主題}-docs` | `backend-auth-docs` | docs 束の入口であることが主眼 |

ハイフン区切り・小文字。抽象名（`docs-helper` 等）は避け、**どの文書群か**が名前から分かるようにする。

## 必須: テンプレート準拠

出力は必ず [assets/read-document-skill.md](./assets/read-document-skill.md) に従う。
プレースホルダ（`{...}`）と HTML コメントは最終成果物から除去する。

段階ロードの意味・スクリプトは [references/loading-contract.md](./references/loading-contract.md) を確認してから本文へ落とす。

## 生成 SKILL の契約（必須）

作成・改訂する索引 SKILL 自体が、実行時に次を守るように書く。

### トリガー（いつロードするか）

* **「いつ読むか」は frontmatter の `description` に集約する**（本文に同じトリガーを重複させない）
* 参照ドキュメントの主題・キーワード・判断場面を `description` に書く（押し気味でよい）
* ユーザー／親プロンプトで対象文書・節・観点が制約されている場合は、**その文脈を優先**する（索引を機械的に全消化しない）
* **対象ドキュメントの内容要約は SKILL 本文に書かない**（正本との齟齬を防ぐ。内容は正本を Stage で読む）

### ロード深さ（Context 最適化）

* 把握手順・Stage・出力の取り方は **生成 SKILL 本文に再掲しない**。`markdown-search` への誘導のみにする（Context 節約）
* 作成者向けの契約（適用時は Stage 1 から、全文先読み禁止など）は [references/loading-contract.md](./references/loading-contract.md) を正とし、生成物では「`markdown-search` に従う」と書く
* 「念のため全文」「全部まとめて Read」を生成 SKILL の既定手順にしない

### 対象ドキュメント一覧

* 実在 path のみ（推測で架空パスを書かない）
* **path の列挙に留める**。内容要約・個別の「いつ読むか」注記は付けない
* path 表記は次のいずれかとし、実行時に対応 SKILL で解決できる形にする
  * Markdown リンク（SKILL.md 相対）→ `workspace-resolve-file-path`
  * クォート `path/to/file`（Git リポジトリルート相対）→ `workspace-resolve-file-path`
  * `@{name}/...` / `repo:{name}/...`（`this` / `example` 可）→ `workspace-resolve-root-directory`
* 同梱 `references/` は SKILL 相対の Markdown リンクを推奨
* Multi-Root や別リポジトリをまたぐ参照は `@` / `repo:` を優先する
* 他 package の path を本文に書く場合は、所属 package の `apm.yml` 依存に沿う（`tool-skill-creator-extension`）

### 境界と委譲

* 索引 SKILL は **読む入口**。探索アルゴリズム・lint・パス解決・段階ロード手順の正本を再定義しない
* 段階ロードの正本は常に `markdown-search` を「関連」に明記する

## frontmatter の書き方

| フィールド | 役割 |
| --- | --- |
| `name` | SKILL 識別子。ディレクトリ名と一致（必須） |
| `description` | いつロードするかの主トリガー。文書主題・判断場面を具体的に（必須） |
| `metadata.author` | 任意。ユーザー指定時のみ |

`license` は生成 SKILL に書かない。

```yaml
---
name: repo-knowledge-architecture
description: >-
  バックエンドのアーキテクチャ docs を Stage 1 から正本把握するための索引 SKILL。
  Layer / 認証 / 通信フロー / モジュール構成を実装・設計・レビュー前に確認するときは必ず使う。
  「アーキテクチャを読んでから」「どの docs を見るべき？」でもロードする。
  内容判断は docs 正本から行い、本 SKILL に要約を置かない。
---
```

## 本文セクション

テンプレートの見出し順を守る。

1. **タイトル（H1）** — `{領域} / {ドキュメント群の入口}`（内容要約にしない）
2. **導入** — 索引であること、正本から読むこと、`description` にトリガー集約、読み方は `markdown-search`
3. **使わないか** — 隣接領域の除外（「いつ使うか」は `description` のみ）
4. **対象ドキュメント** — path のみ（内容要約・個別トリガー注記なし）
5. **読み方** — `markdown-search`（および path 解決 SKILL）への誘導のみ。Stage / 出力の再掲はしない
6. **境界** — 対象外・要約再掲禁止・委譲先
7. **関連** — 少なくとも `markdown-search` とパス解決 SKILL

slash-command 用の Mermaid 必須・バリデーション表・非対話エラー終了契約は **載せない**。

## 作業手順

### ステップ1: 要件の収集

ユーザー依頼と既存の索引 SKILL・対象 docs から次を確定する。

* SKILL 名（未確定なら提案リストを出し、確定名を待つ）
* 対象ドキュメント path 一覧（実在確認）
* **トリガーは `description` に集約**（本文の「いつ使うか」重複は作らない）
* 使わない場面（隣接 SKILL / 文書群）
* プロンプト制約があるときの優先ルール（通常は「制約に合う文書から」）
* 委譲先 SKILL（隣接領域）
* （任意）`metadata.author`

不足は推測で埋めず、質問してからドラフトする。
特に **SKILL 名** と **対象 path** は確定前に勝手に書き出さない。
対象ドキュメントの **内容要約を SKILL に書かない**（注記欲しくなっても正本誘導に留める）。

### ステップ2: 対象ドキュメントの下調べ

* 各表記を `workspace-resolve-file-path` / `workspace-resolve-root-directory` で実体へ落とし、存在確認する
* 必要なら `markdown-search` で Stage 1 TOC だけ取り、`description` 用のトリガー語彙を把握する（内容要約を本文に落とさない。Stage 3 を既定にしない）
* 重複内容のコピーが複数 path にある場合は、生成 SKILL の一覧では代表 path を優先し、二重ロード注意を手順に残す
* 生成本文の path 表記は、解決できた形式（リンク / クォート相対 / `@`・`repo:`）のまま残す

### ステップ3: frontmatter と本文の完成

* [assets/read-document-skill.md](./assets/read-document-skill.md) に沿って Markdown を完成させる
* `description` に「いつ読むか」を押し気味に集約する（内容要約は入れない）
* 「対象ドキュメント」は path のみ。「読み方」は `markdown-search` への誘導に留め、Stage / 出力を再掲しない
* 配置先へ書き出す（改訂時は差分の意図を保つ）
* プレースホルダ・説明用 HTML コメントが残っていないことを確認する

コマンド例を本文に書く場合は `tool-skill-creator-extension` に従い、ツールチェイン wrapper を埋め込まない。

### ステップ4: 自己レビュー

* [ ] 出力先・ディレクトリ名と frontmatter `name` が一致する
* [ ] SKILL 名がユーザー確定済み（提案のみで確定書き出ししていない）
* [ ] `description` に「いつ読むか」が集約され、押し気味のトリガーになっている（内容要約ではない）
* [ ] 本文に「いつ使うか」の重複セクションや、ドキュメント内容要約が無い
* [ ] 「対象ドキュメント」が path のみ（個別の要約・いつ読むか注記が無い）
* [ ] path がリンク / クォート相対 / `@`・`repo:` のいずれかである
* [ ] 「読み方」が `markdown-search` 誘導のみで、Stage 手順・出力の目安の再掲が無い
* [ ] 関連に `markdown-search` とパス解決 SKILL がある
* [ ] 探索アルゴリズム・lint・パス解決・段階ロード手順を本 SKILL 内で再発明していない
* [ ] 他 package 参照がある場合、`apm.yml` 依存と整合している（または選択肢提示済み）
* [ ] テンプレのプレースホルダ・HTML コメントが残っていない
* [ ] slash-command 用の Mermaid / バリデーション表を誤って入れていない

## 品質の目安

別セッションの Agent が、会話履歴なしでもこの索引 SKILL から候補 path を得て、`markdown-search` で正本へ向かえること。
トリガーが `description` に集まり、無関係タスクでは過剰ロードしないこと。
生成 SKILL が `markdown-search` の手順を複製して Context を膨らませないこと。

## 関連

* 段階ロードの実行正本: `markdown-search`
* パス解決: `workspace-resolve-file-path` / `workspace-resolve-root-directory`
* SKILL 作成の汎用フロー: `skill-creator`
* コマンド記述・`{assets}/`・APM 依存: `tool-skill-creator-extension`
* slash-command / Sub Agent: `tool-command-creator` / `tool-sub-agent-creator`
