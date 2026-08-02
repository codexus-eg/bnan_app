import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_json_parser.dart';

class ElapsedEvaluationWeeksModel {
  const ElapsedEvaluationWeeksModel({this.success = false, required this.data});

  final bool success;
  final ElapsedEvaluationWeeksData data;

  factory ElapsedEvaluationWeeksModel.fromJson(Map<String, dynamic> json) =>
      ElapsedEvaluationWeeksModel(
        success: EvaluationJsonParser.boolean(json['success']),
        data: ElapsedEvaluationWeeksData.fromJson(
          EvaluationJsonParser.map(json['data']),
        ),
      );
}

class ElapsedEvaluationWeeksData {
  const ElapsedEvaluationWeeksData({
    this.classroomId = '',
    this.classroomName = '',
    this.startDate = '',
    this.weeksCount = 0,
    this.completedWeeks = 0,
    this.currentWeek = 0,
  });

  final String classroomId, classroomName, startDate;
  final int weeksCount, completedWeeks, currentWeek;
  List<int> get weeks => List.generate(weeksCount, (index) => index + 1);
  int? get initialWeek => weeksCount < 1
      ? null
      : currentWeek >= 1 && currentWeek <= weeksCount
      ? currentWeek
      : weeksCount;

  factory ElapsedEvaluationWeeksData.fromJson(Map<String, dynamic> json) {
    final classroom = EvaluationJsonParser.map(json['classroom']);
    return ElapsedEvaluationWeeksData(
      classroomId: EvaluationJsonParser.id(classroom),
      classroomName: EvaluationJsonParser.string(classroom['name']),
      startDate: EvaluationJsonParser.string(json['startDate']),
      weeksCount: EvaluationJsonParser.integer(json['weeksCount']),
      completedWeeks: EvaluationJsonParser.integer(json['completedWeeks']),
      currentWeek: EvaluationJsonParser.integer(json['currentWeek']),
    );
  }
}
