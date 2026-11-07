import 'dart:io';

import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import 'app_database.dart';

/// Documents 配下の `coglog.sqlite` を開く。
///
/// OS バックアップ対象領域に置く。
///
/// Example:
/// ```dart
/// openDocumentsDatabase(Directory('/tmp'));
/// ```
AppDatabase openDocumentsDatabase(Directory documents) {
  final file = File(p.join(documents.path, 'coglog.sqlite'));
  return AppDatabase(NativeDatabase.createInBackground(file));
}

/// テスト用のメモリ DB を開く。
///
/// Example:
/// ```dart
/// openMemoryDatabase();
/// ```
AppDatabase openMemoryDatabase() => AppDatabase(NativeDatabase.memory());
