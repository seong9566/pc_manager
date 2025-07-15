import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:intl/intl.dart';

/// CSV 내보내기를 위한 유틸리티 클래스
class CsvExportHelper {
  /// 기간별 매출 데이터를 CSV 형식으로 변환하고 파일로 저장
  ///
  /// [data] - 내보낼 데이터 리스트
  /// [fileName] - 저장할 파일 이름 (확장자 제외)
  /// [headers] - CSV 파일의 헤더 목록
  static Future<String> exportToCsv({
    required List<List<dynamic>> data,
    required String fileName,
    required List<String> headers,
  }) async {
    try {
      // 헤더를 데이터의 첫 번째 행으로 추가
      final csvData = [headers, ...data];

      // CSV 형식으로 변환
      final csv = const ListToCsvConverter().convert(csvData);

      // 플랫폼별 파일 저장 처리
      if (kIsWeb) {
        // 웹 환경에서는 다운로드 처리
        final blob = html.Blob([csv], 'text/csv;charset=utf-8');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', '$fileName.csv')
          ..click();
        html.Url.revokeObjectUrl(url);
        return '웹 브라우저에서 다운로드 되었습니다.';
      } else {
        // 모바일/데스크톱 환경에서는 파일로 저장
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/$fileName.csv';
        final file = File(path);
        await file.writeAsString(csv);
        return path;
      }
    } catch (e) {
      return '내보내기 오류: $e';
    }
  }

  /// 날짜 포맷 변환 (YYYY.MM.DD 형식으로)
  static String formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd').format(date);
  }
}
