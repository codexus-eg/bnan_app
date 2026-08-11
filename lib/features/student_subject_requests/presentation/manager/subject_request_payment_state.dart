import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payment.dart';

enum SubjectRequestPaymentPhase {
  idle,
  creatingCheckout,
  openingTamara,
  verifying,
  completed,
  terminalFailure,
  verificationTimeout,
  failure,
}

class SubjectRequestPaymentState {
  const SubjectRequestPaymentState({
    this.phase = SubjectRequestPaymentPhase.idle,
    this.payment,
    this.message,
  });
  final SubjectRequestPaymentPhase phase;
  final SubjectRequestPayment? payment;
  final String? message;
}
