import 'package:data_repository_exercise_history_impl/data_repository_exercise_history_impl.dart';
import 'package:test/test.dart';

void main() {
  test('保存が無いので空リストを返す', () async {
    final histories = await const EmptyExerciseHistoryRepository().list();
    expect(histories, isEmpty);
  });
}
