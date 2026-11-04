---
name: flutter-maintenance-check-latest-version
description: >-
  Flutter SDK（エンジン／フレームワーク）自体の最新・対象バージョン調査用 SKILL。
  `gh` で flutter/flutter の tag 一覧、master の CHANGELOG.md、ローカル `flutter --version`
  との差分確認を行う。「Flutter の最新版」「3.x に上げたい」「Stable の変更点」「今の SDK と最新の差」
  では必ず使う。 pub パッケージの outdated／dependency_overrides 更新は
  flutter-layered-architecture-library-update、アプリ起動・DTD デバッグは flutter-app-debug、
  Dart コーディング規約のみ、Go／Firebase 調査のみでは使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Flutter / 最新バージョン調査

Flutter **SDK**（`flutter/flutter`）のリリース済みバージョンと変更点を調べ、現在のローカル SDK との差を把握する。
Dart / pub 依存の更新手順そのものは対象外である（隣接 SKILL へ委ねる）。
コマンド例はツール本体（`flutter` / `gh`）で示す。`mise` / `fvm` 等のラッパーはリポジトリの AGENTS.md やローカル規約に任せ、本 SKILL には埋め込まない。

## いつ使うか

* Stable 等の最新 Flutter SDK バージョンを知りたいとき
* メジャー／マイナー（例: `3.x`）に絞った候補一覧が欲しいとき
* 現在の `flutter --version` と対象バージョンの CHANGELOG 差分を要約したいとき

## いつ使わないか

* `flutter pub outdated` や `dependency_overrides` の更新 → `flutter-layered-architecture-library-update`
* アプリ起動・ランタイムデバッグ → `flutter-app-debug`
* 文言／L10n → `flutter-monolith-localization`

## 手順概要

1. ローカルの現在バージョンを把握する
2. `flutter/flutter` の tag からリリース済み候補を列挙する（必要ならメジャーで絞る）
3. `CHANGELOG.md`（`master`）から対象バージョンの変更サマリを取る
4. [assets/report.md](./assets/report.md) の型で報告する

## 1. 現在バージョン

```bash
flutter --version
```

* Framework / Channel / リビジョンを控える
* ユーザーが「今のバージョン」を既に示していればそれを優先してよい

## 2. リリース済みバージョン一覧（tags）

出典: [flutter/flutter](https://github.com/flutter/flutter)

```bash
# 一覧
gh api repos/flutter/flutter/tags --paginate --jq '.[].name'

# 例: 3.x に絞る
gh api repos/flutter/flutter/tags --paginate --jq '.[].name' | rg '^3\.'
```

* tag 名がリリース済みバージョンの一次情報である
* 必要に応じて `rg` でメジャー／プレフィックスを絞る
* 最新候補を提示するときは、プレリリース風の tag と Stable 向けの差分に注意する（ユーザーのチャネル要求を優先）

## 3. 変更サマリ（CHANGELOG）

* [CHANGELOG.md](https://github.com/flutter/flutter/blob/master/CHANGELOG.md) を `master` から取得する
  * Stable の直近リリース済み情報は、通常これで足りる
  * 各バージョンのブランチを個別に取る必要はない（特別な要求が無い限り）

```bash
gh api repos/flutter/flutter/contents/CHANGELOG.md?ref=master \
  --jq '.content' | base64 --decode
```

* 現在バージョンから対象バージョンまでの見出しを抜き出す
* 報告本文は次節のテンプレートに従い、要約で削らず翻訳して伝える

## 4. 報告の型

報告は [assets/report.md](./assets/report.md) をテンプレートとして埋めて出力する。

1. テンプレートを読む（またはコピーする）
2. `{major}.{minor}.{patch}` を実バージョンに置き換える
   * 最新バージョン: 調査で選んだ候補（例: 指定メジャー内の最新 / Stable 最新）
   * ローカルバージョン: `flutter --version`（またはユーザー提示値）
3. `## CHANGELOG` 以下に、ローカル版の次から最新版までを **1 バージョンずつ** `###` 見出しで並べる
4. 各バージョンの本文は CHANGELOG の内容を省略せず、必要なら日本語へ翻訳する（意訳で削らない。翻訳のみ）
5. プレースホルダの空 `###` や HTML コメントは、埋めたあと残さない

チャネルや未確認事項（ネットワーク失敗・抜粋外の版など）がある場合は、テンプレート末尾に短い注記として足してよい。

## ナレッジベース

### DO: SDK と pub 依存を混ぜない

* 本 SKILL は Flutter SDK の版調査である
* パッケージ更新は `flutter pub outdated` 系の SKILL に回す

### DO: tag + CHANGELOG をセットで見る

* tag だけで「何が変わったか」は分からない
* CHANGELOG だけで「存在する版か」を断定しない（tag と突き合わせる）

### DO: 報告は assets/report.md に合わせる

* 最新／ローカル版と、差分 CHANGELOG（1 バージョンずつ・翻訳）をテンプレートどおりに出す
* 調査メモ用の自由形式レポートに逸れない

### DO NOT: 勝手に SDK をアップグレードする

* 調査結果の提示が主目的である
* 実際の `flutter upgrade` / チャネル切替は、ユーザーが明示したときだけ行う
