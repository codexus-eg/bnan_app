import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_data_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_json_parser.dart';

class MeWeeklyEvaluationsResponseModel {
  const MeWeeklyEvaluationsResponseModel({
    this.success = false,
    this.results,
    required this.data,
  });

  final bool success;
  final int? results;
  final MeWeeklyEvaluationsDataModel data;

  factory MeWeeklyEvaluationsResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map
        ? ReadEvaluationJsonParser.map(json['data'])
        : json;
    return MeWeeklyEvaluationsResponseModel(
      success: ReadEvaluationJsonParser.boolean(json['success']),
      results: ReadEvaluationJsonParser.integer(json['results']),
      data: MeWeeklyEvaluationsDataModel.fromJson(payload),
    );
  }
}
