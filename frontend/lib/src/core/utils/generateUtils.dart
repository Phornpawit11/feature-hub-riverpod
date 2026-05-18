// infrastructure/utils/generateUtils.dart

import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';

class GenerateUtils {
  static void printLogJSON(String tag, Object? object) {
    log("$tag => ${jsonEncode(object)}");
  }

  static String convertToIso8601Utc({required String inputDate}) {
    DateFormat inputFormat = DateFormat('dd-MM-yyyy');
    DateTime date = inputFormat.parse(inputDate);
    DateTime adjusted = DateTime.utc(date.year, date.month, date.day);
    return adjusted.toIso8601String();
  }

  static String convertToDate({required DateTime inputDate}) {
    final day = inputDate.day.toString().padLeft(2, '0');
    final month = inputDate.month.toString().padLeft(2, '0');
    final year = inputDate.year.toString();

    return '$day-$month-$year';
  }

  static String formatDate({required String dateTimeZone}) {
    // แปลงเป็น DateTime
    DateTime utcDate = DateTime.parse(dateTimeZone);
    // ปรับเวลาเป็นไทย (UTC+7)
    DateTime dateTime = utcDate.toLocal();

    return '${dateTime.day}-${dateTime.month}-${dateTime.year} เวลา ${dateTime.hour}:${dateTime.minute} น.';
  }
}
