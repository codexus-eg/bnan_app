import 'payment_flow_harness.dart';

void main() {
  for (final provider in GulfPaymentProvider.values) {
    for (final closeButton in [false, true]) {
      testWidgets(
        '${provider.name} ${closeButton ? "close" : "Back"} retains form without verification page',
        (tester) async {
          final h = PaymentFlowHarness();
          await h.mount(tester);
          await h.open(tester, provider);
          await h.dismiss(tester, button: closeButton);
          h.expectForm();
          expect(h.payment.state.phase, SubjectRequestPaymentPhase.idle);
          expect(
            h.payment.state.payment?.status,
            SubjectRequestPaymentStatus.pending,
          );
          expect(
            find.text(S.current.subjectRequestVerifyPayment),
            findsNothing,
          );
          expect(find.text(S.current.retry), findsNothing);
          expect(find.text(S.current.parentPaymentFailed), findsNothing);
          expect(find.byType(SnackBar), findsNothing);
          expect(
            h.repo.reconcileCalls,
            provider == GulfPaymentProvider.tamara ? 1 : 0,
          );
          expect(h.repo.statusCalls, 1);
          await tester.tap(find.text(S.current.renewalConfirmPayment));
          await tester.pumpAndSettle();
          expect(h.launches, 2);
          expect(h.repo.checkoutKeys, ['key-1']);
          await h.dismiss(tester);
          expect(h.payment.state.phase, SubjectRequestPaymentPhase.idle);
          expect(find.text(S.current.parentPaymentFailed), findsNothing);
          expect(find.byType(SnackBar), findsNothing);
        },
      );
    }
    for (final status in [
      SubjectRequestPaymentStatus.failed,
      SubjectRequestPaymentStatus.cancelled,
    ]) {
      testWidgets('${provider.name} ${status.name} preserves request fields', (
        tester,
      ) async {
        final h = PaymentFlowHarness();
        await h.mount(tester);
        await h.open(tester, provider);
        h.repo.statusResults.add(Right(paymentResult(status)));
        await h.dismiss(tester, outcome: TamaraSdkOutcome.failure);
        h.expectForm();
        expect(
          h.payment.state.phase,
          SubjectRequestPaymentPhase.terminalFailure,
        );
        expect(h.payment.state.payment?.status, status);
        expect(h.store.draft, isNull);
        expect(find.text(S.current.retry), findsOneWidget);
      });
    }
  }
}
