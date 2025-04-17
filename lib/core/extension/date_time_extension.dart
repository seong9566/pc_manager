extension DateTimeExtension on DateTime {
  /// 2025-04-17
  String toDateOnlyForString() {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// 2025-04-17 00:00:00
  DateTime toDateOnlyForDateTime() {
    return DateTime(year, month, day);
  }
}
