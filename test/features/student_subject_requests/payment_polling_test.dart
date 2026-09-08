import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payloads.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'payment_flow_fixture.dart';

void main() {
  for (final provider in GulfPaymentProvider.values) {
    for (final terminal in [
      SubjectRequestPaymentStatus.completed,
      SubjectRequestPaymentStatus.failed,
      SubjectRequestPaymentStatus.cancelled,
    ]) {
      test(
        '${provider.name} polling stops at ${terminal.name} and retains request',
        () async {
          final h = PaymentFlowFixture();
          addTearDown(h.close);
          await h.request.load();
          h.request.selectSubject('enabled');
          h.request.selectPackage('valid');
          h.request.updateNotes('Algebra lesson');
          h.repo.checkoutResults.add(
            Right(paymentResult(SubjectRequestPaymentStatus.pending)),
          );
          h.repo.statusResults.addAll([
            Right(paymentResult(SubjectRequestPaymentStatus.pending)),
            Right(paymentResult(terminal)),
            Right(paymentResult(SubjectRequestPaymentStatus.pending)),
          ]);
          await h.payment.checkout(
            GulfSubjectRequestPayload(
              subjectId: 'enabled',
              packageId: 'valid',
              curriculumId: 'c1',
              notes: 'Algebra lesson',
              provider: provider,
              paymentAddress: const PaymentAddress(
                city: 'Riyadh',
                region: 'Riyadh',
                line1: 'Road',
              ),
            ),
          );
          await h.payment.verify(reconcileFirst: true);
          expect(h.repo.statusCalls, 2);
          expect(h.repo.statusResults, hasLength(1));
          expect(
            h.repo.reconcileCalls,
            provider == GulfPaymentProvider.tamara ? 1 : 0,
          );
          expect(h.payment.state.payment?.status, terminal);
          expect(
            h.payment.state.phase,
            terminal == SubjectRequestPaymentStatus.completed
                ? SubjectRequestPaymentPhase.completed
                : SubjectRequestPaymentPhase.terminalFailure,
          );
          expect(h.store.draft, isNull);
          expect(h.request.state.selectedSubjectId, 'enabled');
          expect(h.request.state.selectedPackageId, 'valid');
          expect(h.request.state.notes, 'Algebra lesson');
        },
      );
    }
  }
}
