import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_day_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_subject_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/models/weekly_plan_ui_model.dart';
import 'package:bnan_app/generated/l10n.dart';

const _orderedDays = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday'];

const _planDaysMap = {
  'sunday': 'sunday',
  'الأحد': 'sunday',
  'الاحد': 'sunday',

  'monday': 'monday',
  'الإثنين': 'monday',
  'الاثنين': 'monday',

  'tuesday': 'tuesday',
  'الثلاثاء': 'tuesday',

  'wednesday': 'wednesday',
  'الأربعاء': 'wednesday',
  'الاربعاء': 'wednesday',

  'thursday': 'thursday',
  'الخميس': 'thursday',
};

WeeklyPlanUiModel mapWeeklyPlansToUiModel(
  S s,
  WeeklyPlansResponseModel response, {
  required String fallbackClassroomName,
  required int fallbackWeek,
}) {
  final data = response.data;

  final classroomName = data.classroom.name.trim().isEmpty
      ? fallbackClassroomName
      : data.classroom.name.trim();

  final week = data.week > 0 ? data.week : fallbackWeek;
  final subjectNames = _subjectNames(data.subjects);

  return WeeklyPlanUiModel(
    title: '${s.studyPlanTitlePrefix} $classroomName',
    classroomName: classroomName,
    weekName: '${s.week} $week',
    subjectNames: subjectNames,
    days: _orderedDays
        .map(
          (day) => PlanDayUiModel(
            dayName: localizedPlanDayName(s, day),
            subjects: _subjectsForDay(data.subjects, subjectNames, day),
          ),
        )
        .toList(growable: false),
  );
}

bool isWeeklyPlansEmpty(WeeklyPlansResponseModel response) {
  final subjects = response.data.subjects;

  return subjects.isEmpty || subjects.every((subject) => subject.plans.isEmpty);
}

List<String> _subjectNames(List<WeeklyPlanSubjectModel> subjects) {
  final names = <String>[];
  final seen = <String>{};

  for (final subject in subjects) {
    final name = subject.name.trim();

    if (name.isNotEmpty && seen.add(name)) {
      names.add(name);
    }
  }

  return names;
}

List<PlanSubjectUiModel> _subjectsForDay(
  List<WeeklyPlanSubjectModel> subjects,
  List<String> subjectNames,
  String day,
) {
  final result = <PlanSubjectUiModel>[];
  final normalizedDay = normalizePlanDay(day);

  for (final name in subjectNames) {
    final matchingPlans = subjects
        .where((subject) => subject.name.trim() == name)
        .expand((subject) => subject.plans);

    final plan = matchingPlans
        .where((item) => normalizePlanDay(item.day) == normalizedDay)
        .firstOrNull;

    if (plan == null) {
      continue;
    }

    result.add(
      PlanSubjectUiModel(
        subjectName: name,
        lesson: plan.sessionContent.trim(),
        homework: plan.sessionAssignment.trim(),
      ),
    );
  }

  return result;
}

String normalizePlanDay(String value) {
  final normalizedValue = value.trim().toLowerCase();

  return _planDaysMap[normalizedValue] ?? normalizedValue;
}

String localizedPlanDayName(S s, String apiDay) {
  return switch (normalizePlanDay(apiDay)) {
    'sunday' => s.sunday,
    'monday' => s.monday,
    'tuesday' => s.tuesday,
    'wednesday' => s.wednesday,
    'thursday' => s.thursday,
    _ => apiDay,
  };
}
