import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/supervisor_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/data/repo/dashboard_repo.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/supervisor_home_view.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_home_page.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await _saveSupervisor(RegistrationMode.gulf);
  });

  testWidgets('renders at 360px and opens its shared drawer', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    final state = tester.state<SupervisorHomeViewState>(
      find.byType(SupervisorHomeView),
    );
    state.scaffoldKey.currentState?.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Plans'), findsOneWidget);
    expect(find.text('Supervisor'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bottom destinations switch persistent tabs', (tester) async {
    final builds = <String, int>{};
    await tester.pumpWidget(testApp(tabBuilder: _tabBuilder(builds)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Attendance').last);
    await tester.pumpAndSettle();

    expect(find.text(Routes.attendance), findsOneWidget);
    expect(find.byType(CustomBottomNavBar), findsOneWidget);
    expect(builds[Routes.attendance], 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home item returns from Attendance without route navigation', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(tabBuilder: _tabBuilder({})));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Attendance').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();

    expect(find.byType(SupervisorHomePage), findsOneWidget);
    expect(_bottomBar(tester).currentIndex, 0);
  });

  testWidgets('Drawer Certificates reuses its existing bottom tab', (
    tester,
  ) async {
    final builds = <String, int>{};
    await tester.pumpWidget(testApp(tabBuilder: _tabBuilder(builds)));
    await tester.pumpAndSettle();

    await _openDrawer(tester);
    await tester.tap(find.text('Certificates').first);
    await tester.pumpAndSettle();

    expect(find.text(Routes.certificatesManagement), findsOneWidget);
    expect(_bottomBar(tester).currentIndex, 3);
    expect(builds[Routes.certificatesManagement], 1);
  });

  testWidgets('drawer-only Plans opens its route and Back returns Home', (
    tester,
  ) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await _openDrawer(tester);
    await tester.tap(find.text('Plans'));
    await tester.pumpAndSettle();

    expect(find.text('Plans destination'), findsOneWidget);
    expect(find.byType(CustomBottomNavBar), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(SupervisorHomePage), findsOneWidget);
  });

  testWidgets('Ideal Student remains a drawer-only route', (tester) async {
    await _saveSupervisor(RegistrationMode.egyptian);
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await _openDrawer(tester);
    await tester.tap(find.text('Weekly Ideal Student'));
    await tester.pumpAndSettle();

    expect(find.text('Ideal student destination'), findsOneWidget);
    expect(find.byType(CustomBottomNavBar), findsNothing);
  });

  testWidgets('system back from Certificates returns to Home', (tester) async {
    await tester.pumpWidget(testApp(tabBuilder: _tabBuilder({})));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Certificates').last);
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(SupervisorHomePage), findsOneWidget);
    expect(_bottomBar(tester).currentIndex, 0);
  });

  testWidgets('multiple tab switches keep visible and selected index aligned', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(tabBuilder: _tabBuilder({})));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Evaluations').last);
    await tester.pumpAndSettle();
    expect(find.text(Routes.weeklyEvaluations), findsOneWidget);
    expect(_bottomBar(tester).currentIndex, 1);
    await tester.tap(find.text('Messages').last);
    await tester.pumpAndSettle();
    expect(find.text(Routes.groups), findsOneWidget);
    expect(_bottomBar(tester).currentIndex, 2);
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();

    expect(find.byType(SupervisorHomePage), findsOneWidget);
    expect(_bottomBar(tester).currentIndex, 0);
  });

  testWidgets('switching and re-tapping tabs keeps one tab instance', (
    tester,
  ) async {
    final builds = <String, int>{};
    await tester.pumpWidget(testApp(tabBuilder: _tabBuilder(builds)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Evaluations').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('tabState')), 'preserved');
    await tester.tap(find.text('Certificates').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Evaluations').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Evaluations').last);
    await tester.pumpAndSettle();

    expect(builds[Routes.weeklyEvaluations], 1);
    expect(builds[Routes.certificatesManagement], 1);
    expect(find.text('preserved'), findsOneWidget);
  });

  testWidgets('nested route returns to the selected certificates tab', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        tabBuilder: (route) => Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => context.push('/certificate-detail'),
              child: Text(route),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Certificates').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(Routes.certificatesManagement));
    await tester.pumpAndSettle();
    expect(find.text('Certificate detail'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text(Routes.certificatesManagement), findsOneWidget);
    expect(find.byType(CustomBottomNavBar), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(SupervisorHomePage), findsOneWidget);
    expect(_bottomBar(tester).currentIndex, 0);
  });

  testWidgets('system back at Home is not consumed by tab handling', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(tabBuilder: _tabBuilder({})));
    await tester.pumpAndSettle();

    final handled = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(handled, isFalse);
  });

  testWidgets('lessons item opens route and back returns to supervisor', (
    tester,
  ) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    final state = tester.state<SupervisorHomeViewState>(
      find.byType(SupervisorHomeView),
    );
    state.scaffoldKey.currentState?.openDrawer();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lessons Management'));
    await tester.pumpAndSettle();
    expect(find.text('Lessons destination'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(SupervisorHomeView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Egyptian schedule item opens the read-only route', (
    tester,
  ) async {
    await _saveSupervisor(RegistrationMode.egyptian);
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    final state = tester.state<SupervisorHomeViewState>(
      find.byType(SupervisorHomeView),
    );
    state.scaffoldKey.currentState?.openDrawer();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();

    expect(find.text('Egyptian schedules destination'), findsOneWidget);
  });

  testWidgets('supports the Arabic RTL layout at 360px', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(testApp(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(Scaffold))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });
}

Widget testApp({
  Locale locale = const Locale('en'),
  SupervisorTabBuilder? tabBuilder,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => BlocProvider(
          create: (_) =>
              DashboardCubit(_DashboardRepo(), DashboardRole.supervisor)
                ..load(),
          child: SupervisorHomeView(
            userName:
                'A very long supervisor display name for overflow testing',
            tabBuilder: tabBuilder,
          ),
        ),
      ),
      GoRoute(
        path: Routes.attendance,
        builder: (_, _) => const Scaffold(body: Text('Attendance destination')),
      ),
      GoRoute(
        path: Routes.lessonsManagement,
        builder: (_, _) =>
            Scaffold(appBar: AppBar(), body: const Text('Lessons destination')),
      ),
      GoRoute(
        path: Routes.egyptianSchedulesReadOnly,
        builder: (_, _) =>
            const Scaffold(body: Text('Egyptian schedules destination')),
      ),
      GoRoute(
        path: Routes.plans,
        builder: (_, _) =>
            Scaffold(appBar: AppBar(), body: const Text('Plans destination')),
      ),
      GoRoute(
        path: Routes.weeklyIdealStudents,
        builder: (_, _) =>
            const Scaffold(body: Text('Ideal student destination')),
      ),
      GoRoute(
        path: '/certificate-detail',
        builder: (_, _) => const Scaffold(body: Text('Certificate detail')),
      ),
    ],
  );
  return MaterialApp.router(
    routerConfig: router,
    locale: locale,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
  );
}

