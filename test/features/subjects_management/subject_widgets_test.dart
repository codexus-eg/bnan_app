import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_card_management.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_pagination_controls.dart';
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
    expect(tester.takeException(), isNull);
  });

  testWidgets('pagination hides on one page and disables boundaries', (
    tester,
  ) async {
    await _pump(tester, _controls(current: 1, last: 1));
    expect(find.text('Previous'), findsNothing);

    await _pump(tester, _controls(current: 1, last: 3));
    expect(_button(tester, 'Previous').onPressed, isNull);
    expect(_button(tester, 'Next').onPressed, isNotNull);

    await _pump(tester, _controls(current: 3, last: 3));
    expect(_button(tester, 'Previous').onPressed, isNotNull);
    expect(_button(tester, 'Next').onPressed, isNull);
    expect(find.text('3'), findsOneWidget);
  });
}

SubjectModel _subject(String? grade) => SubjectModel(
  id: 'subject-1',
  name: 'Math',
  isActive: true,
  curriculum: const SubjectCurriculumModel(id: 'c1', name: 'Saudi', icon: ''),
  grade: grade == null ? null : SubjectGradeModel(id: 'g1', name: grade),
);

Widget _controls({required int current, required int last}) {
  return SubjectPaginationControls(
    currentPage: current,
    lastPage: last,
    isLoading: false,
    onPrevious: () {},
    onNext: () {},
  );
}

ElevatedButton _button(WidgetTester tester, String text) {
  return tester.widget<ElevatedButton>(
    find.ancestor(of: find.text(text), matching: find.byType(ElevatedButton)),
  );
}

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
