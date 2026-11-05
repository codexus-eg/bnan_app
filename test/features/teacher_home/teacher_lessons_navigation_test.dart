import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/localization/language_manager/language_manager.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_drawer_items.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_drawer_items.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_drawer_items.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/teacher_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/data/repo/dashboard_repo.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/shared_profile/data/models/teacher_profile_response_model.dart';
import 'package:bnan_app/features/teacher_home/data/models/teacher_session_statistics_model.dart';
import 'package:bnan_app/features/teacher_home/data/repo/teacher_session_statistics_repo.dart';
import 'package:bnan_app/features/teacher_home/presentation/manager/teacher_session_statistics_cubit.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/teacher_home_view.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_drawer_items.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

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
      expect(
        SessionManager.instance.registrationModes.toSet(),
        testCase.$1.toSet(),
      );
      expect(teacherScheduleRoutes(), testCase.$2);
      final idealItem = testCase.$1.contains(RegistrationMode.egyptian) ? 1 : 0;
      expect(
        teacherDrawerItems(context).length,
        10 + idealItem + testCase.$2.length,
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
              title != s.weeklyIdealStudent,
        )
        .toList();

    expect(mixedNonScheduleTitles, baseTitles);
    expect(baseTitles, contains(s.registrationRequests));
    expect(
      teacherDrawerItems(context).map((item) => item.title),
      contains(s.weeklyIdealStudent),
    );
    expect(adminDrawerItems(context), hasLength(22));
    expect(
      adminDrawerItems(context).where((item) => item.title == s.discountCodes),
      hasLength(1),
    );
    expect(
      adminDrawerItems(context).where((item) => item.title == s.schedule),
      isEmpty,
    );
    expect(
      adminDrawerItems(
        context,
      ).where((item) => item.title == s.lessonsManagement),
      hasLength(1),
    );
    final studentItems = studentDrawerItems(context);
    expect(studentItems, hasLength(12));
    expect(studentItems.where((item) => item.title == s.myGroups), isEmpty);
    expect(
      studentItems.where((item) => item.title == s.requestNewLesson),
      hasLength(1),
    );
    expect(studentItems.last.title, s.messages);
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
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => LanguageCubit()),
      BlocProvider(
        create: (_) => DashboardCubit(_DashboardRepo(), DashboardRole.teacher),
      ),
      BlocProvider(
        create: (_) => TeacherSessionStatisticsCubit(_TestTeacherSessionStatsRepo()),
      ),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    ),
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

Future<void> _saveTeacher(List<RegistrationMode> modes) async {
  await SessionManager.instance.saveSession(
    accessToken: 'token',
    refreshToken: '',
    userRole: 'teacher',
    registrationModes: RegistrationMode.values,
  );
  final profile = TeacherProfileModel.fromJson({
    'registrationModes': modes.map((mode) => mode.name).toList(),
  });
  await SessionManager.instance.replaceTeacherRegistrationModes(
    profile.registrationModes,
  );
}

class _DashboardRepo implements DashboardRepo {
  @override
  Future<Either<Failure, DashboardData>> getDashboard() async => const Right(
    TeacherDashboardModel(
      generatedAt: null,
      isIdealTeacher: false,
      points: 0,
      classrooms: 0,
      students: 0,
      subjects: 0,
    ),
  );
}

class _TestTeacherSessionStatsRepo implements TeacherSessionStatisticsRepo {
  @override
  Future<Either<Failure, TeacherSessionStatisticsModel>> getSessionStatistics({
    String? from,
    String? to,
  }) async => const Right(
    TeacherSessionStatisticsModel(
      totalSessions: 0,
      totalHours: 0,
    ),
  );
}
