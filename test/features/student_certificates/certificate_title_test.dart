import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificate_title.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ideal teacher certificate uses its localized label', (
    tester,
  ) async {
    String? title;
    final certificate = CertificateModel.fromJson({
      'certificateType': 'ideal_teacher',
    });
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) {
            title = certificateTitle(context, certificate);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(title, 'Ideal Teacher Certificate');
  });

  testWidgets('ideal supervisor certificate uses its localized label', (
    tester,
  ) async {
    final certificate = CertificateModel.fromJson({
      '_id': 'certificate-2',
      'certificateType': 'ideal_supervisor',
      'recipientType': 'supervisor',
    });
    late String title;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) {
            title = certificateTitle(context, certificate);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(title, 'Ideal Supervisor Certificate');
  });
}
