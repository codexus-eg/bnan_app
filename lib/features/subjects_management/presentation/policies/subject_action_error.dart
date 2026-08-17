import 'package:bnan_app/generated/l10n.dart';

String subjectActionError(S s, String? code, String fallback) {
  final value = (code ?? fallback).toUpperCase();
  if (value.contains('GRADE_REQUIRED')) return s.gradeRequired;
  if (value.contains('GRADE_NOT_IN_CURRICULUM') ||
      value.contains('SUBJECT_ALREADY_EXISTS_IN_CURRICULUM')) {
    return fallback == code || fallback.toUpperCase() == value
        ? s.errorValidation
        : fallback;
  }
  return fallback;
}
