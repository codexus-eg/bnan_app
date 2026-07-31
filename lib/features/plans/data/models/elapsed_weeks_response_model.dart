import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';

class ElapsedWeeksResponseModel {
  const ElapsedWeeksResponseModel({
    this.success = false,
    this.data = const ElapsedWeeksDataModel(),
  });

  final bool success;
  final ElapsedWeeksDataModel data;

  factory ElapsedWeeksResponseModel.fromJson(Map<String, dynamic> json) {
    return ElapsedWeeksResponseModel(
      success: PlanModelParser.boolean(json['success']),
      data: ElapsedWeeksDataModel.fromJson(PlanModelParser.map(json['data'])),
    );
  }
}

class ElapsedWeeksDataModel {
  const ElapsedWeeksDataModel({
    this.startDate = '',
    this.weeksCount = 0,
    this.completedWeeks = 0,
    this.currentWeek = 0,
  });

  final String startDate;
  final int weeksCount;
  final int completedWeeks;
  final int currentWeek;

  factory ElapsedWeeksDataModel.fromJson(Map<String, dynamic> json) {
    return ElapsedWeeksDataModel(
      startDate: PlanModelParser.string(json['startDate']),
      weeksCount: PlanModelParser.integer(json['weeksCount']),
      completedWeeks: PlanModelParser.integer(json['completedWeeks']),
      currentWeek: PlanModelParser.integer(json['currentWeek']),
    );
  }
}
