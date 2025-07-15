/// CSV 내보내기 결과를 표현하는 클래스
class CsvExportResult {
  final bool success;
  final String message;
  final String? filePath;

  CsvExportResult({
    required this.success,
    required this.message,
    this.filePath,
  });
}
