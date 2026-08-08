class PayrollFilters {
  const PayrollFilters({
    required this.from,
    required this.to,
    this.status,
    this.teacherId,
  });
  final DateTime from, to;
  final String? status, teacherId;
}
