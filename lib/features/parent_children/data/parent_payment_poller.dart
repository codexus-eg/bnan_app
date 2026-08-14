import 'package:bnan_app/core/error/failure.dart';
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
    this.interval = const Duration(seconds: 3),
    this.maxAttempts = 20,
  });
  final Duration interval;
  final int maxAttempts;

  Future<ParentPaymentPollResult<T>> poll({
    ParentPaymentRequest<T>? reconcile,
    required ParentPaymentRequest<T> status,
    required bool Function(T value) isTerminal,
    required bool Function() canContinue,
  }) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      if (!canContinue()) {
        return const ParentPaymentPollResult(
          ParentPaymentPollOutcome.cancelled,
        );
      }
      if (attempt > 0) await Future<void>.delayed(interval);
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
    }
    return const ParentPaymentPollResult(ParentPaymentPollOutcome.timedOut);
  }
}
