import 'package:bnan_app/features/plans/presentation/models/plan_day_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_subject_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/models/weekly_plan_ui_model.dart';
import 'package:bnan_app/generated/l10n.dart';

abstract class PlansMockData {
  static WeeklyPlanUiModel create(S s) {
    final subjectNames = [s.math, s.arabic];
    return WeeklyPlanUiModel(
      title: '${s.studyPlanTitlePrefix} ${s.firstPrimaryClassroom}',
      classroomName: s.firstPrimaryClassroom,
      weekName: s.weekOne,
      subjectNames: subjectNames,
      days: [
        PlanDayUiModel(dayName: s.sunday, subjects: _subjects(s)),
        PlanDayUiModel(dayName: s.monday, subjects: _subjects(s)),
        PlanDayUiModel(dayName: s.tuesday, subjects: _subjects(s)),
        PlanDayUiModel(dayName: s.wednesday, subjects: _subjects(s)),
        PlanDayUiModel(dayName: s.thursday, subjects: _subjects(s)),
      ],
    );
  }

  static List<PlanSubjectUiModel> _subjects(S s) {
    return [
      PlanSubjectUiModel(
        subjectName: s.math,
        lesson: s.sampleQuadraticEquations,
        homework: s.sampleExercisesHomework,
      ),
      PlanSubjectUiModel(
        subjectName: s.arabic,
        lesson: s.sampleGrammarLesson,
        homework: s.sampleExercisesHomework,
      ),
    ];
  }
}
