import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_gulf_schedule_repo.dart';

void main() {
  const sunday = GulfScheduleEntry(
    id: 'entry-sun',
    day: 'sunday',
    startTime: '18:00',
    endTime: '19:00',
  );

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

  test('load with initialClassId auto-selects matching classroom', () async {
    final repo = FakeGulfScheduleRepo(classrooms: [
      gulfClassroom(id: 'class-1'),
      gulfClassroom(id: 'class-2'),
    ]);
    final cubit = GulfScheduleCubit(repo, initialClassId: 'class-2');
    await cubit.load();
    expect(cubit.state.status, GulfScheduleLoadStatus.ready);
    expect(cubit.state.selectedClassroomId, 'class-2');
    await cubit.close();
  });

  test('load method argument initialClassId overrides state classroom', () async {
    final repo = FakeGulfScheduleRepo(classrooms: [
      gulfClassroom(id: 'class-1'),
      gulfClassroom(id: 'class-2'),
    ]);
    final cubit = GulfScheduleCubit(repo);
    await cubit.load(initialClassId: 'class-2');
    expect(cubit.state.status, GulfScheduleLoadStatus.ready);
    expect(cubit.state.selectedClassroomId, 'class-2');
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

  test('saveEntry calls updateClassroomSchedule with full weekly schedule', () async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [gulfClassroom(withSchedule: false)],
    );
    final cubit = GulfScheduleCubit(repo);
    await cubit.load();
    expect(
      await cubit.saveEntry(
        day: 'sunday',
        startTime: '18:00',
        endTime: '19:00',
      ),
      isTrue,
    );
    expect(repo.lastOperation, 'put');
    expect(repo.lastClassroomId, 'class-1');
    expect(repo.lastRequest?.schedule, hasLength(1));
    expect(repo.lastRequest?.schedule.single.day, 'sunday');
    await cubit.close();
  });

  test('add and edit existing schedule use updateClassroomSchedule', () async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(entries: const [sunday]),
      ],
    );
    final cubit = GulfScheduleCubit(repo);
    await cubit.load();
    await cubit.saveEntry(
      day: 'tuesday',
      startTime: '19:00',
      endTime: '20:00',
    );
    expect(repo.lastOperation, 'put');
    expect(repo.lastRequest?.schedule, hasLength(2));
    await cubit.saveEntry(
      originalDay: 'tuesday',
      day: 'wednesday',
      startTime: '20:00',
      endTime: '21:00',
    );
    expect(repo.lastOperation, 'put');
    expect(repo.lastRequest?.schedule, hasLength(2));
    expect(
      repo.lastRequest?.schedule.map((e) => e.day).toSet(),
      {'sunday', 'wednesday'},
    );
    await cubit.close();
  });

  test(
    'delete uses updateClassroomSchedule with remaining entries',
    () async {
      final repo = FakeGulfScheduleRepo(
        classrooms: [
          gulfClassroom(
            entries: const [
              sunday,
              GulfScheduleEntry(
                id: 'entry-tue',
                day: 'tuesday',
                startTime: '19:00',
                endTime: '20:00',
              ),
            ],
          ),
        ],
      );
      final cubit = GulfScheduleCubit(repo);
      await cubit.load();
      await cubit.deleteEntry('tuesday');
      expect(repo.lastOperation, 'put');
      expect(repo.lastRequest?.schedule, hasLength(1));
      expect(repo.lastRequest?.schedule.single.day, 'sunday');
      await cubit.deleteEntry('sunday');
      expect(repo.lastOperation, 'put');
      expect(repo.lastRequest?.schedule, isEmpty);
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
    expect(
      await cubit.saveEntry(
        day: 'sunday',
        startTime: '20:00',
        endTime: '21:00',
      ),
      isFalse,
    );
    expect(cubit.state.actionIssue, GulfScheduleIssue.duplicateDay);
    repo.classrooms = [
      gulfClassroom(withSchedule: false, classroomSubject: null),
    ];
    await cubit.load();
    expect(
      await cubit.saveEntry(
        day: 'monday',
        startTime: '10:00',
        endTime: '11:00',
      ),
      isFalse,
    );
    expect(cubit.state.actionIssue, GulfScheduleIssue.missingClassroomSubject);
    await cubit.close();
  });

  test('rejects invalid day or non-HH:mm time before any request', () async {
    final repo = FakeGulfScheduleRepo(classrooms: [gulfClassroom()]);
    final cubit = GulfScheduleCubit(repo);
    await cubit.load();
    expect(
      await cubit.saveEntry(
        day: 'Sunday',
        startTime: '18:00',
        endTime: '19:00',
      ),
      isFalse,
    );
    expect(
      await cubit.saveEntry(
        day: 'sunday',
        startTime: '25:00',
        endTime: '23:00',
      ),
      isFalse,
    );
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

  test(
    'individual entry deletion and recreation preserves classroom and updates entry list',
    () async {
      const mondayEntry = GulfScheduleEntry(
        id: 'entry-mon',
        day: 'monday',
        startTime: '23:23',
        endTime: '23:59',
        classroomSubjectId: 'cs-math',
      );
      final repo = FakeGulfScheduleRepo(
        classrooms: [
          gulfClassroom(
            id: '6ab19146ec1d53b0f35da805',
            classroomSubject: 'cs-math',
            entries: const [mondayEntry],
          ),
        ],
      );
      final cubit = GulfScheduleCubit(repo);
      await cubit.load();
      expect(cubit.state.selectedClassroom?.entries, hasLength(1));
      expect(cubit.state.selectedClassroom?.entries.first.day, 'monday');

      // 1. Delete the individual entry
      final deleted = await cubit.deleteEntry('monday', entryId: 'entry-mon');
      expect(deleted, isTrue);
      expect(repo.lastOperation, 'put');
      expect(repo.lastClassroomId, '6ab19146ec1d53b0f35da805');
      expect(repo.lastRequest?.schedule, isEmpty);
      expect(cubit.state.selectedClassroom?.entries, isEmpty);

      // 2. Add new Saturday appointment
      final added = await cubit.saveEntry(
        day: 'saturday',
        startTime: '06:24',
        endTime: '08:25',
      );
      expect(added, isTrue);
      expect(repo.lastOperation, 'put');
      expect(repo.lastClassroomId, '6ab19146ec1d53b0f35da805');
      expect(repo.lastRequest?.schedule, hasLength(1));
      expect(repo.lastRequest?.schedule.single.day, 'saturday');
      expect(repo.lastRequest?.schedule.single.startTime, '06:24');
      expect(repo.lastRequest?.schedule.single.endTime, '08:25');
      expect(cubit.state.selectedClassroom?.entries, hasLength(1));
      expect(cubit.state.selectedClassroom?.entries.first.day, 'saturday');
      expect(cubit.state.selectedClassroom?.entries.first.startTime, '06:24');
      expect(cubit.state.selectedClassroom?.entries.first.endTime, '08:25');

      // 3. deleteSelectedDay deletes current day and sends PUT with remaining entries
      cubit.selectDay('saturday');
      final deletedSelected = await cubit.deleteSelectedDay();
      expect(deletedSelected, isTrue);
      expect(repo.lastOperation, 'put');
      expect(repo.lastRequest?.schedule, isEmpty);
      expect(cubit.state.selectedClassroom?.entries, isEmpty);
      await cubit.close();
    },
  );
}

GulfSchedulesResponse _response(List<GulfClassroom> classrooms) =>
    GulfSchedulesResponse(
      success: true,
      data: GulfSchedulesData(classrooms: classrooms),
    );
