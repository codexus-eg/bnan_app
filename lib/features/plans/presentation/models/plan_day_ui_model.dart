import 'package:bnan_app/features/plans/presentation/models/plan_subject_ui_model.dart';

class PlanDayUiModel {
  const PlanDayUiModel({required this.dayName, required this.subjects});

  final String dayName;
  final List<PlanSubjectUiModel> subjects;

  PlanSubjectUiModel? subjectByName(String name) {
    for (final subject in subjects) {
      if (subject.subjectName == name) return subject;
    }
    return null;
  }
}
