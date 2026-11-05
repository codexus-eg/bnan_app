import 'payroll_parsing.dart';

class ExistingStatementModel {
  const ExistingStatementModel({
    required this.id,
    required this.teacherId,
    required this.from,
    required this.to,
    required this.status,
    this.curriculumId = '',
  });

  final String id, teacherId, from, to, status, curriculumId;

  factory ExistingStatementModel.fromJson(Object? value) {
    final json = payrollMap(value);
    final period = payrollMap(json['period']);
    final teacher = json['teacherId'] is Map
        ? payrollMap(json['teacherId'])
        : (json['teacher'] is Map ? payrollMap(json['teacher']) : null);
    final curriculum = json['curriculumId'] is Map
        ? payrollMap(json['curriculumId'])
        : (json['curriculum'] is Map ? payrollMap(json['curriculum']) : null);

    return ExistingStatementModel(
      id: payrollString(json['_id'] ?? json['id']),
      teacherId: payrollString(
        teacher?['_id'] ?? teacher?['id'] ?? json['teacherId'],
      ),
      from: payrollString(json['from'] ?? period['from']),
      to: payrollString(json['to'] ?? period['to']),
      status: payrollString(json['status'] ?? 'draft'),
      curriculumId: payrollString(
        curriculum?['_id'] ?? curriculum?['id'] ?? json['curriculumId'],
      ),
    );
  }

  bool overlaps(String selectedFrom, String selectedTo) {
    if (from.isEmpty ||
        to.isEmpty ||
        selectedFrom.isEmpty ||
        selectedTo.isEmpty) {
      return false;
    }
    return from.compareTo(selectedTo) <= 0 && to.compareTo(selectedFrom) >= 0;
  }
}
