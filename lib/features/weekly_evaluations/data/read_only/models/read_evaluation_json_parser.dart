abstract final class ReadEvaluationJsonParser {
  static String string(Object? value) => value?.toString().trim() ?? '';

  static String? nullableString(Object? value) {
    if (value == null) return null;
    final result = string(value);
    return result.isEmpty ? null : result;
  }

  static int? integer(Object? value) {
    if (value is int) return value;
    return int.tryParse(string(value));
  }

  static bool boolean(Object? value) => value == true || value == 'true';

  static Map<String, dynamic> map(Object? value) => value is Map
      ? Map<String, dynamic>.from(value)
      : const <String, dynamic>{};

  static List<Map<String, dynamic>> maps(Object? value) => value is List
      ? value
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false)
      : const <Map<String, dynamic>>[];

  static String id(Map<String, dynamic> json) =>
      string(json['id'] ?? json['_id']);

  static String? nullableId(Map<String, dynamic> json) =>
      nullableString(json['id'] ?? json['_id']);

  static String identity(Object? value) {
    final data = map(value);
    if (data.isEmpty) return string(value);
    return id(data).isNotEmpty
        ? id(data)
        : string(data['fullName'] ?? data['name']);
  }
}
