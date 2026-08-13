import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payrolls/teacher_payrolls_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payrolls/teacher_payrolls_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_teacher_payroll_repo.dart';

void main() {
  test('normal success emits the returned payroll data', () async {
    final repo = _ControlledRepo()..enqueue(Right([_item('success')]));
    final cubit = TeacherPayrollsCubit(repo);
    await cubit.load(from: '2026-08-01', to: '2026-08-31');
    expect(
      (cubit.state as TeacherPayrollsSuccess).items.single.teacherId,
      'success',
    );
  });

  test('error keeps the previous data contract', () async {
    final repo = _ControlledRepo()
      ..enqueue(Left(Failure(message: 'network failure')));
    final cubit = TeacherPayrollsCubit(repo);
    await cubit.load(from: '2026-08-01', to: '2026-08-31');
    expect(cubit.state, isA<TeacherPayrollsFailure>());
  });

  test('same request key is deduplicated while pending', () async {
    final repo = _ControlledRepo()..enqueuePending();
    final cubit = TeacherPayrollsCubit(repo);
    final first = cubit.load(from: '2026-08-01', to: '2026-08-31');
    await Future<void>.delayed(Duration.zero);
    final second = cubit.load(from: '2026-08-01', to: '2026-08-31');
    repo.completeNext(const Right([]));
    await Future.wait([first, second]);
    expect(repo.listPreviewLoads, 1);
  });

  test('pending request can finish after cubit closes', () async {
    final repo = _ControlledRepo()..enqueuePending();
    final cubit = TeacherPayrollsCubit(repo);
    final load = cubit.load(from: '2026-08-01', to: '2026-08-31');
    await Future<void>.delayed(Duration.zero);
    await cubit.close();
    repo.completeNext(Right([_item('late')]));
    await expectLater(load, completes);
  });

  test('refresh can finish after navigation closes cubit', () async {
    final repo = _ControlledRepo()..enqueuePending();
    final cubit = TeacherPayrollsCubit(repo);
    final refresh = cubit.load(
      from: '2026-08-01',
      to: '2026-08-31',
      status: 'paid',
    );
    await Future<void>.delayed(Duration.zero);
    await cubit.close();
    repo.completeNext(const Right([]));
    await expectLater(refresh, completes);
  });

  test(
    'filter reload starts immediately and ignores the older result',
    () async {
      final repo = _ControlledRepo()
        ..enqueuePending()
        ..enqueuePending();
      final cubit = TeacherPayrollsCubit(repo);
      final old = cubit.load(from: '2026-08-01', to: '2026-08-31');
      await Future<void>.delayed(Duration.zero);
      final latest = cubit.load(
        from: '2026-08-01',
        to: '2026-08-31',
        teacherId: 'new',
      );
      await Future<void>.delayed(Duration.zero);
      repo.completeAt(1, Right([_item('new')]));
      await latest;
      repo.completeAt(0, Right([_item('old')]));
      await old;
      expect(
        (cubit.state as TeacherPayrollsSuccess).items.single.teacherId,
        'new',
      );
    expect(repo.listPreviewLoads, 2);
    },
  );
}

class _ControlledRepo extends FakeTeacherPayrollRepo {
  final requests = <Completer<Either<Failure, List<PayrollListItemModel>>>>[];
  int listPreviewLoads = 0;

  void enqueue(Either<Failure, List<PayrollListItemModel>> value) {
    enqueuePending();
    requests.last.complete(value);
  }

  void enqueuePending() => requests.add(Completer());
  void completeNext(Either<Failure, List<PayrollListItemModel>> value) =>
      requests.firstWhere((request) => !request.isCompleted).complete(value);
  void completeAt(
    int index,
    Either<Failure, List<PayrollListItemModel>> value,
  ) => requests[index].complete(value);

  @override
  getPreviewList({
    required String from,
    required String to,
    String? teacherId,
  }) {
    return requests[listPreviewLoads++].future;
  }
}

PayrollListItemModel _item(String id) => PayrollListItemModel(
  teacherId: id,
  fullName: id,
  email: '$id@bnan.test',
  status: 'paid',
  payrollId: id,
  gulfDuration: '',
  egyptianSessions: 0,
  curriculumsCount: 0,
  excludedSessions: 0,
);
