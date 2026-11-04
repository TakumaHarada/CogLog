// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

final class Defines {
  const Defines._();
  static String get FLAVOR {
    return _get('FLAVOR') ?? const String.fromEnvironment('FLAVOR');
  }

  /// Overrides dart-define values at test time.
  /// Use this to inject values directly when `--dart-define` cannot be used
  /// freely, such as Integration Tests (e.g. under VS Code).
  ///
  /// [defines] is a map of keys to values. Existing keys are overwritten;
  /// unregistered keys are added.
  ///
  /// Example:
  /// ```dart
  /// Defines.override({
  ///   "EXAMPLE_KEY_FOR_TESTING": "true",
  /// });
  /// ```
  @visibleForTesting
  static void override(Map<String, String> defines) {
    _defineList.addAll(defines);
  }

  /// ワークスペースディレクトリを検索する.
  static Directory _getWorkspace() {
    var result = Directory.current;

    /// 'secrets/dart-define/test.json'が存在するディレクトリまで遡る)
    while (true) {
      final rootFile = File('${result.path}/secrets/dart-define/test.json');
      if (rootFile.existsSync()) {
        return result;
      }

      // 一つ上に戻る
      result = result.parent;
    }
  }

  static final _defineList = <String, String>{};

  static void _ensureInitialized() {
    if (!_isFlutterTesting || _defineList.isNotEmpty) {
      return;
    }

    /// ワークスペースディレクトリを取得
    final workspace = _getWorkspace();
    final definesJson = File('${workspace.path}/secrets/dart-define/test.json')
        .readAsStringSync();
    final json = jsonDecode(definesJson) as Map<String, dynamic>;
    for (final kv in json.entries) {
      _defineList[kv.key] = kv.value as String;
    }
  }

  static String? _get(String key) {
    /// 上書きされた値があればそれを返す
    final value = _defineList[key];
    if (value != null) {
      return value;
    }

    if (_isFlutterTesting) {
      _ensureInitialized();
      return _defineList[key];
    } else {
      return null;
    }
  }

  static bool get _isFlutterTesting {
    return !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');
  }
}
