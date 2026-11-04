# コーディング中のエラー修正

## 概要

本ドキュメントは、Dart / Flutter のコーディング中に発生した警告・解析エラーを修正する手順を定義する。

* まず `dart fix --apply` による自動修正を試みる。
* 自動修正できない場合に限り、`dart analyze` で問題点を抽出し個別対応する。
* コーディング後は `dart format` でフォーマットを適用する。

## `dart fix --apply` による自動修正

コーディング中に発生した警告は、dart コマンドによる自動修復を試みる。

### dart fix の補足

analyzer が提案する修正のうち、機械的に適用可能なものは `dart fix --apply` で一括反映できる。手動修正の前に自動修正を優先する。

### dart fix の実装例

```bash
# analyzerの案内に従い、修復を行う
dart fix --apply path/to/directory-or-file
```

## `dart analyze` による問題点抽出

`dart fix` コマンドで自動修復が行えない場合に限り、analyze を実行して問題点を個別対応する。

### dart analyze の補足

自動修正不能な警告や info は、fatal 扱いで一覧化し、意図を確認したうえで手動修正する。

### dart analyze の実装例

```bash
dart analyze --fatal-infos --fatal-warnings
```

## `dart format` による自動フォーマット

コーディング後は、`dart format` コマンドを使用して自動的にフォーマッタを適用する。

### dart format の補足

スタイル差分を人手で直す前に、公式フォーマッタで整形を揃える。

### dart format の実装例

```bash
dart format path/to/directory-or-file
```

## ナレッジベース

### DO: 警告修正の第一手段として `dart fix --apply` を使う

* analyzer の案内に従い、自動修復を先に試みる。

```bash
dart fix --apply path/to/directory-or-file
```

### DO: 自動修復不能時のみ `dart analyze` で個別対応する

* `dart fix` で直せない問題点を抽出し、手動で対応する。

```bash
dart analyze --fatal-infos --fatal-warnings
```

### DO: コーディング後に `dart format` を適用する

* フォーマット差分を公式ツールで揃える。

```bash
dart format path/to/directory-or-file
```

### DO NOT: 自動修正を試さずに手作業だけで警告を直す

* 理由: 機械適用可能な修正を見落とすと、修正漏れやスタイル差分が増える。
