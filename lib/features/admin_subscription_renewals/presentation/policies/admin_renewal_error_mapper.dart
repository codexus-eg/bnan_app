import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/generated/l10n.dart';

String mapAdminRenewalFailure(Failure failure) {
  return switch ((failure.code ?? '').trim().toUpperCase()) {
    'INVALID_PAYMENT_STATUS' => S.current.renewalInvalidPaymentStatus,
    'PAYMENT_NOT_CONFIRMED' => S.current.renewalPaymentNotConfirmed,
    _ => failure.message,
  };
}
