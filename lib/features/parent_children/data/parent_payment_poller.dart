import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/payments/data/gulf_payment_polling_policy.dart';
import 'package:dartz/dartz.dart';

typedef ParentPaymentRequest<T> = Future<Either<Failure, T>> Function();

enum ParentPaymentPollOutcome { terminal, timedOut, cancelled }

class ParentPaymentPollResult<T> {
  const ParentPaymentPollResult(this.outcome, [this.value]);
  final ParentPaymentPollOutcome outcome;
  final T? value;
}

class ParentPaymentPoller<T> {
  const ParentPaymentPoller({
    this.interval,
    this.maxAttempts,
    this.policy = const GulfPaymentPollingPolicy(),
  });
  final Duration? interval;
  final int? maxAttempts;
  final GulfPaymentPollingPolicy policy;

  Future<ParentPaymentPollResult<T>> poll({
    ParentPaymentRequest<T>? reconcile,
    required ParentPaymentRequest<T> status,
    required bool Function(T value) isTerminal,
    required bool Function() canContinue,
  }) async {
    var attempt = 0;
    var elapsed = Duration.zero;
    while (maxAttempts == null || attempt < maxAttempts!) {
      if (!canContinue()) {
        return const ParentPaymentPollResult(
          ParentPaymentPollOutcome.cancelled,
        );
      }
      if (attempt > 0) {
        final delay = interval ?? policy.nextDelay(elapsed);
        if (delay == null) break;
        await Future<void>.delayed(delay);
        elapsed += delay;
      }
      if (!canContinue()) {
        return const ParentPaymentPollResult(
          ParentPaymentPollOutcome.cancelled,
        );
      }
      T? response;
      if (reconcile != null && attempt == 0) {
        (await reconcile()).fold((_) {}, (value) => response = value);
      }
      if (response == null || !isTerminal(response as T)) {
        (await status()).fold((_) {}, (value) => response = value);
      }
      if (response != null && isTerminal(response as T)) {
        return ParentPaymentPollResult(
          ParentPaymentPollOutcome.terminal,
          response,
        );
      }
      attempt++;
    }
    return const ParentPaymentPollResult(ParentPaymentPollOutcome.timedOut);
  }
}
