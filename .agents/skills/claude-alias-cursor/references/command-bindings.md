# Claude Code ↔ Cursor Agent CLI 対応表

出典:

* Claude Code: [CLI reference](https://code.claude.com/docs/en/cli-reference)
* Cursor Agent: `agent --help` / [Parameters](https://cursor.com/docs/cli/reference/parameters) / [Headless](https://cursor.com/docs/cli/headless)

記号:

* **✓** 実用上 1:1
* **≈** 近似（意味は近いが仕様差あり）
* **✗** バインディング不能

## エントリポイント

| 呼び方 | 対応 | メモ |
| --- | --- | --- |
| `agent …` | ✓ | Agent CLI 本体 |
| `cursor agent …` | ✓ | 同じ Agent CLI（`cursor` バイナリ経由）。ユーザーが「cursor コマンドを使え」と言った場合の推奨形 |
| `cursor`（サブコマンドなし） | ✗ | IDE 起動。Agent CLI ではない |

以降の表は `agent` で書く。先頭を `cursor agent` に置換してよい。

## コマンド

| Claude | Cursor `agent` | 対応 | メモ |
| --- | --- | --- | --- |
| `claude` | `agent` / `cursor agent` | ✓ | 対話開始 |
| `claude "query"` | `agent "query"` | ✓ | |
| `claude -p "query"` | `agent -p "query"` | ✓ | print / headless。非対話では `--trust` / `-f` を足すことが多い |
| `cat f \| claude -p "q"` | プロンプトにファイルパスを含める、または stdin 方針を明示 | ≈ | Cursor はパス参照＋ツール読取が推奨 |
| `claude -c` / `--continue` | `agent --continue` / `agent resume` | ✓ | |
| `claude -r <id>` / `--resume` | `agent --resume <id>` | ✓ | |
| `claude update` | `agent update` | ✓ | |
| `claude install` | `curl https://cursor.com/install -fsS \| bash` | ≈ | インストール経路が異なる |
| `claude auth login` | `agent login` | ✓ | |
| `claude auth logout` | `agent logout` | ✓ | |
| `claude auth status` | `agent status` / `whoami` | ✓ | 出力形式は異なる場合あり |
| `claude mcp` | `agent mcp` | ≈ | サブコマンド集合が異なる |
| `claude mcp login <id>` | `agent mcp login <id>` | ✓ | |
| `claude mcp logout <id>` | （明示サブコマンドなし）`agent mcp disable` 等を検討 | ≈ | 完全一致なし |
| `claude plugin` | `agent plugin` | ≈ | marketplace 体系が別 |
| `claude doctor` | `agent about` + `agent status` | ≈ | |
| `claude setup-token` | Dashboard API Key → `CURSOR_API_KEY` | ≈ | |
| `claude gateway` | — | ✗ | |
| `claude agents` / `attach` / `logs` / `stop` / `rm` / `respawn` / `daemon` | `agent ls` / `resume` / `create-chat` / Cloud / `worker` | ≈/✗ | 互換セッション管理ではない |
| `claude project purge` | — | ✗ | |
| `claude remote-control` | Cloud Agent / `agent worker` | ≈ | |
| `claude ultrareview` | レビュー用 `agent -p` または専用 SKILL | ≈ | |
| `claude auto-mode …` | `--auto-review` は別機能 | ✗/≈ | 同一視しない |

## 共通フラグ

| Claude | Cursor | 対応 | メモ |
| --- | --- | --- | --- |
| `-p` / `--print` | `-p` / `--print` | ✓ | |
| `--output-format` | `--output-format` | ✓ | `text` / `json` / `stream-json` |
| `--include-partial-messages` | `--stream-partial-output` | ≈ | 名前・イベント形は異なる |
| `--model` | `--model` | ✓ | ID 体系は別 |
| `--add-dir` | `--add-dir` | ✓ | |
| `--plugin-dir` | `--plugin-dir` | ✓ | |
| `-w` / `--worktree` | `-w` / `--worktree` | ✓ | 配置ディレクトリは製品ごとに異なる |
| `-v` / `--version` | `-v` / `--version` | ✓ | |
| `-h` / `--help` | `-h` / `--help` | ✓ | |
| `--dangerously-skip-permissions` | `-f` / `--force` / `--yolo` | ≈ | |
| （非対話 trust） | `--trust` | ≈ | Claude に同名なし。Workspace Trust Required 回避 |
| `--permission-mode plan` | `--mode plan` / `--plan` | ≈ | |
| （ask 相当） | `--mode ask` | ≈ | Cursor 固有の明示モード。分類・説明系 headless に有用 |
| `--verbose` | （同等の汎用フラグなし） | ✗ | stream-json 等で代替観察 |
| （cwd 指定） | `--workspace <path>` | ≈ | 無視される事例あり。`cd` 併用を検討 |
| `--json-schema` | — | ✗ | プロンプトでスキーマ要求 |
| `--max-budget-usd` | — | ✗ | |
| `--max-turns` | — | ✗ | |
| `--bare` / `--safe-mode` | — | ✗ | |
| `--system-prompt*` / `--append-system-prompt*` | — | ✗ | Rules / プロンプト本文 |
| `--allowedTools` / `--disallowedTools` / `--tools` | permissions 設定 | ≈ | |
| `--mcp-config` / `--strict-mcp-config` | `.cursor/mcp.json` 等 | ≈ | |
| `--chrome` | browser MCP / Maestro | ≈ | |
| `--cloud` / `--teleport` | Cloud Agent（`&`）等 | ≈ | |
| `--input-format` | — | ✗ | |
| `--fallback-model` | — | ✗ | |
| `--effort` / `--advisor` | モデル ID のパラメータ表記等 | ≈/✗ | Claude 固有 alias は使わない |
| `--no-session-persistence` | — | ✗ | |
| `--session-id` / `--name` | `agent create-chat` 等 | ≈ | |
| `--tmux` | — | ✗ | |

## 環境変数

| Claude | Cursor | 対応 |
| --- | --- | --- |
| `ANTHROPIC_API_KEY` | `CURSOR_API_KEY` | ✓（役割対応） |
| （各種 `CLAUDE_CODE_*`） | `CURSOR_API_ENDPOINT` 等 | ≈/✗ | 個別に要確認 |

## Cursor 側にあって Claude 置換元が無いもの（参考）

スクリプト作成時に使える Cursor 固有機能:

* `agent --list-models` / `agent models`
* `agent sandbox …`
* `agent worker …`
* `agent acp`
* `agent generate-rule`
* `agent create-chat`
* `agent --workspace`
* `agent --trust`（headless）
* `agent --approve-mcps`
* `CURSOR_AGENT_BIN`（ラッパースクリプト用。`cursor` ならサブコマンド `agent` を付ける）

## skill-creator 特記

| Claude 前提 | Cursor 側 |
| --- | --- |
| `claude -p` で Skill/Read 発火を stream-json 検知（`run_eval.py`） | イベント互換なし。`TRIGGER`/`SKIP` 分類や別スクリプトが必要 |
| `improve_description.py` / `run_loop.py` の `claude -p` | `cursor agent -p --mode ask --trust -f` 等 |
| `python -m scripts.run_loop` | 本 SKILL の [../scripts/trigger_opt_cursor.py](../scripts/trigger_opt_cursor.py) |
