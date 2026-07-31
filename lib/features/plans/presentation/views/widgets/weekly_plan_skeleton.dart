import 'package:bnan_app/features/plans/presentation/models/plan_day_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_subject_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/models/weekly_plan_ui_model.dart';
import 'package:bnan_app/generated/l10n.dart';

abstract class WeeklyPlanSkeleton {
  static WeeklyPlanUiModel create(
    S s, {
    String? title,
    List<String>? subjectNames,
    bool loading = true,
  }) {
    final names = subjectNames?.isNotEmpty == true
        ? subjectNames!
        : [s.math, s.arabic];
    final subjects = loading
        ? names
              .map(
                (name) => PlanSubjectUiModel(
                  subjectName: name,
                  lesson: s.loading,
                  homework: s.loading,
                ),
              )
              .toList()
        : const <PlanSubjectUiModel>[];
    return WeeklyPlanUiModel(
      title: title ?? s.loading,
      classroomName: s.loading,
      weekName: s.loading,
      subjectNames: names,
      days: [
        PlanDayUiModel(dayName: s.sunday, subjects: subjects),
        PlanDayUiModel(dayName: s.monday, subjects: subjects),
        PlanDayUiModel(dayName: s.tuesday, subjects: subjects),
        PlanDayUiModel(dayName: s.wednesday, subjects: subjects),
        PlanDayUiModel(dayName: s.thursday, subjects: subjects),
      ],
    );
  }
}
