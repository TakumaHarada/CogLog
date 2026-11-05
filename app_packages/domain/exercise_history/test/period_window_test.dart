import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime(2026, 11, 5, 15);

  test('本日は現地日付の 0:00 から翌日 0:00 の直前まで', () {
    final today = PeriodWindow.today(now);
    expect(today.contains(DateTime(2026, 11, 5)), isTrue);
    expect(today.contains(DateTime(2026, 11, 6)), isFalse);
  });

  test('今週は月曜 0:00 から次の月曜 0:00 の直前まで', () {
    final week = PeriodWindow.week(now);
    expect(week.contains(DateTime(2026, 11, 2)), isTrue);
    expect(week.contains(DateTime(2026, 11, 1, 23, 59, 59)), isFalse);
    expect(week.contains(DateTime(2026, 11, 1, 12)), isFalse);
  });

  test('今月は 1 日 0:00 から翌月 1 日 0:00 の直前まで', () {
    final month = PeriodWindow.month(now);
    expect(month.contains(DateTime(2026, 11)), isTrue);
    expect(month.contains(DateTime(2026, 12)), isFalse);
    expect(month.contains(DateTime(2026, 11, 1, 12)), isTrue);
  });

  test('11月5日の履歴は本日と今週と今月に入る', () {
    final recordedAt = DateTime(2026, 11, 5, 12);
    expect(PeriodWindow.today(now).contains(recordedAt), isTrue);
    expect(PeriodWindow.week(now).contains(recordedAt), isTrue);
    expect(PeriodWindow.month(now).contains(recordedAt), isTrue);
  });
}
