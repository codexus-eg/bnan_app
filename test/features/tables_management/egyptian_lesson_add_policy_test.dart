import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/egyptian_schedule_management_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/policies/egyptian_lesson_add_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('add lesson stays disabled while data is loading', () {
    expect(
      egyptianLessonAddAvailability(const EgyptianScheduleState()),
      EgyptianLessonAddAvailability.disabled,
    );
  });

  test('loaded classroom without subjects reports no subjects', () {
    const state = EgyptianScheduleState(status: EgyptianScheduleStatus.ready);
    expect(
      egyptianLessonAddAvailability(state),
      EgyptianLessonAddAvailability.noSubjects,
    );
  });

  test('loaded classroom with subjects can open add lesson', () {
    const subject = EgyptianClassroomSubject(
      classroomSubjectId: 'classroom-subject',
      subjectId: 'subject',
      subjectName: 'Math',
    );
    const state = EgyptianScheduleState(
      status: EgyptianScheduleStatus.ready,
      subjects: [subject],
    );
    expect(
      egyptianLessonAddAvailability(state),
      EgyptianLessonAddAvailability.available,
    );
  });
}
