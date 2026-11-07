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

  File _stagingFileFor(String id) => File('${fileFor(id).path}.staging');

  /// 最終パスへ原子的に書き、相対パスを返す。
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
    final temp = File('${file.path}.tmp');
    try {
      await file.parent.create(recursive: true);
      await temp.writeAsBytes(bytes, flush: true);
      await temp.rename(file.path);
    } catch (error, stack) {
      await _deleteIfExists(temp);
      Error.throwWithStackTrace(error, stack);
    }
    return relativePathFor(id);
  }

  /// 旧写真を残したまま、確定前の写真を書く。
  ///
  /// Example:
  /// ```dart
  /// await ExerciseHistoryPhotoStore(Directory.systemTemp).writeStaging(
  ///   '11111111-1111-4111-8111-111111111111',
  ///   Uint8List.fromList([1]),
  /// );
  /// ```
  Future<void> writeStaging(String id, Uint8List bytes) async {
    final staging = _stagingFileFor(id);
    final temp = File('${staging.path}.tmp');
    try {
      await staging.parent.create(recursive: true);
      await temp.writeAsBytes(bytes, flush: true);
      await temp.rename(staging.path);
    } catch (error, stack) {
      await _deleteIfExists(temp);
      await _deleteIfExists(staging);
      Error.throwWithStackTrace(error, stack);
    }
  }

  /// ステージング写真を最終パスへ確定する。
  ///
  /// Example:
  /// ```dart
  /// await ExerciseHistoryPhotoStore(Directory.systemTemp)
  ///     .commitStaging('11111111-1111-4111-8111-111111111111');
  /// ```
  Future<void> commitStaging(String id) async {
    final staging = _stagingFileFor(id);
    if (!await staging.exists()) {
      throw StateError('ステージング写真が無い: $id');
    }
    final file = fileFor(id);
    await file.parent.create(recursive: true);
    await staging.rename(file.path);
  }

  /// ステージング写真を捨てる。
  ///
  /// Example:
  /// ```dart
  /// await ExerciseHistoryPhotoStore(Directory.systemTemp)
  ///     .discardStaging('11111111-1111-4111-8111-111111111111');
  /// ```
  Future<void> discardStaging(String id) async {
    final staging = _stagingFileFor(id);
    final temp = File('${staging.path}.tmp');
    await _deleteIfExists(staging);
    await _deleteIfExists(temp);
  }

  Future<void> _deleteIfExists(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
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
