# ローカライゼーション

文言の真実源は各パッケージの `res/strings.csv` である。対応言語は `ja` と `en`。ARB の優先ロケールは `ja`。

## CSV

ヘッダーは `id,ja,en,description`。

```csv
id,ja,en,description
increase,増やす,Increase,カウントを増やすボタン
```

- `id` にはパッケージ名を付けない。生成時に `<パッケージ名>_<id>` になる。
- 引数は `{name}` と書く。
- パッケージをまたいで同じ CSV の `id` を使ってよい。キーはパッケージ名で分かれる。

## 生成

ルートで実行する。

```bash
dart run monolith_runner:localization
```

生成されるもの:

- 各 CSV があるパッケージの `lib/gen/strings.dart`（`L10nStringsMixin`）
- `app/runner/lib/l10n/` の ARB、`l10n.dart`、`l10n_helper.dart`
- `foundation_resources` の `lib/gen/strings_test_helper.dart`

`lib/gen/strings.dart`、`strings_test_helper.dart`、`app/runner/lib/l10n/` は手で編集しない。文言を変えるときは CSV を変えて再生成する。

## 参照

パッケージ内では `lib/src/strings.dart` にアクセサを置く。

```dart
final class _Strings with L10nStringsMixin {}

@internal
final strings = _Strings();
```

他パッケージの文言が必要なら、そのパッケージの `lib/gen/strings.dart` を import し、`L10nStringsMixin` を追加で mixin する。`strings` 自体は export しない。

画面から文言を読むのは、`MaterialApp` の配下で `L10nHelper.delegate` がロードされたあとである。`MaterialApp` を組み立てる時点では読まない。

## テスト

Unit Test、Widget Preview、Golden Test では `StringsTestHelper` を使う。

```dart
await LocalizeStringDelegate.injectDelegateForTest(
  arbJson: StringsTestHelper.ja,
);
```

終了時は `LocalizeStringDelegate.resetDelegateForTest` を呼ぶ。リリースビルドから `StringsTestHelper` を呼ばない。
