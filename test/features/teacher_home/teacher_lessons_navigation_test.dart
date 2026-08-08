import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_drawer_items.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_drawer_items.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_drawer_items.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/teacher_home_view.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_drawer_items.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.clearSession();
  });

  testWidgets('Gulf teacher item opens lessons route and back works', (
    tester,
  ) async {
    await _saveTeacher(const [RegistrationMode.gulf]);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    tester.widget<HomeAppBar>(find.byType(HomeAppBar)).onMenuTap();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lessons Management'));
    await tester.pumpAndSettle();
    expect(find.text('Lessons destination'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(TeacherHomeView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('teacher schedule visibility follows modes and ignores order', (
    tester,
  ) async {
    await tester.pumpWidget(_localizedBuilder());
    final context = tester.element(find.byKey(const Key('navigation-context')));

    for (final testCase in <(List<RegistrationMode>, List<String>)>[
      ([RegistrationMode.egyptian], [Routes.egyptianSchedulesReadOnly]),
      ([RegistrationMode.gulf], [Routes.lessonsManagement]),
      (
        [RegistrationMode.egyptian, RegistrationMode.gulf],
        [Routes.egyptianSchedulesReadOnly, Routes.lessonsManagement],
      ),
      (
        [RegistrationMode.gulf, RegistrationMode.egyptian],
        [Routes.egyptianSchedulesReadOnly, Routes.lessonsManagement],
      ),
      ([], []),
    ]) {
      await _saveTeacher(testCase.$1);
      expect(teacherScheduleRoutes(), testCase.$2);
      final gulfItem = testCase.$1.contains(RegistrationMode.gulf) ? 1 : 0;
      final idealItem = testCase.$1.contains(RegistrationMode.egyptian) ? 1 : 0;
      expect(
        teacherDrawerItems(context).length,
        14 + gulfItem + idealItem + testCase.$2.length,
      );
    }
  });

  testWidgets('mixed teacher opens each schedule route', (tester) async {
    await _saveTeacher(const [
      RegistrationMode.gulf,
      RegistrationMode.egyptian,
    ]);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    tester.widget<HomeAppBar>(find.byType(HomeAppBar)).onMenuTap();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    expect(find.text('Egyptian destination'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    tester.widget<HomeAppBar>(find.byType(HomeAppBar)).onMenuTap();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lessons Management'));
    await tester.pumpAndSettle();
    expect(find.text('Lessons destination'), findsOneWidget);
  });

  testWidgets('non-target drawers and relative teacher order stay unchanged', (
    tester,
  ) async {
    await tester.pumpWidget(_localizedBuilder());
    final context = tester.element(find.byKey(const Key('navigation-context')));
    final s = S.of(context);

    await _saveTeacher(const []);
    final baseTitles = teacherDrawerItems(
      context,
    ).map((item) => item.title).toList();
    await _saveTeacher(RegistrationMode.values);
    final mixedNonScheduleTitles = teacherDrawerItems(context)
        .map((item) => item.title)
        .where(
          (title) =>
              title != s.schedule &&
              title != s.lessonsManagement &&
              title != s.registrationRequests &&
              title != s.weeklyIdealStudent,
        )
        .toList();

    expect(mixedNonScheduleTitles, baseTitles);
    expect(baseTitles, isNot(contains(s.registrationRequests)));
    expect(
      teacherDrawerItems(context).map((item) => item.title),
      contains(s.registrationRequests),
    );
    expect(
      teacherDrawerItems(context).map((item) => item.title),
      contains(s.weeklyIdealStudent),
    );
    expect(adminDrawerItems(context), hasLength(17));
    expect(
      adminDrawerItems(context).where((item) => item.title == s.discountCodes),
      hasLength(1),
    );
    expect(
      adminDrawerItems(context).where((item) => item.title == s.schedule),
      hasLength(1),
    );
    expect(
      adminDrawerItems(
        context,
      ).where((item) => item.title == s.lessonsManagement),
      isEmpty,
    );
    expect(studentDrawerItems(context), hasLength(12));
    expect(parentDrawerItems(context), hasLength(10));
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
      GoRoute(
        path: Routes.egyptianSchedulesReadOnly,
        builder: (_, _) => Scaffold(
          appBar: AppBar(),
          body: const Text('Egyptian destination'),
        ),
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

Future<void> _saveTeacher(List<RegistrationMode> modes) {
  return SessionManager.instance.saveSession(
    accessToken: 'token',
    refreshToken: '',
    userRole: 'teacher',
    registrationModes: modes,
  );
}
