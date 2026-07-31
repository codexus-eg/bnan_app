import 'package:bnan_app/features/plans/data/models/plan_classroom_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';

class WeeklyPlansResponseModel {
  const WeeklyPlansResponseModel({
    this.success = false,
    this.results = 0,
    this.data = const WeeklyPlansDataModel(),
  });

  final bool success;
  final int results;
  final WeeklyPlansDataModel data;

  factory WeeklyPlansResponseModel.fromJson(Map<String, dynamic> json) {
    return WeeklyPlansResponseModel(
      success: PlanModelParser.boolean(json['success']),
      results: PlanModelParser.integer(json['results']),
      data: WeeklyPlansDataModel.fromJson(PlanModelParser.map(json['data'])),
    );
  }
}

class WeeklyPlansDataModel {
  const WeeklyPlansDataModel({
    this.classroom = const PlanClassroomModel(),
    this.week = 0,
    this.subjects = const [],
  });

  final PlanClassroomModel classroom;
  final int week;
  final List<WeeklyPlanSubjectModel> subjects;

  factory WeeklyPlansDataModel.fromJson(Map<String, dynamic> json) {
    return WeeklyPlansDataModel(
      classroom: PlanClassroomModel.fromJson(
        PlanModelParser.map(json['classroom']),
      ),
      week: PlanModelParser.integer(json['week']),
      subjects: PlanModelParser.maps(
        json['subjects'],
      ).map(WeeklyPlanSubjectModel.fromJson).toList(),
    );
  }
}

class WeeklyPlanSubjectModel {
  const WeeklyPlanSubjectModel({
    this.id = '',
    this.name = '',
    this.plans = const [],
  });

  final String id;
  final String name;
  final List<DailyPlanItemModel> plans;

  factory WeeklyPlanSubjectModel.fromJson(Map<String, dynamic> json) {
    return WeeklyPlanSubjectModel(
      id: PlanModelParser.id(json),
      name: PlanModelParser.string(json['name']),
      plans: PlanModelParser.maps(
        json['plans'],
      ).map(DailyPlanItemModel.fromJson).toList(),
    );
  }
}

class DailyPlanItemModel {
  const DailyPlanItemModel({
    this.day = '',
    this.sessionContent = '',
    this.sessionAssignment = '',
  });

  final String day;
  final String sessionContent;
  final String sessionAssignment;

  factory DailyPlanItemModel.fromJson(Map<String, dynamic> json) {
    return DailyPlanItemModel(
      day: PlanModelParser.string(json['day']),
      sessionContent: PlanModelParser.string(json['sessionContent']),
      sessionAssignment: PlanModelParser.string(json['sessionAssignment']),
    );
  }
}