SupervisorTabBuilder _tabBuilder(Map<String, int> builds) => (route) {
  builds.update(route, (count) => count + 1, ifAbsent: () => 1);
  return Scaffold(
    body: Column(
      children: [
        Text(route),
        const TextField(key: Key('tabState')),
      ],
    ),
  );
};

CustomBottomNavBar _bottomBar(WidgetTester tester) =>
    tester.widget<CustomBottomNavBar>(find.byType(CustomBottomNavBar));

Future<void> _openDrawer(WidgetTester tester) async {
  final state = tester.state<SupervisorHomeViewState>(
    find.byType(SupervisorHomeView),
  );
  state.scaffoldKey.currentState?.openDrawer();
  await tester.pumpAndSettle();
}

class _DashboardRepo implements DashboardRepo {
  @override
  Future<Either<Failure, DashboardData>> getDashboard() async => const Right(
    SupervisorDashboardModel(
      generatedAt: null,
      classrooms: 0,
      evaluations: 0,
      idealTeacher: null,
      notifications: [],
    ),
  );
}

Future<void> _saveSupervisor(RegistrationMode mode) {
  return SessionManager.instance.saveSession(
    accessToken: 'token',
    refreshToken: '',
    userRole: 'supervisor',
    registrationMode: mode,
  );
}
