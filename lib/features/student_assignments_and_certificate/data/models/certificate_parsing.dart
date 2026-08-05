Map<String, Object?> certificateMap(Object? value) {
  if (value is! Map) return const {};
  return value.map((key, item) => MapEntry(key.toString(), item));
}

List<Object?> certificateList(Object? value) {
  return value is List ? List<Object?>.from(value) : const [];
}

String certificateString(Object? value) => value?.toString().trim() ?? '';

double certificateDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int certificateInt(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
