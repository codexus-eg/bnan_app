import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_availability.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payment.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/student_subject_requests_cubit.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/subject_request_payment_cubit.dart';
import 'student_subject_requests_test.dart'
    show FakeRepo, MemoryPaymentStore, SequenceKeyGenerator;

export 'package:bnan_app/core/enums/registration_mode.dart';
export 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
export 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payment.dart';
export 'package:bnan_app/features/student_subject_requests/presentation/manager/subject_request_payment_state.dart';
export 'package:dartz/dartz.dart' show Right;

SubjectRequestPayment paymentResult(SubjectRequestPaymentStatus status) =>
    SubjectRequestPayment(
      paymentId: 'pay-1',
      status: status,
      checkoutUrl: 'https://checkout.example/pay-1',
    );

class PaymentFlowFixture {
  PaymentFlowFixture({RegistrationMode mode = RegistrationMode.gulf}) {
    final original = repo.availability;
    repo.availability = SubjectRequestAvailability(
      curriculum: original.curriculum,
      grade: original.grade,
      subjects: original.subjects,
      registrationMode: mode,
    );
    request = StudentSubjectRequestsCubit(repo);
    payment = SubjectRequestPaymentCubit(
      repo: repo,
      keyGenerator: SequenceKeyGenerator(),
      store: store,
      pollInterval: Duration.zero,
      maxPollAttempts: 3,
    );
  }
  final repo = FakeRepo();
  final store = MemoryPaymentStore();
  late final StudentSubjectRequestsCubit request;
  late final SubjectRequestPaymentCubit payment;
  Future<void> close() async {
    await request.close();
    await payment.close();
  }
}
