import 'package:app/src/strings.dart';
import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';

/// セットアップ確認用のカウンター。
///
/// ボタンを押すたびに表示中の回数を 1 増やす。
class Example extends StatefulWidget {
  /// カウンター画面を作る。
  const Example({super.key});

  /// 回数を保持する状態を作る。
  ///
  /// Example:
  /// ```dart
  /// const Example();
  /// ```
  @override
  State<Example> createState() => _ExampleState();
}

/// [Example] の現在回数。
class _ExampleState extends State<Example> {
  /// ボタンを押した回数。
  int _count = 0;

  /// アプリ名をヘッダーに置き、回数と増やすボタンを中央に置く。
  ///
  /// 文言はローカライゼーションのロード後に解決する。
  ///
  /// Example:
  /// ```dart
  /// const Example();
  /// ```
  @override
  Widget build(BuildContext context) => FScaffold(
    header: FHeader(title: Text(strings.foundation_resources_app_name)),
    child: Center(
      child: Column(
        mainAxisSize: .min,
        spacing: 10,
        children: [
          Text(strings.app_count(count: '$_count')),
          FButton(
            onPress: () => setState(() => _count++),
            suffix: const Icon(FLucideIcons.chevronsUp),
            child: Text(strings.app_increase),
          ),
        ],
      ),
    ),
  );
}
