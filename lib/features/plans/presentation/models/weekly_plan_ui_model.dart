import 'package:bnan_app/features/plans/presentation/models/plan_day_ui_model.dart';

class WeeklyPlanUiModel {
  const WeeklyPlanUiModel({
    required this.title,
    required this.classroomName,
    required this.weekName,
    required this.subjectNames,
    required this.days,
  });

  final String title;
  final String classroomName;
  final String weekName;
  final List<String> subjectNames;
  final List<PlanDayUiModel> days;
}
