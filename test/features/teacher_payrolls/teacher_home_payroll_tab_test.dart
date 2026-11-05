import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/localization/language_manager/language_manager.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/teacher_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/data/repo/dashboard_repo.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/teacher_home_view.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/teacher_payrolls/teacher_my_payrolls_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:bnan_app/features/teacher_home/data/models/teacher_session_statistics_model.dart';
import 'package:bnan_app/features/teacher_home/data/repo/teacher_session_statistics_repo.dart';
import 'package:bnan_app/features/teacher_home/presentation/manager/teacher_session_statistics_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fake_teacher_payroll_repo.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

  test('drawer earnings is not mapped to a bottom tab', () {
    expect(teacherDrawerToBottomNavIndex[5], isNull);
  });

  testWidgets('bottom navigation keeps the current five destinations', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    final navigation = tester.widget<CustomBottomNavBar>(
      find.byType(CustomBottomNavBar),
    );
    expect(navigation.items.map((item) => item.title), [
      'Home',
      'Assignments',
      'Messages',
      'Certificates',
      'My Account',
    ]);
    expect(find.text('Dues'), findsNothing);
  });

  testWidgets('drawer earnings opens its dedicated route', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();
    tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('My Earnings'));
    await tester.tap(find.text('My Earnings'));
    await tester.pumpAndSettle();
    expect(find.text('earnings-destination'), findsOneWidget);
  });
}

Widget _app() {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => const TeacherHomeView()),
      GoRoute(
        path: Routes.teacherMyEarnings,
        builder: (_, _) => const Scaffold(body: Text('earnings-destination')),
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
        create: (_) => TeacherMyPayrollsCubit(FakeTeacherPayrollRepo()),
      ),
      BlocProvider(
        create: (_) => TeacherSessionStatisticsCubit(_TestStatsRepo()),
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

class _TestStatsRepo implements TeacherSessionStatisticsRepo {
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
