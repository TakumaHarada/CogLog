---
name: tool-skill-creator-extension
description: >-
  SKILL 作成・改訂時のコマンド記述・共有アセット参照・APM パッケージ依存の参照ルールを補足する SKILL。
  skill-creator で新規 SKILL を書く、既存 SKILL のコマンド例を直す、手順書に
  `dart` / `flutter` / `go` / `npm` 等を載せるときは必ず使う。
  `{assets}/` や共有テンプレートを SKILL から参照する、`## アセットディレクトリ` を書く、
  「mise を SKILL から外す」「portable な手順にする」でもロードする。
  他 package の SKILL / command を本文で参照する、`apm.yml` 依存と参照の整合を見る、
  未宣言依存・逆依存を防ぐ・直す、でも必ず使う。
  `mise exec --` / `fvm` / `asdf` 等のツールチェイン wrapper を SKILL 本文に埋め込まない。
  実際のシェル実行そのものだけ（SKILL を書かない）では使わない。
  `{assets}/` の実行時解決は workspace-resolve-agent-assets を使う。
---
# Tool / Skill Creator Extension

SKILL はリポジトリ横断・環境横断で再利用される。ツールチェイン管理（`mise` / `fvm` / `asdf` 等）の
prefix・wrapper は **プロジェクト固有の実行規約** であり、SKILL 本文に焼き付けると他環境でノイズになる。
コマンド例は素のツール呼び出しだけを書き、実行時の wrapper は各プロジェクトのルール（`AGENTS.md` 等）に任せる。

共有アセット（テンプレート・雛形・パッケージ配下の `.apm/assets/` 等）を参照する場合も、
インストール先の 1 パスを直書きせず、`{assets}/` と `## アセットディレクトリ` で解決できるようにする。

さらに SKILL 本文から他 package の SKILL / command / パスを参照する場合は、
編集対象 package の `apm.yml` が宣言する依存グラフに従う。ワークスペースに兄弟 package が並んで見えても、
未宣言の参照や逆依存を残すと、導入した第三者が混乱する。

本 SKILL は `skill-creator` の補足である。SKILL を新規作成・改訂するときは本ルールも適用する。

## いつ使うか

* 新規 SKILL の `SKILL.md` / `references/` にシェルコマンド例を書くとき
* 既存 SKILL から `mise exec --` 等の project-local wrapper を除去・正規化するとき
* skill-creator のドラフト・レビューで「コマンドの書き方」を点検するとき
* SKILL 本文から共有アセット（テンプレート等）を参照するとき
* `{assets}/` や `## アセットディレクトリ` を追加・移行するとき
* SKILL 本文で他 SKILL / command 名を明示参照するとき
* 他 package パスを本文や例に書くとき
* `apm.yml` の依存と SKILL 参照の整合・未宣言依存・逆依存を点検・修正するとき

## コアルール

### frontmatter（`license` / `metadata`）

* `name` / `description` 以外の frontmatter は **Optional**
* `license` と `metadata`（`metadata.author` 含む）は、**ユーザーが明示指定したときだけ**書く
* 既定値（例: `MIT License`、`author: "@eaglesakura"`）で勝手に埋め込まない
* 指定が無い新規・改訂では、これらのキーを frontmatter に残さない（削除してよい）

### SKILL に書くコマンド（portable）

* ツール本体の呼び出しだけを書く（`dart` / `flutter` / `go` / `npm` / `npx` など）
* プロジェクト固有のツールチェイン wrapper・prefix・suffix は **含めない**
  * 例: `mise exec --` / `mise run` / `fvm` / `asdf exec` / `direnv exec` / `nix-shell --run`

#### DO: ツール本体だけを書く

```bash
dart -h
flutter --version
go test ./...
npx markdownlint-cli2 --fix path/to/file.md
```

#### DO NOT: ツールチェイン wrapper を埋め込む

```bash
mise exec -- dart -h
fvm flutter --version
asdf exec go test ./...
```

### 実行時（runtime）の扱い

SKILL を **実際に実行する** ときは、この限りではない。

* 作業対象リポジトリに `mise` / `fvm` 等の規定があれば、そのプロジェクトルールに従う
* 規定の所在は `AGENTS.md`・リポジトリ README・既存スクリプトを優先して確認する
* SKILL 本文を「実行用の最終コマンド」と同一視しない（本文は portable、実行は local policy）

必要なら SKILL 側に次のような一文を置いてよい（具体的な wrapper 名は書かない）。

```markdown
コマンド実行時は、プロジェクト規定のツールチェイン（あれば）に従う。
```

### 共有アセットの参照（`{assets}/`）

Agent / パッケージが共有するテンプレートや雛形を SKILL から読む必要がある場合は、次に従う。

* 本文・手順・関連リンクでは、インストール先の絶対的な 1 パスを直書きしない
* 代わりにメタ変数 `{assets}/...` で参照する（例: `{assets}/coding/requirements.md`）
* `{assets}/` を使う場合は、本文に `## アセットディレクトリ` を置き、**解決候補ディレクトリの一覧**を箇条書きする（正本）
* 使わない SKILL では `## アセットディレクトリ` をセクションごと省略する
* 新規・改訂では `metadata.assets` に寄せない（旧文書の互換読みは `workspace-resolve-agent-assets` が担う）

