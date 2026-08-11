import 'package:bnan_app/features/teacher_home/presentation/views/teacher_home_view.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/teacher_payrolls/teacher_my_payrolls_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fake_teacher_payroll_repo.dart';

void main() {
  test('drawer earnings maps to the payroll bottom tab', () {
    expect(teacherDrawerToBottomNavIndex[8], teacherPayrollTabIndex);
  });

  testWidgets('bottom navigation opens payroll body inside teacher shell', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();
    await tester.tap(find.text('Dues'));
    await tester.pumpAndSettle();
    expect(find.text('My Earnings'), findsOneWidget);
    expect(find.text('Dues'), findsOneWidget);
  });

  testWidgets('drawer earnings opens the same payroll tab', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();
    tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Earnings'));
    await tester.pumpAndSettle();
    expect(find.text('My Earnings'), findsOneWidget);
    expect(find.text('Dues'), findsOneWidget);
  });
}

Widget _app() => BlocProvider(
  create: (_) => TeacherMyPayrollsCubit(FakeTeacherPayrollRepo()),
  child: MaterialApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: const TeacherHomeView(),
  ),
);
