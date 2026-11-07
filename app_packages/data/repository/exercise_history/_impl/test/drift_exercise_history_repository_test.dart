import 'dart:io';
import 'dart:typed_data';

import 'package:data_database/data_database.dart';
import 'package:data_repository_exercise_history_impl/data_repository_exercise_history_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory docs;
  late AppDatabase db;
  late DriftExerciseHistoryRepository repo;

  setUp(() {
    docs = Directory.systemTemp.createTempSync('eh_');
    db = openMemoryDatabase();
    repo = DriftExerciseHistoryRepository(
      database: db,
      photos: ExerciseHistoryPhotoStore(docs),
    );
  });

  tearDown(() async {
    await db.close();
    if (docs.existsSync()) {
      docs.deleteSync(recursive: true);
    }
  });

  test('0件のとき list は空', () async {
    expect(await repo.list(), isEmpty);
  });

  test('create 後 list で同値が得られ写真ファイルが存在する', () async {
    final created = await repo.create(
      creationStartedAt: DateTime.utc(2026, 11, 5),
      capturedAt: DateTime.utc(2026, 11, 5, 1),
      recordedAt: DateTime.utc(2026, 11, 5, 2),
      recordedAtManuallySet: false,
      distanceKm: 1.5,
      duration: const Duration(minutes: 20),
      caloriesKcal: 80,
      averageSpeedKmh: 4.5,
      photoBytes: Uint8List.fromList([1, 2, 3]),
    );

    final listed = await repo.list();
    expect(listed, hasLength(1));
    expect(listed.single.id, created.id);
    expect(listed.single.distanceKm, 1.5);
    expect(listed.single.savedAt.isUtc, isTrue);
    expect(
      File('${docs.path}/${created.photoRelativePath}').existsSync(),
      isTrue,
    );
  });

  test('複数 create で list は recordedAt 降順', () async {
    await repo.create(
      creationStartedAt: DateTime.utc(2026, 11, 5),
      capturedAt: DateTime.utc(2026, 11, 5),
      recordedAt: DateTime.utc(2026, 11, 5, 10),
      recordedAtManuallySet: false,
      distanceKm: 1,
      duration: const Duration(minutes: 1),
      caloriesKcal: 1,
      averageSpeedKmh: 1,
      photoBytes: Uint8List.fromList([1]),
    );
    await repo.create(
      creationStartedAt: DateTime.utc(2026, 11, 5),
      capturedAt: DateTime.utc(2026, 11, 5),
      recordedAt: DateTime.utc(2026, 11, 5, 12),
      recordedAtManuallySet: false,
      distanceKm: 2,
      duration: const Duration(minutes: 2),
      caloriesKcal: 2,
      averageSpeedKmh: 2,
      photoBytes: Uint8List.fromList([2]),
    );

    final listed = await repo.list();
    expect(listed, hasLength(2));
    expect(listed.first.recordedAt, DateTime.utc(2026, 11, 5, 12));
    expect(listed.last.recordedAt, DateTime.utc(2026, 11, 5, 10));
  });

  test('update 後 savedAt は変わらず他項目は変わる', () async {
    final created = await repo.create(
      creationStartedAt: DateTime.utc(2026, 11, 5),
      capturedAt: DateTime.utc(2026, 11, 5),
      recordedAt: DateTime.utc(2026, 11, 5),
      recordedAtManuallySet: false,
      distanceKm: 1,
      duration: const Duration(minutes: 1),
      caloriesKcal: 1,
      averageSpeedKmh: 1,
      photoBytes: Uint8List.fromList([1]),
    );

    final updated = await repo.update(
      id: created.id,
      creationStartedAt: DateTime.utc(2026, 11, 6),
      capturedAt: DateTime.utc(2026, 11, 6),
      recordedAt: DateTime.utc(2026, 11, 6),
      recordedAtManuallySet: true,
      distanceKm: 9,
      duration: const Duration(minutes: 9),
      caloriesKcal: 9,
      averageSpeedKmh: 9,
    );

    expect(updated.savedAt, created.savedAt);
    expect(updated.distanceKm, 9);
    expect(updated.recordedAtManuallySet, isTrue);
  });

  test('update で写真置換するとファイル内容が新 bytes', () async {
    final created = await repo.create(
      creationStartedAt: DateTime.utc(2026, 11, 5),
      capturedAt: DateTime.utc(2026, 11, 5),
      recordedAt: DateTime.utc(2026, 11, 5),
      recordedAtManuallySet: false,
      distanceKm: 1,
      duration: const Duration(minutes: 1),
      caloriesKcal: 1,
      averageSpeedKmh: 1,
      photoBytes: Uint8List.fromList([1, 1, 1]),
    );

    await repo.update(
      id: created.id,
      creationStartedAt: created.creationStartedAt,
      capturedAt: created.capturedAt,
      recordedAt: created.recordedAt,
      recordedAtManuallySet: false,
      distanceKm: 1,
      duration: const Duration(minutes: 1),
      caloriesKcal: 1,
      averageSpeedKmh: 1,
      photoBytes: Uint8List.fromList([9, 9, 9]),
    );

    final bytes = await File('${docs.path}/${created.photoRelativePath}')
        .readAsBytes();
    expect(bytes, [9, 9, 9]);
  });

  test('delete 後 list 空かつ写真ディレクトリ不存在', () async {
    final created = await repo.create(
      creationStartedAt: DateTime.utc(2026, 11, 5),
      capturedAt: DateTime.utc(2026, 11, 5),
      recordedAt: DateTime.utc(2026, 11, 5),
      recordedAtManuallySet: false,
      distanceKm: 1,
      duration: const Duration(minutes: 1),
      caloriesKcal: 1,
      averageSpeedKmh: 1,
      photoBytes: Uint8List.fromList([1]),
    );

    await repo.delete(created.id);

    expect(await repo.list(), isEmpty);
    expect(
      Directory('${docs.path}/exercise_histories/${created.id}').existsSync(),
      isFalse,
    );
  });

  test('duration 0 の create は ArgumentError', () async {
    expect(
      () => repo.create(
        creationStartedAt: DateTime.utc(2026, 11, 5),
        capturedAt: DateTime.utc(2026, 11, 5),
        recordedAt: DateTime.utc(2026, 11, 5),
        recordedAtManuallySet: false,
        distanceKm: 1,
        duration: Duration.zero,
        caloriesKcal: 1,
        averageSpeedKmh: 1,
        photoBytes: Uint8List.fromList([1]),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('未知 id の update/delete は StateError', () async {
    const missing = '33333333-3333-4333-8333-333333333333';
    expect(
      () => repo.update(
        id: missing,
        creationStartedAt: DateTime.utc(2026, 11, 5),
        capturedAt: DateTime.utc(2026, 11, 5),
        recordedAt: DateTime.utc(2026, 11, 5),
        recordedAtManuallySet: false,
        distanceKm: 1,
        duration: const Duration(minutes: 1),
        caloriesKcal: 1,
        averageSpeedKmh: 1,
      ),
      throwsA(isA<StateError>()),
    );
    expect(() => repo.delete(missing), throwsA(isA<StateError>()));
  });

  test('写真 write 後 deleteFor でディレクトリが消える', () async {
    const id = '22222222-2222-4222-8222-222222222222';
    final store = ExerciseHistoryPhotoStore(docs);
    await store.write(id, Uint8List.fromList([9]));
    expect(
      Directory('${docs.path}/exercise_histories/$id').existsSync(),
      isTrue,
    );
    await store.deleteFor(id);
    expect(
      Directory('${docs.path}/exercise_histories/$id').existsSync(),
      isFalse,
    );
  });
}
