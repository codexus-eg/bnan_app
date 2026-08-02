abstract final class EvaluationJsonParser {
  static String string(Object? value) => value?.toString() ?? '';

  static int integer(Object? value) =>
      value is int ? value : int.tryParse(string(value)) ?? 0;

  static bool boolean(Object? value) => value == true || value == 'true';

  static Map<String, dynamic> map(Object? value) =>
      value is Map ? Map<String, dynamic>.from(value) : const {};

  static List<Map<String, dynamic>> maps(Object? value) => value is List
      ? value
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false)
      : const [];

  static String id(Map<String, dynamic> json) =>
      string(json['id'] ?? json['_id']);
}
