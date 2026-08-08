Map<String, dynamic> payrollMap(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};

List<dynamic> payrollList(Object? value) => value is List ? value : const [];

String payrollString(Object? value) => value?.toString().trim() ?? '';

double payrollDouble(Object? value) => value is num
    ? value.toDouble()
    : double.tryParse(payrollString(value)) ?? 0;

int payrollInt(Object? value) =>
    value is num ? value.toInt() : int.tryParse(payrollString(value)) ?? 0;

Map<String, dynamic> payrollData(Object? response) {
  final root = payrollMap(response);
  return root['data'] is Map ? payrollMap(root['data']) : root;
}
