/// DB 文字列を UTC の [DateTime] にする。
///
/// Example:
/// ```dart
/// decodeUtc('2026-11-05T00:00:00.000000Z');
/// ```
DateTime decodeUtc(String raw) => DateTime.parse(raw).toUtc();

/// [DateTime] を UTC・固定 6 桁小数の ISO-8601 文字列にする。
///
/// 可変桁だと TEXT の辞書順が時刻順とずれるため、常にマイクロ秒 6 桁にする。
///
/// Example:
/// ```dart
/// encodeUtc(DateTime.utc(2026, 11, 5));
/// ```
String encodeUtc(DateTime value) {
  final utc = value.toUtc();
  final year = utc.year.toString().padLeft(4, '0');
  final month = utc.month.toString().padLeft(2, '0');
  final day = utc.day.toString().padLeft(2, '0');
  final hour = utc.hour.toString().padLeft(2, '0');
  final minute = utc.minute.toString().padLeft(2, '0');
  final second = utc.second.toString().padLeft(2, '0');
  final fraction = (utc.millisecond * 1000 + utc.microsecond)
      .toString()
      .padLeft(6, '0');
  return '$year-$month-${day}T$hour:$minute:$second.${fraction}Z';
}
