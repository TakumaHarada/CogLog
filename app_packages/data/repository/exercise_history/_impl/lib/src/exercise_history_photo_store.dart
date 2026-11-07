import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

/// Documents 配下にメーターパネル写真を置く。
///
/// Example:
/// ```dart
/// ExerciseHistoryPhotoStore(Directory.systemTemp);
/// ```
final class ExerciseHistoryPhotoStore {
  /// [documentsRoot] を写真の根とする。
  ///
  /// Example:
  /// ```dart
  /// ExerciseHistoryPhotoStore(Directory.systemTemp);
  /// ```
  ExerciseHistoryPhotoStore(this.documentsRoot);

  /// アプリ Documents ディレクトリ。
  final Directory documentsRoot;

  static final _uuid = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  /// 相対パスを返す。
  ///
  /// Example:
  /// ```dart
  /// ExerciseHistoryPhotoStore(Directory.systemTemp)
  ///     .relativePathFor('11111111-1111-4111-8111-111111111111');
  /// ```
  String relativePathFor(String id) {
    _assertId(id);
    return p.join('exercise_histories', id, 'meter.jpg');
  }

  /// 絶対パスのファイルを返す。
  ///
  /// Example:
  /// ```dart
  /// ExerciseHistoryPhotoStore(Directory.systemTemp)
  ///     .fileFor('11111111-1111-4111-8111-111111111111');
  /// ```
  File fileFor(String id) {
    final relative = relativePathFor(id);
    return File(p.join(documentsRoot.path, relative));
  }

  /// 写真を書き、相対パスを返す。
  ///
  /// Example:
  /// ```dart
  /// await ExerciseHistoryPhotoStore(Directory.systemTemp).write(
  ///   '11111111-1111-4111-8111-111111111111',
  ///   Uint8List.fromList([1]),
  /// );
  /// ```
  Future<String> write(String id, Uint8List bytes) async {
    final file = fileFor(id);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return relativePathFor(id);
  }

  /// 運動履歴 ID に対応する写真ディレクトリを消す。
  ///
  /// Example:
  /// ```dart
  /// await ExerciseHistoryPhotoStore(Directory.systemTemp)
  ///     .deleteFor('11111111-1111-4111-8111-111111111111');
  /// ```
  Future<void> deleteFor(String id) async {
    _assertId(id);
    final dir = Directory(p.join(documentsRoot.path, 'exercise_histories', id));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  void _assertId(String id) {
    if (!_uuid.hasMatch(id)) {
      throw ArgumentError.value(id, 'id', 'UUID 形式である必要がある');
    }
  }
}
