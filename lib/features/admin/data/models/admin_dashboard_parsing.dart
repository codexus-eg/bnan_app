int adminInt(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double adminDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

String adminString(Object? value) => value?.toString().trim() ?? '';

Map<String, dynamic> adminMap(Object? value) {
  return value is Map ? Map<String, dynamic>.from(value) : const {};
}
