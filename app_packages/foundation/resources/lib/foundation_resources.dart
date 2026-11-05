/// 複数パッケージで共有する文字列リソース。
///
/// 文言の真実源は `res/strings.csv`。パッケージ内では `src/strings.dart` の
/// `strings` から読む。テスト用の ARB は生成された [StringsTestHelper] を使う。
///
/// Example:
/// ```dart
/// await LocalizeStringDelegate.injectDelegateForTest(
///   arbJson: StringsTestHelper.ja,
/// );
/// ```
library;

export "gen/strings_test_helper.dart";
