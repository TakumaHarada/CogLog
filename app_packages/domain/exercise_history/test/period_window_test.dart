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

  test('今週の両端は現地日付の 0:00 である', () {
    final week = PeriodWindow.week(now);
    expect(week.start, DateTime(2026, 11, 2));
    expect(week.end, DateTime(2026, 11, 9));
  });

  test('夏時間をまたぐ週も現地の 0:00 で切る', () {
    // 2026-03-08 は America/New_York の夏時間開始日。
    // 3月4日の週は月曜 3月2日 0:00 から月曜 3月9日 0:00 の直前まで。
    final week = PeriodWindow.week(DateTime(2026, 3, 4, 15));
    expect(week.start, DateTime(2026, 3, 2));
    expect(week.end, DateTime(2026, 3, 9));
    expect(week.end.hour, 0);
    expect(week.end.minute, 0);
  });

  test('11月5日の履歴は本日と今週と今月に入る', () {
    final recordedAt = DateTime(2026, 11, 5, 12);
    expect(PeriodWindow.today(now).contains(recordedAt), isTrue);
    expect(PeriodWindow.week(now).contains(recordedAt), isTrue);
    expect(PeriodWindow.month(now).contains(recordedAt), isTrue);
  });
}
