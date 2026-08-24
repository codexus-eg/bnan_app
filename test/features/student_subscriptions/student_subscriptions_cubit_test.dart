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

  test('local pending marks only the renewed subscription', () async {
    final cubit = StudentSubscriptionsCubit(_StaticRepo());
    await cubit.load();

    cubit.markRenewalPending('subscription-1');

    expect(cubit.isRenewalPending('subscription-1'), isTrue);
    expect(cubit.isRenewalPending('subscription-2'), isFalse);
    await cubit.close();
  });
}

class _StaticRepo implements StudentSubscriptionsRepo {
  @override
  getSubscriptions() async => const Right(_student);
  @override
  getHomeSubscriptions() => getSubscriptions();
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
  subscriptions: [
    ParentChildSubscriptionModel(
      id: 'subscription-1',
      packageId: 'package-1',
      packageName: 'One',
      curriculumId: 'curriculum',
    ),
    ParentChildSubscriptionModel(
      id: 'subscription-2',
      packageId: 'package-2',
      packageName: 'Two',
      curriculumId: 'curriculum',
    ),
  ],
);
