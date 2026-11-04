# ローカライゼーション (Localization)

## 概要

`monolith` フレームワークを使用した、アプリケーションの多言語対応（ローカライゼーション）について解説する。

* 内部的には Flutter 標準の `*.arb` ファイル生成を利用する
* 開発者は `strings.csv` を管理するだけでよい
* コード生成により型安全なアクセサ（`L10nStringsMixin`）が提供される

## 仕組み

1. 各パッケージの `res/strings.csv` に翻訳データを定義する。
2. `dart run monolith_runner:localization` コマンドを実行する。
3. 全パッケージの CSV が集約され、Flutter 標準の `*.arb` ファイルが生成される（出力先: `localization.app.package_name`。現行は `app_runner`）。
4. 同時に、各パッケージに `lib/gen/strings.dart` が生成され、型安全なアクセサ (`L10nStringsMixin`) が提供される。
5. 出力先 package（`app_runner`）の `flutter: generate: true` により `l10n.dart` 等が生成され、`L10nHelper` も同ディレクトリに出力される。

## 実装手順

### 1. strings.csv の作成

各パッケージの `res/strings.csv` に、以下のフォーマットで記述する。

* **ファイルパス**: `<package>/res/strings.csv`（リポジトリの package 配置に従う）
* **フォーマット**: CSV形式
* **ヘッダー**: `id,ja,description` (必要に応じて他の言語コードを追加可能だが、現状は `ja` が主)

**Example:**

```csv
id,ja,description
ok,OK,肯定的なアクション
cancel,キャンセル,否定的なアクション
error_message_network,通信エラーが発生しました,ネットワークエラー時のメッセージ
```

#### IDの命名についての補足

* `id` はpackage名がprefixとして自動的に付与されるため、package間で競合することはない
  * 例: `example_lib_package` という名前のpackageに `ok` というIDで登録した場合 -> `example_lib_package_ok` がキーに使用される

### 2. コード生成

以下のコマンドを実行し、リソースファイルとアクセサを生成する。

```bash
dart run monolith_runner:localization
```

### 3. strings.dart の実装

各パッケージの `lib/src/strings.dart` (または適切な場所) に、アクセサクラスを実装する。
生成された `L10nStringsMixin` を mixin することで、定義した文字列にアクセスできる。

**Example:** `lib/src/strings.dart`（パッケージ名はプロジェクトに合わせる）

```dart
import 'package:meta/meta.dart';
// 生成されたファイルを import
import 'package:screen_feature_home2/gen/strings.dart';

/// パッケージ内部でのみ使用する文字列リソースへのアクセサ
final class _Strings with L10nStringsMixin {}

/// 文字列リソースへのアクセスを提供するインスタンス
@internal
final strings = _Strings();
```

### 4. 利用方法

実装した `strings` オブジェクトを通じて、プロパティとして文字列にアクセスする。
プロパティ名は、自動的に `パッケージ名_ID` の形式で生成される（名前空間の衝突を防ぐため）。

```dart
import 'package:screen_feature_home2/src/strings.dart';

void main() {
    // パッケージ名がプレフィックスとして付与される
    // id: tab_kanji_practice -> screen_feature_home2_tab_kanji_practice
    print(strings.screen_feature_home2_tab_kanji_practice); 
}
```

## 複数パッケージのリソース統合

* 共通リソース（`foundation_resources` など）を利用したい場合は、複数の Mixin を適用する。

```dart
// NOTE. 明示的にexportしていない場合でも、文字列リソースのimportは認める
import 'package:foundation_resources/gen/strings.dart' as foundation_resources;
import 'package:meta/meta.dart';
import 'package:screen_feature_settings2/gen/strings.dart';

// 自身のパッケージのリソースと、共通リソースを mixin
class _Strings with L10nStringsMixin, foundation_resources.L10nStringsMixin {}

// exportせず、各packageごとに作成する
@internal
final strings = _Strings();
```

## 実装上の注意

* 基本的に各packageには `monolith` `monolith_localization` 等の各ライブラリは不要であり、生成されるコードからは `monolith_localization_runtime` packageのみを必要としている
* `dev_dependencies:` に追加するのは、dart workspaceの `ルートのpackageのみ` で良い
* `strings.dart` はexportしてはならず、各packageごとで作成する

## Unit Test / Widget Preview 用 StringsTestHelper

### StringsTestHelperの概要

`monolith.yaml` の `localization.test_helper` を設定すると、生成済み ARB を Base64 埋め込みした Dart ヘルパーが出力される。
Unit Test・Widget Preview・Golden Test では、ファイル I/O なしに `LocalizeStringDelegate.injectDelegateForTest` へ渡せる。

### monolith.yaml 設定

`test_helper` は省略可能である。省略時はヘルパーを生成しない。

```yaml
localization:
  languages:
    - ja
  # optional, default: omit
  test_helper:
    package_name: foundation_resources          # required
    test_helper_class_name: StringsTestHelper   # optional, default: StringsTestHelper
    test_helper_path: lib/gen/strings_test_helper.dart  # optional
```

### 生成と出力先

`dart run monolith_runner:localization` 実行時、ARB 生成直後に次が出力される。

```text
${package_name}/${test_helper_path}
# 例: foundation_resources/lib/gen/strings_test_helper.dart
```

* `languages` の各言語について getter が生成される（例: `StringsTestHelper.ja`）
* リリースモードでは getter 呼び出し時に `UnsupportedError` を投げる

### 利用例

Widget Preview:

```dart
// view_designkit, widget_preview_functions.dart
LocalizeStringDelegate.injectDelegateForTest(
  arbJson: StringsTestHelper.ja,
);
```

Golden Test:

```dart
// testing_golden, golden_localization.dart
Future<void> injectGoldenTestLocalization() async {
  return LocalizeStringDelegate.injectDelegateForTest(
    arbJson: StringsTestHelper.ja,
  );
}
```

## ナレッジベース

### DO: 文言変更は res/strings.csv のみで行う

* CSV を単一の真実源とし、生成物を手編集しない
* 変更後は `dart run monolith_runner:localization` で再生成する

```csv
id,ja,description
ok,OK,肯定的なアクション
```

### DO: Test / Preview では StringsTestHelper で注入する

* `LocalizeStringDelegate.injectDelegateForTest(arbJson: StringsTestHelper.ja)` を使う
* ARB ファイルの直読みを避ける

```dart
// testing_golden, golden_localization.dart
LocalizeStringDelegate.injectDelegateForTest(
  arbJson: StringsTestHelper.ja,
);
```

### DO: strings.dart は各 package で作成し export しない

* 生成された `L10nStringsMixin` を mixin した `@internal` な `strings` を置く
* 共通リソースが必要な場合は複数 Mixin を適用する

```dart
@internal
final strings = _Strings();
```

### DO NOT: 生成された strings.dart / strings_test_helper.dart を手編集する

* 理由: localization 再実行で上書きされる
* 理由: 手編集内容が失われ不整合の原因になる

```dart
// DO NOT: gen/strings.dart を直接編集する
```

```dart
// DO: res/strings.csv を編集しコード生成を再実行する
dart run monolith_runner:localization
```

### DO NOT: リリースコードから StringsTestHelper を利用する

* 理由: テスト用途のヘルパーである
* 理由: リリースモードでは `UnsupportedError` となる

```dart
// DO NOT: 本番画面から StringsTestHelper.ja を参照する
```

```dart
// DO: 本番は L10nStringsMixin 経由の strings アクセサを使う
print(strings.screen_feature_home2_tab_kanji_practice);
```

## 参考リンク

* Flutter internationalization: <https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization>
