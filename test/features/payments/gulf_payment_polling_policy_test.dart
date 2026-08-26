import 'package:bnan_app/features/payments/data/gulf_payment_polling_policy.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = GulfPaymentPollingPolicy();

  test('polling uses 3s then 5s and stops at two minutes', () {
    expect(policy.nextDelay(Duration.zero), const Duration(seconds: 3));
    expect(
      policy.nextDelay(const Duration(seconds: 29)),
      const Duration(seconds: 3),
    );
    expect(
      policy.nextDelay(const Duration(seconds: 30)),
      const Duration(seconds: 5),
    );
    expect(policy.nextDelay(const Duration(minutes: 2)), isNull);
  });

  test('only completed is a successful processing result', () {
    expect(PaymentStatus.authorized.isProcessing, isTrue);
    expect(PaymentStatus.captured.isProcessing, isTrue);
    expect(PaymentStatus.completed.isTerminal, isTrue);
    expect(PaymentStatus.refunded.isTerminal, isTrue);
    expect(PaymentStatus.refunded, isNot(PaymentStatus.completed));
  });
}
