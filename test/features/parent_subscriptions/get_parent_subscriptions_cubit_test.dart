import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscriptions_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/get_parent_subscriptions_cubit/get_parent_subscriptions_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/get_parent_subscriptions_cubit/get_parent_subscriptions_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'child selector switches and refresh preserves selected child',
    () async {
      final repo = _Repo();
      final cubit = GetParentSubscriptionsCubit(repo);
      await cubit.load();
      cubit.selectChild('child-2');
      expect(
        (cubit.state as GetParentSubscriptionsSuccess).selectedChildId,
        'child-2',
      );
      await cubit.load();
      expect(
        (cubit.state as GetParentSubscriptionsSuccess).selectedChildId,
        'child-2',
      );
      await cubit.close();
    },
  );

  test('initial load selects a child that has subscriptions', () async {
    final cubit = GetParentSubscriptionsCubit(_Repo());
    await cubit.load();

    final state = cubit.state as GetParentSubscriptionsSuccess;
    expect(state.selectedChildId, 'child-2');
    expect(state.selectedChild?.subscriptions, isNotEmpty);
    await cubit.close();
  });

  test('concurrent loads share one active repository request', () async {
    final repo = _PendingRepo();
    final cubit = GetParentSubscriptionsCubit(repo);

    final first = cubit.load();
    final second = cubit.load();

    expect(repo.calls, 1);
    repo.completer.complete(const Right(ParentSubscriptionsResponse()));
    await Future.wait([first, second]);
    expect(repo.calls, 1);
    await cubit.close();
  });
}

class _PendingRepo implements ParentSubscriptionsRepo {
  final completer = Completer<Either<Failure, ParentSubscriptionsResponse>>();
  int calls = 0;

  @override
  Future<Either<Failure, ParentSubscriptionsResponse>> getSubscriptions() {
    calls++;
    return completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Repo implements ParentSubscriptionsRepo {
  @override
  getSubscriptions() async => const Right(
    ParentSubscriptionsResponse(
      children: [
        ParentChildSubscriptionsModel(
          studentId: 'child-1',
          studentName: 'One',
          subscriptions: [],
        ),
        ParentChildSubscriptionsModel(
          studentId: 'child-2',
          studentName: 'Two',
          subscriptions: [
            ParentChildSubscriptionModel(
              id: 'subscription',
              packageId: 'package',
              packageName: 'Package',
              curriculumId: 'curriculum',
            ),
          ],
        ),
      ],
    ),
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
