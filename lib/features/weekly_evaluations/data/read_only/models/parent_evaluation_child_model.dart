import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_json_parser.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_reference_model.dart';

class ParentEvaluationChildModel {
  const ParentEvaluationChildModel({
    this.id = '',
    this.fullName = '',
    this.classroom,
    this.classrooms = const [],
  });

  final String id, fullName;
  final ReadEvaluationReferenceModel? classroom;
  final List<ReadEvaluationReferenceModel> classrooms;

  factory ParentEvaluationChildModel.fromJson(Map<String, dynamic> json) =>
      ParentEvaluationChildModel(
        id: ReadEvaluationJsonParser.id(json),
        fullName: ReadEvaluationJsonParser.string(
          json['fullName'] ?? json['name'],
        ),
        classroom: ReadEvaluationReferenceModel.fromNullable(json['classroom']),
        classrooms: ReadEvaluationJsonParser.maps(
          json['classrooms'],
        ).map(ReadEvaluationReferenceModel.fromJson).toList(growable: false),
      );
}
