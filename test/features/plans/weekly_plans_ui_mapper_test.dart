import 'package:bnan_app/features/plans/data/models/plan_classroom_model.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:bnan_app/features/plans/presentation/mappers/elapsed_weeks_selection_mapper.dart';
import 'package:bnan_app/features/plans/presentation/mappers/weekly_plans_ui_mapper.dart';
import 'package:bnan_app/features/plans/presentation/models/weekly_plan_ui_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps Sunday through Thursday and matches day casing', () {
    final ui = _map([
      _subject('Math', [
        const DailyPlanItemModel(
          day: 'SUNDAY',
          sessionContent: ' Lesson ',
          sessionAssignment: ' Homework ',
        ),
      ]),
    ]);

    expect(ui.days.map((day) => day.dayName), [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
    ]);
    expect(ui.days.first.subjects.single.lesson, 'Lesson');
    expect(ui.days.first.subjects.single.homework, 'Homework');
    expect(ui.days[1].subjects, isEmpty);
  });

  test('keeps subject order, deduplicates names, and keeps empty values', () {
    final ui = _map([
      _subject('Arabic', const []),
      _subject('Math', [const DailyPlanItemModel(day: 'monday')]),
      _subject('Arabic', [const DailyPlanItemModel(day: 'Tuesday')]),
    ]);

    expect(ui.subjectNames, ['Arabic', 'Math']);
    expect(ui.days[1].subjects.single.lesson, '');
    expect(ui.days[1].subjects.single.homework, '');
    expect(ui.days[2].subjects.single.subjectName, 'Arabic');
  });

  test('detects empty weekly responses', () {
    expect(isWeeklyPlansEmpty(const WeeklyPlansResponseModel()), isTrue);
    expect(isWeeklyPlansEmpty(_response([_subject('Math', const [])])), isTrue);
    expect(
      isWeeklyPlansEmpty(
        _response([
          _subject('Math', [const DailyPlanItemModel(day: 'sunday')]),
        ]),
      ),
      isFalse,
    );
  });

  test('uses current week when valid and week one as invalid fallback', () {
    expect(resolveInitialPlanWeek(weeksCount: 5), 1);
    expect(resolveInitialPlanWeek(weeksCount: 0), isNull);
  });
}

WeeklyPlanUiModel _map(List<WeeklyPlanSubjectModel> subjects) {
  return mapWeeklyPlansToUiModel(
    S(),
    _response(subjects),
    fallbackClassroomName: 'Fallback',
    fallbackWeek: 1,
  );
}

WeeklyPlansResponseModel _response(List<WeeklyPlanSubjectModel> subjects) {
  return WeeklyPlansResponseModel(
    data: WeeklyPlansDataModel(
      classroom: const PlanClassroomModel(id: '1', name: 'Class A'),
      week: 2,
      subjects: subjects,
    ),
  );
}

WeeklyPlanSubjectModel _subject(String name, List<DailyPlanItemModel> plans) {
  return WeeklyPlanSubjectModel(id: name, name: name, plans: plans);
}
