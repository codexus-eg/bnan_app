import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_gulf_schedule_repo.dart';

void main() {
  const sunday = GulfScheduleEntry(day: 'sunday', startTime: '18:00');

  test('load selects first classroom and handles empty/failure', () async {
    final repo = FakeGulfScheduleRepo(classrooms: [gulfClassroom()]);
    final cubit = GulfScheduleCubit(repo);
    await cubit.load();
    expect(cubit.state.status, GulfScheduleLoadStatus.ready);
    expect(cubit.state.selectedClassroomId, 'class-1');
    repo.loadFailure = Failure(message: 'failed');
    await cubit.load();
    expect(cubit.state.loadError, 'failed');
    await cubit.close();
  });

  test('one load keeps every classroom with one repository request', () async {
    final repo = FakeGulfScheduleRepo(
      classrooms: List.generate(70, (index) => gulfClassroom(id: 'c-$index')),
    );
    final cubit = GulfScheduleCubit(repo);

    await cubit.load();

    expect(repo.loadCalls, 1);
    expect(cubit.state.classrooms, hasLength(70));
    await cubit.close();
  });

  test('first entry uses POST with explicit classroomSubject', () async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [gulfClassroom(withSchedule: false)],
    );
    final cubit = GulfScheduleCubit(repo);
    await cubit.load();
    expect(await cubit.saveEntry(day: 'sunday', startTime: '18:00'), isTrue);
    expect(repo.lastOperation, 'post');
    expect(repo.lastRequest?.classroomSubject, 'classroom-subject-1');
    await cubit.close();
  });

  test('add and edit existing schedule use PUT with full list', () async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(entries: const [sunday]),
      ],
    );
    final cubit = GulfScheduleCubit(repo);
    await cubit.load();
    await cubit.saveEntry(day: 'tuesday', startTime: '19:00');
    expect(repo.lastOperation, 'put');
    expect(repo.lastRequest?.schedule.length, 2);
    await cubit.saveEntry(
      originalDay: 'tuesday',
      day: 'wednesday',
      startTime: '20:00',
    );
    expect(
      repo.lastRequest?.schedule.map((item) => item.day),
      containsAll(['sunday', 'wednesday']),
    );
    await cubit.close();
  });

  test(
    'delete uses PUT when entries remain and DELETE for last entry',
    () async {
      final repo = FakeGulfScheduleRepo(
        classrooms: [
          gulfClassroom(
            entries: const [
              sunday,
              GulfScheduleEntry(day: 'tuesday', startTime: '19:00'),
            ],
          ),
        ],
      );
      final cubit = GulfScheduleCubit(repo);
      await cubit.load();
      await cubit.deleteEntry('tuesday');
      expect(repo.lastOperation, 'put');
      expect(repo.lastRequest?.schedule.single.day, 'sunday');
      await cubit.deleteEntry('sunday');
      expect(repo.lastOperation, 'delete');
      await cubit.close();
    },
  );

  test('rejects duplicate day and missing classroomSubject', () async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(entries: const [sunday]),
      ],
    );
    final cubit = GulfScheduleCubit(repo);
    await cubit.load();
    expect(await cubit.saveEntry(day: 'sunday', startTime: '20:00'), isFalse);
    expect(cubit.state.actionIssue, GulfScheduleIssue.duplicateDay);
    repo.classrooms = [
      gulfClassroom(withSchedule: false, classroomSubject: null),
    ];
    await cubit.load();
    expect(await cubit.saveEntry(day: 'monday', startTime: '10:00'), isFalse);
    expect(cubit.state.actionIssue, GulfScheduleIssue.missingClassroomSubject);
    await cubit.close();
  });

  test('rejects invalid day or non-HH:mm time before any request', () async {
    final repo = FakeGulfScheduleRepo(classrooms: [gulfClassroom()]);
    final cubit = GulfScheduleCubit(repo);
    await cubit.load();
    expect(await cubit.saveEntry(day: 'Sunday', startTime: '18:00'), isFalse);
    expect(await cubit.saveEntry(day: 'sunday', startTime: '25:00'), isFalse);
    expect(repo.lastOperation, isNull);
    expect(cubit.state.actionIssue, GulfScheduleIssue.invalidData);
    await cubit.close();
  });

  test('refresh preserves selected classroom and selected day', () async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(id: 'class-1'),
        gulfClassroom(id: 'class-2'),
      ],
    );
    final cubit = GulfScheduleCubit(repo);
    await cubit.load();
    cubit.selectClassroom('class-2');
    cubit.selectDay('thursday');
    await cubit.load();
    expect(cubit.state.selectedClassroomId, 'class-2');
    expect(cubit.state.selectedDay, 'thursday');
    await cubit.close();
  });

  test('ignores an older overlapping load response', () async {
    final repo = FakeGulfScheduleRepo();
    final firstResult = Completer<Either<Failure, GulfSchedulesResponse>>();
    final secondResult = Completer<Either<Failure, GulfSchedulesResponse>>();
    repo.queuedLoads.addAll([firstResult, secondResult]);
    final cubit = GulfScheduleCubit(repo);
    final firstLoad = cubit.load();
    final secondLoad = cubit.load();
    secondResult.complete(Right(_response([gulfClassroom(id: 'new')])));
    await secondLoad;
    firstResult.complete(Right(_response([gulfClassroom(id: 'old')])));
    await firstLoad;
    expect(cubit.state.selectedClassroomId, 'new');
    await cubit.close();
  });
}

GulfSchedulesResponse _response(List<GulfClassroom> classrooms) =>
    GulfSchedulesResponse(
      success: true,
      data: GulfSchedulesData(classrooms: classrooms),
    );
