import 'package:bnan_app/features/parent_children/data/parent_payment_poller.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'poller returns timedOut instead of leaving processing implicit',
    () async {
      final result =
          await const ParentPaymentPoller<int>(
            interval: Duration.zero,
            maxAttempts: 2,
          ).poll(
            status: () async => const Right(0),
            isTerminal: (value) => value == 1,
            canContinue: () => true,
          );
      expect(result.outcome, ParentPaymentPollOutcome.timedOut);
    },
  );

  test('poller stops when owner is disposed or cancelled', () async {
    final result = await const ParentPaymentPoller<int>().poll(
      status: () async => const Right(0),
      isTerminal: (value) => false,
      canContinue: () => false,
    );
    expect(result.outcome, ParentPaymentPollOutcome.cancelled);
  });

  test('reconcile and status are single sequential operations', () async {
    var active = 0;
    var maxActive = 0;
    Future<Either<Failure, int>> request(int value) async {
      active++;
      if (active > maxActive) maxActive = active;
      await Future<void>.delayed(Duration.zero);
      active--;
      return Right(value);
    }

    final result =
        await const ParentPaymentPoller<int>(
          interval: Duration.zero,
          maxAttempts: 1,
        ).poll(
          reconcile: () => request(0),
          status: () => request(1),
          isTerminal: (value) => value == 1,
          canContinue: () => true,
        );
    expect(result.outcome, ParentPaymentPollOutcome.terminal);
    expect(maxActive, 1);
  });

  test('reconcile runs once before repeated status polling', () async {
    var reconcileCalls = 0;
    var statusCalls = 0;
    final result =
        await const ParentPaymentPoller<int>(
          interval: Duration.zero,
          maxAttempts: 3,
        ).poll(
          reconcile: () async {
            reconcileCalls++;
            return const Right(0);
          },
          status: () async {
            statusCalls++;
            return Right(statusCalls == 3 ? 1 : 0);
          },
          isTerminal: (value) => value == 1,
          canContinue: () => true,
        );

    expect(result.outcome, ParentPaymentPollOutcome.terminal);
    expect(reconcileCalls, 1);
    expect(statusCalls, 3);
  });
}
