import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_json_parser.dart';

class MeEvaluationValueModel {
  const MeEvaluationValueModel({
    this.id,
    this.attendance,
    this.attendanceAttended,
    this.attendanceTotal,
    this.participation,
    this.homework,
    this.behavior,
    this.bonus = 0,
    this.notes,
    this.createdByRole,
    this.updatedByRole,
    this.createdAt,
    this.updatedAt,
  });

  final String? id, attendance, participation, homework, behavior, notes;
  final int? attendanceAttended, attendanceTotal;
  final int bonus;
  final String? createdByRole, updatedByRole, createdAt, updatedAt;

  factory MeEvaluationValueModel.fromJson(Map<String, dynamic> json) {
    String? read(String key) =>
        ReadEvaluationJsonParser.nullableString(json[key]);
    return MeEvaluationValueModel(
      id: ReadEvaluationJsonParser.nullableId(json),
      attendance: read('attendance'),
      attendanceAttended: ReadEvaluationJsonParser.integer(
        json['attendanceAttended'],
      ),
      attendanceTotal: ReadEvaluationJsonParser.integer(
        json['attendanceTotal'],
      ),
      participation: read('participation'),
      homework: read('homework'),
      behavior: read('behavior'),
      bonus:
          ReadEvaluationJsonParser.integer(json['bonus'] ?? json['bouns']) ?? 0,
      notes: read('notes'),
      createdByRole: read('createdByRole'),
      updatedByRole: read('updatedByRole'),
      createdAt: read('createdAt'),
      updatedAt: read('updatedAt'),
    );
  }
}
