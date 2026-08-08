abstract final class IdealStudentJsonParser {
  static String text(Object? value) => value?.toString().trim() ?? '';
  static num number(Object? value) =>
      value is num ? value : num.tryParse(text(value)) ?? 0;
  static int integer(Object? value) => number(value).toInt();
  static bool boolean(Object? value) =>
      value == true || value == 1 || text(value).toLowerCase() == 'true';
  static Map<String, dynamic> map(Object? value) =>
      value is Map ? Map<String, dynamic>.from(value) : const {};
  static List<Map<String, dynamic>> maps(Object? value) => value is List
      ? value
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false)
      : const [];
}
