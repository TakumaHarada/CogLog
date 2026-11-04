---
name: flutter-app-debug
description: >-
  Flutter アプリの実機／エミュ起動・DTD アタッチ・ランタイムデバッグ用 SKILL。 launch.json 読取、`flutter devices` /
  `flutter run --print-dtd`、 Dart MCP（DTD）での
  get_runtime_errors / widget_inspector / hot_reload / hot_restart / flutter_driver、
  「アプリ起動」「デバイスで動かす」「クラッシュ確認」「Widget ツリー」「DTD / ws:// に繋ぐ」「自律デバッグ」では必ず使う。 VM Service の
  http:// と DTD の ws:// を混同しないこと。 Maestro の黒箱 UI テスト、Dart コーディング規約だけの実装、画面
  MVVM／レイヤー設計のみ、golden／静的解析のみの作業では使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Flutter / アプリデバッグ・起動、アタッチ

起動構成とデバイスを確定し、`flutter run --print-dtd` で起動したうえで Dart MCP（DTD）から内部状態を検査・操作する。
黒箱の画面操作フローは Maestro MCP 側であり、本 SKILL と混同しない。

## いつ使うか

* 実機 / シミュレータでアプリを起動して確認したいとき
* ランタイムエラー、Widget ツリー、ホットリロードでデバッグしたいとき
* 既に起動中のアプリへ DTD アタッチしたいとき

## 手順概要

1. `launch.json` から起動構成を読む
2. デバイスを1つに確定する
3. `flutter run --print-dtd` で起動する（または既存 DTD にアタッチ）
4. Dart MCP の `dtd` で接続し、目的の検査・操作を行う

コマンド実行時は、プロジェクト規定のツールチェイン（あれば）に従う。

## Flutter の起動構成の把握

* `.vscode/launch.json` を読む
* `type` が `dart` かつ `request` が `launch` の構成を起動構成とする
  * `flutterMode` があればそれを実行モード（`debug` / `profile` / `release`）とする
  * 無ければ `debug`
* `cwd` / `program` / `args` / `deviceId` を引き継ぐ
  * `args` の `--flavor` や `--dart-define-from-file` 等は省略しない

## 起動対象の把握

```bash
flutter devices
```

* 文脈・プロンプトからデバイスを決める
  * 1台だけならそれを使う
  * launch 構成の `deviceId` があれば優先
* 対象は常に **1つ**
  * 判別不能なら次を出して中断する

```markdown
起動対象のデバイスを確定できませんでした。
対象デバイスを指定してください。
```

## 実行

### アプリを起動する

* Dart MCP に起動ツールが無い／無効な場合はシェルの `flutter run` を使う
* `--print-dtd` は必須（後続の MCP 接続用）
* `cwd` を作業ディレクトリにし、`program` と `args` を引き継ぐ
* `profile` / `release` ならそれぞれ `--profile` / `--release` を付ける

```bash
flutter run -d ${deviceId} --print-dtd ${modeFlags} ${program} ${args}
```

* ログの **DTD URI**（`ws://...`）を控える
  * `http://...` の VM Service URI は DTD ではない。混同しない

### 起動中のアプリにアタッチする

#### DTD URI を取得する

次の順で確定する。

1. 直前の `flutter run --print-dtd` 出力
2. プロンプトやユーザー指示
3. Dart MCP の `dtd`（`listDtdUris`）
   * working dir がホームに見える DTD は IDE 起動アプリ候補として優先してよい

不明なら次を出して終了する。

```markdown
DTD URIが認識できませんでした。
DTD URIを指定してください。

例: `ws://127.0.0.1:63514/...`
```

#### DTD に接続する

* Dart MCP の `dtd` で `connect`（必要なら先にツールスキーマを確認する）
* `listConnectedApps` で接続済みを確認してよい
* 複数アプリがある場合は操作対象の `appUri` を明示する

#### アプリを制御・検証する

| ツール | 用途 |
| --- | --- |
| `get_runtime_errors` | ランタイムエラー確認 |
| `widget_inspector` | Widget ツリー・選択状態 |
| `flutter_driver_command` | タップ・入力・スクショ等 |
| `hot_reload` / `hot_restart` | 変更反映 |

* `flutter_driver_command` の前に `widget_inspector`（`get_widget_tree`）で実在 Widget を確認し、推測セレクタを作らない
* **Dart MCP**: Flutter 内部の状態・エラー・Widget
* **Maestro MCP**: 端末上の黒箱 UI 操作（本 SKILL と用途を混ぜない）

## ナレッジベース

### DO: プロジェクト規定のツールチェインに従う

* リポジトリにツールチェイン規定があればそれに従い、コマンド例はツール本体（例: `flutter ...`）として読む
