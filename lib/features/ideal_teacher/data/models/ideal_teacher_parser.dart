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

  static List<Object?> responseItems(Object? response) {
    final root = map(response);
    final data = root['data'];
    if (data is List) return data;
    final nested = map(data);
    return list(nested['teachers'] ?? root['teachers']);
  }
}
