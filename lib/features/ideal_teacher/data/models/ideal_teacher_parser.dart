abstract final class IdealTeacherParser {
  static Map<String, dynamic> map(Object? value) => value is Map
      ? Map<String, dynamic>.from(value)
      : const <String, dynamic>{};

  static List<Object?> list(Object? value) => value is List ? value : const [];

  static String text(Object? value) => value?.toString().trim() ?? '';

  static List<String> labels(Object? value) => list(value)
      .map((item) {
        if (item is String) return item.trim();
        final data = map(item);
        return text(data['name'] ?? data['title'] ?? data['label']);
      })
      .where((item) => item.isNotEmpty)
      .toSet()
      .toList(growable: false);

  static num number(Object? value) =>
      value is num ? value : num.tryParse(text(value)) ?? 0;

  static num? nullableNumber(Object? value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(text(value));
  }

  static int integer(Object? value) =>
      value is num ? value.toInt() : int.tryParse(text(value)) ?? 0;

  static bool boolean(Object? value) =>
      value == true || value == 1 || text(value).toLowerCase() == 'true';

  static List<Map<String, dynamic>> maps(Object? value) => value is List
      ? value
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false)
      : const [];

  static List<Object?> responseItems(Object? response) {
    final root = map(response);
    final data = root['data'];
    if (data is List) return data;
    final nested = map(data);
    return list(
      nested['teachers'] ??
          root['teachers'] ??
          nested['users'] ??
          root['users'],
    );
  }
}
