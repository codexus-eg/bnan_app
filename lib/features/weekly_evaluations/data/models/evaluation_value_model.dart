import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_json_parser.dart';

class EvaluationValueModel {
  const EvaluationValueModel({
    this.id = '',
    this.attendance = '',
    this.participation = '',
    this.homework = '',
    this.behavior = '',
    this.notes = '',
    this.bonus = 0,
    this.createdByRole = '',
    this.updatedByRole = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  final String id, attendance, participation, homework, behavior, notes;
  final int bonus;
  final String createdByRole, updatedByRole, createdAt, updatedAt;

  factory EvaluationValueModel.fromJson(Map<String, dynamic> json) {
    String read(String key) => EvaluationJsonParser.string(json[key]);
    return EvaluationValueModel(
      id: EvaluationJsonParser.id(json),
      attendance: read('attendance'),
      participation: read('participation'),
      homework: read('homework'),
      behavior: read('behavior'),
      notes: read('notes'),
      bonus: EvaluationJsonParser.integer(json['bonus'] ?? json['bouns']),
      createdByRole: read('createdByRole'),
      updatedByRole: read('updatedByRole'),
      createdAt: read('createdAt'),
      updatedAt: read('updatedAt'),
    );
  }
}
