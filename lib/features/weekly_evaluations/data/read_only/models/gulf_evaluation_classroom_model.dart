import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_availability_status.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_evaluation_value_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_json_parser.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_reference_model.dart';

class GulfEvaluationClassroomModel {
  const GulfEvaluationClassroomModel({
    this.id = '',
    this.name = '',
    this.grade,
    this.curriculum,
    this.subject,
    this.evaluationStatus = EvaluationAvailabilityStatus.unknown,
    this.evaluation,
  });

  final String id, name;
  final ReadEvaluationReferenceModel? grade, curriculum, subject;
  final EvaluationAvailabilityStatus evaluationStatus;
  final MeEvaluationValueModel? evaluation;

  factory GulfEvaluationClassroomModel.fromJson(Map<String, dynamic> json) {
    final subject = ReadEvaluationReferenceModel.fromNullable(json['subject']);
    final hasEvaluation = json['evaluation'] is Map;
    return GulfEvaluationClassroomModel(
      id: ReadEvaluationJsonParser.id(json),
      name: ReadEvaluationJsonParser.string(json['name']),
      grade: ReadEvaluationReferenceModel.fromNullable(json['grade']),
      curriculum: ReadEvaluationReferenceModel.fromNullable(json['curriculum']),
      subject: subject,
      evaluationStatus: EvaluationAvailabilityStatus.parse(
        json['evaluationStatus'],
        hasSubject: subject != null,
        hasEvaluation: hasEvaluation,
      ),
      evaluation: hasEvaluation
          ? MeEvaluationValueModel.fromJson(
              ReadEvaluationJsonParser.map(json['evaluation']),
            )
          : null,
    );
  }
}
