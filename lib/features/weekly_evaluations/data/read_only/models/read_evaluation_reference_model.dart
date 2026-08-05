import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_json_parser.dart';

class ReadEvaluationReferenceModel {
  const ReadEvaluationReferenceModel({this.id = '', this.name = ''});

  final String id;
  final String name;

  factory ReadEvaluationReferenceModel.fromJson(Map<String, dynamic> json) =>
      ReadEvaluationReferenceModel(
        id: ReadEvaluationJsonParser.id(json),
        name: ReadEvaluationJsonParser.string(json['name'] ?? json['fullName']),
      );

  static ReadEvaluationReferenceModel? fromNullable(Object? value) {
    final data = ReadEvaluationJsonParser.map(value);
    return data.isEmpty ? null : ReadEvaluationReferenceModel.fromJson(data);
  }
}
