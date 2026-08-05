import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String certificateTitle(BuildContext context, CertificateModel certificate) {
  final s = S.of(context);
  final month = certificate.period.month;
  if (certificate.certificateType != 'student_monthly' ||
      month < 1 ||
      month > 12) {
    return s.studentCertificate;
  }
  final locale = Localizations.localeOf(context).toLanguageTag();
  final monthName = DateFormat.MMMM(locale).format(DateTime(2000, month));
  return s.monthlyCertificateTitle(monthName);
}