#### `## アセットディレクトリ` の書き方

* 各行はディレクトリパス（ファイルパスではない）
* **文書相対**（この `SKILL.md` から）または **リポジトリルート相対**
* 開発時（ソース相対）と install 後（`apm_modules/...` 等のルート相対）の両方を並べると、展開先でも解決しやすい
* Markdown リンク `[label](path)` 形式でもよい（`path` をディレクトリとして使う）
* SKILL 改訂・新規ドラフトを提案するとき、本文に `{assets}/` が出るなら **同じ成果物に** `## アセットディレクトリ` ブロックを必ず含める（後回しにしない）
* 見出し位置は、手順・実行の **前**（導入の直後〜入力の前）がよい。末尾にだけ置くと読み手が探索先を見落とす
* install 後パスの例に書く package 名は、**その SKILL が属する package**（またはその許可された依存）に合わせる

```markdown
## アセットディレクトリ

* `../../assets/`
* `apm_modules/**/agent-creator/.apm/assets/`
```

本文での参照例:

```markdown
* `{assets}/coding/requirements.md`（要件定義フォーマット）をロードする
```

#### DO NOT（アセット）

* `{assets}/` 参照だけ書いて探索先セクションを省略する
* `metadata.assets` だけを正本にする
* 壊れた `../{assets}/file.md` 形式のリンクを残す
* アセット不要な SKILL に空の `## アセットディレクトリ` を足す

#### 実行時のパス解決

`{assets}/...` を実ファイルパスへ落とすときは、必ず `workspace-resolve-agent-assets` に従う。

* 基準ファイルは `{assets}/` が書かれている `SKILL.md`（またはその文書）自身
* 候補は `## アセットディレクトリ`（無ければ互換の `metadata.assets`）から読む
* 各候補について文書相対・ワークスペースルート相対の両方を試し、存在するヒットを使う
* 候補ディレクトリとサフィックスを結合する（ディレクトリ一覧だけでは実ファイルにならない）
* ヒットが 0 件なら推測読みしない

通常の `path/to/file`・Markdown リンク・`.ai-agent/` の解決は `workspace-resolve-file-path` の範囲であり、`{assets}/` とは混ぜない。

### APM パッケージ依存に沿った参照

SKILL 改善用ワークスペースでは複数 package が並列に見えることが多い。見えていることと、
導入者がその package 単体を入れたときに使えることは別である。参照は **編集対象 package の依存グラフ** に閉じる。

#### 正本

* 編集中の SKILL が属する package の `apm.yml`（`dependencies.apm`）を正本とする
* ワークスペースルートの `apm.yml` に兄弟 package が列挙されていても、編集中 package の宣言外なら許可しない
* `metadata.references` は install / 展開時に落ちうるため、依存の正本にも検査対象にもしない（本文の明示参照を見る）

#### 許可する参照

* **同一 package 内**の SKILL / command 同士（例: `agentic-workspace` 内の `workspace-layout` ↔ `workspace-agent-temporary`）
* 自 package の `dependencies.apm` から到達する package（**推移的依存を含む**）が提供する SKILL / command
* 上記許可範囲内の package パス（ソース相対・`apm_modules/...` 等）

#### 禁止する参照（未宣言・逆依存）

* `dependencies.apm` で到達しない package の SKILL / command を本文で明示参照すること
* 依存の **逆向き**: package A が B に依存しているとき、B 側の SKILL / command 本文が A の SKILL / command / パスを参照すること
  * 改善作業では A と B が同時に見えるため逆依存が混入しやすい。単体導入者は A を持たないことがある

#### 「依存」とみなす記述

次を依存参照として検査する。

* 本文での SKILL / command 名の **明示参照**（「〜に従う」「必ず使う」「〜をロードする」等。関連セクションの名前列挙も含む）
* 他 package パスの直書き（`packages/{other}/...`、`apm_modules/.../packages/{other}/...` など）

次は依存参照に数えない。

* `metadata.references`（削除されうる）
* README など SKILL / command / Sub Agent 本文以外の案内
* 一般ツール名（`dart` / `go` 等）や、自 package 内の相対パス（`../../assets/` など）

#### 未宣言だが必要になったとき

勝手に参照を残したり、勝手に `apm.yml` だけ書き換えたりしない。次の **両方** を提示し、ユーザーに選ばせる。

1. **依存を追加する**: 編集対象 package の `apm.yml` に当該 package を足し、そのうえで本文参照を残す
2. **参照を閉じる**: 本文から当該参照を削る、または同一 package 内に必要知識を閉じる（逆依存ならこちらを優先検討）

選択が得られるまで、未宣言参照・逆依存を含む完成稿を「確定成果物」として出さない。提案メモや差分草案に選択肢を明記するのはよい。

#### 点検手順

