abstract class PlanModelParser {
  static Map<String, dynamic> map(Object? value) {
    return value is Map ? Map<String, dynamic>.from(value) : const {};
  }

  static List<Map<String, dynamic>> maps(Object? value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  static String string(Object? value) => value?.toString() ?? '';

  static int integer(Object? value) {
    return value is int ? value : int.tryParse(string(value)) ?? 0;
  }

  static bool boolean(Object? value) => value is bool && value;

  static String id(Map<String, dynamic> json) {
    final id = string(json['id']);
    return id.isNotEmpty ? id : string(json['_id']);
  }
}
