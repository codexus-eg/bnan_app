import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_evaluation_value_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_json_parser.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_reference_model.dart';

class MeEvaluationSubjectModel {
  const MeEvaluationSubjectModel({
    this.id = '',
    this.name = '',
    this.status = 'not_evaluated',
    this.classroom,
    this.evaluation,
  });

  final String id, name, status;
  final ReadEvaluationReferenceModel? classroom;
  final MeEvaluationValueModel? evaluation;
  bool get isEvaluated => status == 'evaluated' && evaluation != null;

  factory MeEvaluationSubjectModel.fromJson(Map<String, dynamic> json) {
    final hasEvaluation = json['evaluation'] is Map;
    final evaluation = ReadEvaluationJsonParser.map(json['evaluation']);
    final rawStatus = ReadEvaluationJsonParser.string(
      json['status'],
    ).toLowerCase();
    return MeEvaluationSubjectModel(
      id: ReadEvaluationJsonParser.id(json),
      name: ReadEvaluationJsonParser.string(json['name']),
      status: rawStatus.isEmpty
          ? (hasEvaluation ? 'evaluated' : 'not_evaluated')
          : rawStatus,
      classroom: ReadEvaluationReferenceModel.fromNullable(json['classroom']),
      evaluation: hasEvaluation
          ? MeEvaluationValueModel.fromJson(evaluation)
          : null,
    );
  }
}