1. 編集対象 SKILL の所属 package を特定する（例: `packages/agentic-workspace/...` → `agentic-workspace`）
2. その package の `apm.yml` を読み、許可 package 集合を作る（自 package + 直接依存 + 推移）
3. 本文の明示 SKILL / command 名と、他 package パス直書きを列挙する
4. 各参照の所属 package を特定し、許可集合外・逆依存ならフラグする
5. フラグがあれば選択肢（依存追加 / 参照を閉じる）を提示し、ユーザー決定後に本文と必要なら `apm.yml` を揃える

#### DO（依存）

* 同一 package 内の委譲を本文に書く（例: `workspace-layout` が `workspace-agent-temporary` に配置判断を委譲）
* 依存先 package の SKILL を、依存方向に沿って参照する

#### DO NOT（依存）

* ワークスペースに見えているだけで、未宣言 package の SKILL 名を本文に残す
* 下位 package の SKILL に、上位（依存元）package の SKILL 名やパスを残す（逆依存）
* `metadata.references` だけ整えて本文の未宣言参照を放置する

## 適用手順（SKILL 作成・改訂時）

1. `license` / `metadata` はユーザー指定があるときだけ frontmatter に含める（無指定なら書かない・既定値で埋めない）
2. 手順に出すコマンド列を列挙する
3. 各コマンドからツールチェイン wrapper を剥がし、ツール本体だけ残す
4. 「このプロジェクトでは `mise exec --` が必須」のような **環境固有の断言** を SKILL 本文に書かない
5. 実行時の wrapper が必要なら、上記の汎用一文に留めるか、実行 Agent が `AGENTS.md` を読む前提にする
6. 共有アセットが必要なら、本文参照を `{assets}/...` にし、`## アセットディレクトリ` に解決候補を列挙する
7. 実行時に `{assets}/` を読む手順があるなら、`workspace-resolve-agent-assets` で解決する旨を手順または関連に残す
8. 所属 package の `apm.yml` を読み、本文の SKILL / command 明示参照と他 package パスが許可集合内か点検する
9. 未宣言・逆依存があれば、依存追加か参照を閉じるかをユーザーに選ばせる（確定前に勝手に決めない）
10. 例示は DO / DO NOT が対になるようにすると読み手が迷いにくい

### 自己レビュー（追加）

* [ ] `license` / `metadata` はユーザー指定時のみ（無指定の既定埋め込みが無い）
* [ ] コマンド例に `mise` / `fvm` / `asdf` 等の wrapper が無い
* [ ] `{assets}/` を使う場合: `## アセットディレクトリ` に探索先が列挙されている（使わないならセクション無し）
* [ ] `{assets}/` がある成果物に、文書相対と（可能なら）install 後ルート相対の両方がある
* [ ] `{assets}/` の実行時解決が `workspace-resolve-agent-assets` 前提になっている（必要な場合）
* [ ] 旧 `metadata.assets` だけを正本にしていない
* [ ] 本文の他 SKILL / command 明示参照が、所属 package の `apm.yml` 許可集合内（同一 package・直接・推移）である
* [ ] 他 package パス直書きが許可集合外・逆依存になっていない
* [ ] 未宣言・逆依存を見つけたとき、依存追加と参照クローズの両方を提示済み（ユーザー未選択のまま確定していない）

## 境界

* **本 SKILL の対象**: SKILL・手順ドキュメントに載せるコマンドの **記述**、共有アセット参照の **書き方**、および APM package 依存に沿った **参照の整合**
* **対象外**: いま開いているシェルで何を打つか（それは各リポジトリの実行規約）
* **対象外**: `{assets}/` 解決アルゴリズム本体（それは `workspace-resolve-agent-assets`）
* **対象外**: README 等の package 案内文（必要なら別途整える。本ルールの検査対象は SKILL / command / Sub Agent 本文）
* CI ワークフロー（`.github/workflows`）は実行環境そのものなので、そこでの `mise` 利用は本ルールの対象外。ただし「SKILL から CI を説明する」場合のコマンド例は portable に保つ

## やってはいけないこと

* ユーザー指定なしに `license` や `metadata.author` を既定値で埋め込むこと
* 「この HQ / このリポジトリでは常に `mise exec --`」を SKILL の必須手順として固定すること
* コマンド例だけ portable にして、説明文で特定 wrapper を必須と書くこと（実質同じ漏れ）
* portable 化のために、ツール本体のサブコマンドやフラグまで省略すること（`dart -h` の `-h` は残す）
* 共有アセットへの参照を、install 先の 1 パス直書きや壊れた `../{assets}/...` リンクにすること
* `{assets}/` をリテラルなフォルダ名として探索し、`workspace-resolve-agent-assets` を飛ばすこと
* ワークスペースに見えている未宣言 package への参照を、確認なしで本文に残すこと
* 依存の逆向き参照を「同じリポジトリだから」で許容すること

## 関連

* SKILL 本体の作成フロー: `skill-creator`
* `{assets}/` の実体解決: `workspace-resolve-agent-assets`
* slash-command 側の同種ルール: `tool-command-creator`
* Sub Agent 側の同種ルール: `tool-sub-agent-creator`
