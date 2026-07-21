class RelationParser {
  const RelationParser._();

  static String? idOf(dynamic value) {
    if (value is String) {
      return value;
    }

    if (value is Map<String, dynamic>) {
      return value['id']?.toString() ?? value['_id']?.toString();
    }

    if (value is Map) {
      return value['id']?.toString() ?? value['_id']?.toString();
    }

    return null;
  }

  static Map<String, dynamic>? mapOf(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }
}
