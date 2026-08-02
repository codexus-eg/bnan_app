import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_json_parser.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_value_model.dart';

class EvaluationSubjectModel {
  const EvaluationSubjectModel({
    this.id = '',
    this.name = '',
    this.status = 'not_evaluated',
    this.evaluation,
  });

  final String id, name, status;
  final EvaluationValueModel? evaluation;
  bool get isEvaluated => status == 'evaluated' && evaluation != null;

  factory EvaluationSubjectModel.fromJson(Map<String, dynamic> json) {
    final rawEvaluation = json['evaluation'];
    return EvaluationSubjectModel(
      id: EvaluationJsonParser.id(json),
      name: EvaluationJsonParser.string(json['name']),
      status: EvaluationJsonParser.string(json['status']).isEmpty
          ? (rawEvaluation is Map ? 'evaluated' : 'not_evaluated')
          : EvaluationJsonParser.string(json['status']),
      evaluation: rawEvaluation is Map
          ? EvaluationValueModel.fromJson(
              Map<String, dynamic>.from(rawEvaluation),
            )
          : null,
    );
  }
}
