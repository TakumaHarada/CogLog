---
name: flutter-layered-architecture-code-search
description: >-
  Flutter Layered Architecture リポジトリで、機能・レイヤー・package・ソースの所在を
  調査し、ファイルツリー付きレポートを出す SKILL。ルート `pubspec.yaml` の `workspace:`、
  1クラス1ファイル前提での探索、「〇〇機能のコードどこ？」「usecase / screen / repository の配置」、
  「関連 package 一覧」「TODO/FIXME の洗い出し」では必ず使う。
  Markdown 見出しだけの docs 探索は markdown-search、ドキュメント内パスの解決だけは
  workspace-resolve-file-path、画面 MVVM／設計の新規作成は flutter-layered-architecture-screen-mvvm /
  design、コーディング規約のみ・アプリ起動デバッグのみでは使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Flutter / コード検索（Layered Architecture）

レイヤードアーキテクチャ前提のリポジトリで、指定機能・レイヤーに関する **コードと関連ドキュメントの所在** を調べ、決まった型のレポートにまとめる。
ワークスペース全体の慣習は `flutter-layered-architecture-workspace` と併用してよい。

## いつ使うか

* 「この機能の package / 画面 / usecase はどこ？」
* アーキテクチャレイヤー（data / domain / usecase / screen 等）単位の配置調査
* 関連ソースのツリー一覧、TODO/FIXME、コメント上の留意点の収集

## いつ使わないか

* Markdown の見出し TOC だけで docs を読む → `markdown-search`
* 文書中の `path/to/file` を実パスに解決するだけ → `workspace-resolve-file-path`
* 新規に画面 MVVM やレイヤー設計を書く → 該当 `flutter-layered-architecture-*`
* Dart の言語規約だけの修正 → `flutter-coding-rules`

## 入力の解釈

プロンプトから調査対象を特定する。例:

* リポジトリ内の機能名（画面名・ドメイン語）
* アーキテクチャレイヤー
* package 名
* 具体的なクラス / ファイル

曖昧なら、見つかった候補を列挙してから深掘りする。

## 調査手順

1. ルート `pubspec.yaml` の `workspace:` からローカル package 一覧を把握する
2. 必要なら `flutter-layered-architecture-workspace` / `design` 等でレイヤー慣習を確認する
3. 機能名・レイヤー名から候補 package を絞る（パス断片・package 名の一致）
4. 候補配下を探索し、ツリー・要点・TODO/FIXME・コメント留意点を集める
5. [assets/report.md](./assets/report.md) のテンプレートで報告する

## 探索のヒント

### workspace が地図になる

```yaml
workspace:
  - app
  - packages/data/database
  # ローカル package が列挙されている
```

* ルートの `workspace:` が一次の地図である
* レイヤー／機能の命名規則（例: `…/usecase/…`, `…/screen/…`）はリポジトリごとに違う。実在パスに合わせる

### 1クラス1ファイル

* 基本は 1 ファイル 1 クラスのため、**ファイル名の列挙で責務を推測**できる
* レポートのソース引用は関連部分だけに絞る（出力量の最適化）

## 報告

* 出力は [assets/report.md](./assets/report.md) に従う
* ファイルツリーは実在パスで書く（想像のディレクトリを作らない）
* コード引用は省略記号で前後を落とし、根拠となる断片だけ示す

## ナレッジベース

### DO: まず workspace、次にレイヤー推測

* 全ディスクを無秩序に grep する前に、`workspace:` と命名規則で候補を絞る

### DO: 発見有無を明示する

* 見つからない場合も「無し」と書き、探した範囲を短く残す

### DO NOT: 存在しないパスをツリーに足す

* 推測配置は文章で述べ、ツリーには確認できたパスだけを載せる
