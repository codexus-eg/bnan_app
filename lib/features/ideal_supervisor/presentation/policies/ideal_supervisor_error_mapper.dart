import 'package:bnan_app/generated/l10n.dart';

String idealSupervisorError(S s, String? code, String fallback) {
  final value = (code ?? fallback).toUpperCase();
  if (value.contains('INVALID_IDEAL_SUPERVISOR_SELECTION')) {
    return s.invalidIdealSupervisorSelection;
  }
  if (value.contains('SUPERVISOR_NOT_FOUND')) return s.supervisorNotFound;
  if (value.contains('INVALID_CERTIFICATE_RECIPIENT')) {
    return s.invalidCertificateRecipient;
  }
  if (value.contains('SUPERVISOR_NOT_ACTIVE')) return s.supervisorNotActive;
  if (value.contains('IDEAL_SUPERVISOR_CERTIFICATE_ALREADY_EXISTS')) {
    return s.idealSupervisorCertificateAlreadyExists;
  }
  return fallback;
}
