import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/student_subscriptions/data/repo/student_subscriptions_repo.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('concurrent loads share one active repository request', () async {
    final repo = _PendingRepo();
    final cubit = StudentSubscriptionsCubit(repo);

    final first = cubit.load();
    final second = cubit.load();

    expect(repo.calls, 1);
    repo.completer.complete(const Right(_student));
    await Future.wait([first, second]);
    expect(repo.calls, 1);
    await cubit.close();
  });
}

class _PendingRepo implements StudentSubscriptionsRepo {
  final completer = Completer<Either<Failure, ParentChildSubscriptionsModel>>();
  int calls = 0;

  @override
  Future<Either<Failure, ParentChildSubscriptionsModel>> getSubscriptions() {
    calls++;
    return completer.future;
  }

  @override
  Future<Either<Failure, ParentChildSubscriptionsModel>>
  getHomeSubscriptions() => getSubscriptions();
}

const _student = ParentChildSubscriptionsModel(
  studentId: 'student-1',
  studentName: 'Student',
  subscriptions: [],
);
