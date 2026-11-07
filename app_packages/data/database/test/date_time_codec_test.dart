import 'package:data_database/data_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encodeUtc は常に 6 桁小数で辞書順が時刻順になる', () {
    final earlier = DateTime.utc(2026, 11, 5, 12, 0, 0, 0, 0);
    final later = DateTime.utc(2026, 11, 5, 12, 0, 0, 0, 123);
    final a = encodeUtc(earlier);
    final b = encodeUtc(later);
    expect(a, '2026-11-05T12:00:00.000000Z');
    expect(b, '2026-11-05T12:00:00.000123Z');
    expect(a.compareTo(b), lessThan(0));
    expect(decodeUtc(a), earlier);
    expect(decodeUtc(b), later);
  });
}
