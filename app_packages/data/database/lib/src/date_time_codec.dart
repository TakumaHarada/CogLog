/// DB 文字列を UTC の [DateTime] にする。
///
/// Example:
/// ```dart
/// decodeUtc('2026-11-05T00:00:00.000Z');
/// ```
DateTime decodeUtc(String raw) => DateTime.parse(raw).toUtc();

/// [DateTime] を UTC の ISO-8601 文字列にする。
///
/// Example:
/// ```dart
/// encodeUtc(DateTime.utc(2026, 11, 5));
/// ```
String encodeUtc(DateTime value) => value.toUtc().toIso8601String();
