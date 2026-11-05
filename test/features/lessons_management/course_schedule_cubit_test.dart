import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/lessons_management/data/models/course_schedule_payloads.dart';
import 'package:bnan_app/features/lessons_management/data/models/course_schedule_slot.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_gulf_schedule_repo.dart';

void main() {
  const courseClass = GulfClassroom(
    id: '6ab19146ec1d53b0f35da805',
    name: 'دورة تجريبيه - Group 5DA804',
    classroomSubject: '6ab191461217df6a1ade0707',
  );

  test('Course classroom loads course schedule via getCourseSchedule', () async {
    final repo = FakeGulfScheduleRepo(classrooms: [courseClass]);
    repo.courseScheduleResponse = const CourseScheduleResponse(
      success: true,
      timezone: 'Africa/Cairo',
      slots: [
        CourseScheduleSlot(
          slotId: 'csl_test_1',
          day: 'saturday',
          startTime: '08:55',
          endTime: '10:56',
        ),
      ],
    );

    final cubit = GulfScheduleCubit(repo);
    await cubit.load();

    expect(cubit.state.status, GulfScheduleLoadStatus.ready);
    final classroom = cubit.state.selectedClassroom;
    expect(classroom?.isCourse, isTrue);
    expect(classroom?.schedule?.entries.length, 1);
    expect(classroom?.schedule?.entries.first.slotId, 'csl_test_1');
    expect(classroom?.schedule?.entries.first.day, 'saturday');
    await cubit.close();
  });

  test('Course deleteEntry calls deleteCourseScheduleSlot with slotId', () async {
    final repo = FakeGulfScheduleRepo(classrooms: [courseClass]);
    repo.courseScheduleResponse = const CourseScheduleResponse(
      success: true,
      timezone: 'Africa/Cairo',
      slots: [
        CourseScheduleSlot(
          slotId: 'csl_test_delete',
          day: 'saturday',
          startTime: '08:55',
          endTime: '10:56',
        ),
      ],
    );

    final cubit = GulfScheduleCubit(repo);
    await cubit.load();

    final success = await cubit.deleteEntry(
      'saturday',
      entryId: 'csl_test_delete',
    );
    expect(success, isTrue);
    expect(repo.lastOperation, 'delete_course_slot');
    expect(repo.lastClassroomId, '6ab19146ec1d53b0f35da805');
    expect(repo.lastDeletedSlotId, 'csl_test_delete');
    await cubit.close();
  });

  test('Course deleteEntry failure retains entries in state', () async {
    final repo = FakeGulfScheduleRepo(classrooms: [courseClass]);
    repo.courseScheduleResponse = const CourseScheduleResponse(
      success: true,
      timezone: 'Africa/Cairo',
      slots: [
        CourseScheduleSlot(
          slotId: 'csl_keep',
          day: 'saturday',
          startTime: '08:55',
          endTime: '10:56',
        ),
      ],
    );

    final cubit = GulfScheduleCubit(repo);
    await cubit.load();
    cubit.selectDay('saturday');
    repo.saveFailure = Failure(message: 'Delete failed');

    final success = await cubit.deleteEntry('saturday', entryId: 'csl_keep');
    expect(success, isFalse);
    expect(cubit.state.actionError, 'Delete failed');
    expect(cubit.state.selectedClassroom?.schedule?.entries.length, 1);
    await cubit.close();
  });

  test('Course saveEntry updates course schedule preserving slotId', () async {
    final repo = FakeGulfScheduleRepo(classrooms: [courseClass]);
    repo.courseScheduleResponse = const CourseScheduleResponse(
      success: true,
      timezone: 'Africa/Cairo',
      slots: [
        CourseScheduleSlot(
          slotId: 'csl_existing',
          day: 'saturday',
          startTime: '08:55',
          endTime: '10:56',
        ),
      ],
    );

    final cubit = GulfScheduleCubit(repo);
    await cubit.load();

    final ok = await cubit.saveEntry(
      originalDay: 'saturday',
      day: 'saturday',
      startTime: '09:00',
      endTime: '11:00',
    );

    expect(ok, isTrue);
    expect(repo.lastOperation, 'put_course_schedule');
    expect(repo.lastCourseScheduleUpdate?.slots.length, 1);
    final updatedSlot = repo.lastCourseScheduleUpdate!.slots.first;
    expect(updatedSlot.slotId, 'csl_existing');
    expect(updatedSlot.startTime, '09:00');
    expect(updatedSlot.endTime, '11:00');
    await cubit.close();
  });
}
