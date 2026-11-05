class PayrollFilters {
  const PayrollFilters({
    required this.from,
    required this.to,
    this.curriculumId,
    this.curriculumName,
    this.status,
    this.teacherId,
  });
  final DateTime from, to;
  final String? curriculumId, curriculumName, status, teacherId;
}
