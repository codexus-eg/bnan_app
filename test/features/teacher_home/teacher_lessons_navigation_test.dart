import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_drawer_items.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_drawer_items.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/teacher_home_view.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_drawer_items.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('teacher schedule item opens lessons route and back works', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    tester.widget<HomeAppBar>(find.byType(HomeAppBar)).onMenuTap();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    expect(find.text('Lessons destination'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(TeacherHomeView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('management entry is not duplicated or exposed to students', (
    tester,
  ) async {
    await tester.pumpWidget(_localizedBuilder());
    final context = tester.element(find.byKey(const Key('navigation-context')));
    final s = S.of(context);
    expect(
      teacherDrawerItems(context).where((item) => item.title == s.schedule),
      hasLength(1),
    );
    expect(
      studentDrawerItems(
        context,
      ).where((item) => item.title == s.lessonsManagement),
      isEmpty,
    );
    expect(
      adminDrawerItems(
        context,
      ).where((item) => item.title == s.lessonsManagement),
      hasLength(1),
    );
  });
}

Widget _app() {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => const TeacherHomeView()),
      GoRoute(
        path: Routes.lessonsManagement,
        builder: (_, _) =>
            Scaffold(appBar: AppBar(), body: const Text('Lessons destination')),
      ),
    ],
  );
  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
  );
}

Widget _localizedBuilder() => MaterialApp(
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: Builder(
    key: const Key('navigation-context'),
    builder: (_) => const SizedBox(),
  ),
);
