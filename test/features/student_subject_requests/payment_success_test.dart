import 'payment_flow_harness.dart';

void main() {
  for (final provider in GulfPaymentProvider.values) {
    testWidgets(
      '${provider.name} backend success refreshes availability and returns home',
      (tester) async {
        final h = PaymentFlowHarness();
        await h.mount(tester);
        await h.open(tester, provider);
        h.repo.statusResults.add(
          Right(paymentResult(SubjectRequestPaymentStatus.completed)),
        );
        await h.dismiss(tester, outcome: TamaraSdkOutcome.success);
        expect(find.text('Home'), findsOneWidget);
        expect(find.byType(StudentSubjectRequestsView), findsNothing);
        expect(h.repo.availableCalls, 2);
        expect(h.repo.requestCalls, 0);
        expect(h.store.draft, isNull);
        expect(h.request.state.message, 'subject_request_payment_completed');
        expect(h.payment.state.phase, SubjectRequestPaymentPhase.idle);
      },
    );
  }

  testWidgets(
    'Egyptian request has no gateway options and submits without payment',
    (tester) async {
      final h = PaymentFlowHarness(mode: RegistrationMode.egyptian);
      await h.mount(tester);
      expect(find.text(S.current.paymob), findsNothing);
      expect(find.text(S.current.tabbyTamara), findsNothing);
      await tester.ensureVisible(find.text(S.current.confirmRequest));
      await tester.tap(find.text(S.current.confirmRequest));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(h.request.state.message, 'subject_request_submitted');
      expect(h.launches, 0);
      expect(h.repo.checkoutKeys, isEmpty);
      expect(h.repo.statusCalls, 0);
      expect(h.repo.reconcileCalls, 0);
    },
  );
}
