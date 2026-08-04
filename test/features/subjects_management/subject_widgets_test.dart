import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_card_management.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows grade below curriculum and handles null grade', (
    tester,
  ) async {
    await _pump(tester, SubjectCardManagement(subject: _subject('Grade two')));
    expect(find.text('Saudi'), findsOneWidget);
    expect(find.text('Grade two'), findsOneWidget);

    await _pump(tester, SubjectCardManagement(subject: _subject(null)));
    expect(find.text('Grade two'), findsNothing);
    expect(find.text('-'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

SubjectModel _subject(String? grade) => SubjectModel(
  id: 'subject-1',
  name: 'Math',
  isActive: true,
  curriculum: const SubjectCurriculumModel(id: 'c1', name: 'Saudi', icon: ''),
  grade: grade == null ? null : SubjectGradeModel(id: 'g1', name: grade),
);

Future<void> _pump(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}
