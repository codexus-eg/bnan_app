import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/generated/l10n.dart';

const _paymentInputCodes = {
  'TAMARA_ADDRESS_REQUIRED',
  'PARENT_PAYMENT_PHONE_REQUIRED',
  'INVALID_PAYMENT_PHONE',
};

bool isParentPaymentInputFailure(Failure failure) {
  final value = (failure.code ?? failure.message).toUpperCase();
  return _paymentInputCodes.any(value.contains);
}

String mapParentFlowFailure(Failure failure, {required String fallback}) {
  final value = (failure.code ?? failure.message).toUpperCase();
  if (value.contains('TAMARA_NOT_SUPPORTED')) return fallback;
  if (value.contains('IDEMPOTENCY_KEY_REUSED')) return fallback;
  if (_paymentInputCodes.any(value.contains)) return failure.message;
  if (value.contains('SUBSCRIPTION_STILL_ACTIVE')) {
    return S.current.renewalSubscriptionStillActive;
  }
  if (value.contains('SUBJECT_NOT_ASSIGNED')) {
    return S.current.renewalSubjectNotAssigned;
  }
  if (value.contains('SINGLE_SUBJECT')) {
    return S.current.parentSingleSubjectRequired;
  }
  if (value.contains('STUDENT_ACCESS_DENIED')) {
    return S.current.renewalStudentAccessDenied;
  }
  if (value.contains('IDEMPOTENCY_KEY_REQUIRED')) {
    return S.current.renewalIdempotencyRequired;
  }
  if (value.contains('EGYPTIAN_STUDENT_ONLY')) {
    return S.current.parentUnsupportedRegistrationMode;
  }
  if (value.contains('PACKAGE')) return S.current.invalidPackage;
  if (value.contains('RECEIPT')) return S.current.paymentReceiptRequired;
  if (value.contains('TIMEOUT') || !failure.responseReceived) {
    return failure.message;
  }
  return fallback;
}
