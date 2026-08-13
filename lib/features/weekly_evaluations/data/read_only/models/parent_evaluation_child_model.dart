import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_json_parser.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_reference_model.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';

class ParentEvaluationChildModel {
  const ParentEvaluationChildModel({
    this.id = '',
    this.fullName = '',
    this.classroom,
    this.classrooms = const [],
    this.registrationMode,
  });

  final String id, fullName;
  final ReadEvaluationReferenceModel? classroom;
  final List<ReadEvaluationReferenceModel> classrooms;
  final RegistrationMode? registrationMode;

  bool get hasClassroom => classroom != null || classrooms.isNotEmpty;

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
        registrationMode: RegistrationMode.fromValue(json['registrationMode']),
      );
}
