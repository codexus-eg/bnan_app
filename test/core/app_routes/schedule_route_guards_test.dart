import 'package:bnan_app/core/app_routes/app_router.dart';
import 'package:bnan_app/core/app_routes/home_route_resolver.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  final cases = <_GuardCase>[
    ..._tablesCases,
    ..._lessonsCases,
    ..._parentCases,
    ..._readOnlyCases,
    ..._studentSubjectCases,
    ..._teacherRequestCases,
    ..._adminDashboardCases,
  ];

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.clearSession();
  });

  for (final item in cases) {
    testWidgets(item.name, (tester) async {
      await SessionManager.instance.saveSession(
        accessToken: 'token',
        refreshToken: '',
        userRole: item.role,
        registrationMode: item.mode,
        registrationModes: item.modes,
      );

      final redirect = await _redirectFor(tester, item.path);
      expect(
        redirect,
        item.allowed ? isNull : HomeRouteResolver.forRole(item.role),
      );
    });
  }
}

Future<String?> _redirectFor(WidgetTester tester, String path) async {
  final actualRouter = buildRouter();
  final route = actualRouter.configuration.routes
      .whereType<GoRoute>()
      .singleWhere((route) => route.path == path);
  late BuildContext context;
  late GoRouterState state;
  final harness = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (routeContext, routeState) {
          context = routeContext;
          state = routeState;
          return const SizedBox();
        },
      ),
    ],
  );
  await tester.pumpWidget(MaterialApp.router(routerConfig: harness));
  final result = await route.redirect!(context, state);
  actualRouter.dispose();
  harness.dispose();
  return result;
}

class _GuardCase {
  const _GuardCase(
    this.name,
    this.path,
    this.role, {
    this.allowed = false,
    this.mode,
    this.modes = const [],
  });

  final String name, path, role;
  final bool allowed;
  final RegistrationMode? mode;
  final List<RegistrationMode> modes;
}

const _tablesCases = [
  _GuardCase(
    'tables allows admin',
    Routes.tablesManagement,
    'admin',
    allowed: true,
  ),
  _GuardCase('tables rejects teacher', Routes.tablesManagement, 'teacher'),
  _GuardCase(
    'tables rejects supervisor',
    Routes.tablesManagement,
    'supervisor',
  ),
  _GuardCase('tables rejects student', Routes.tablesManagement, 'student'),
  _GuardCase('tables rejects parent', Routes.tablesManagement, 'parent'),
];

const _lessonsCases = [
  _GuardCase(
    'lessons allows Gulf supervisor',
    Routes.lessonsManagement,
    'supervisor',
    allowed: true,
    mode: RegistrationMode.gulf,
  ),
  _GuardCase(
    'lessons rejects Egyptian supervisor',
    Routes.lessonsManagement,
    'supervisor',
    mode: RegistrationMode.egyptian,
  ),
  _GuardCase(
    'lessons rejects null supervisor',
    Routes.lessonsManagement,
    'supervisor',
  ),
  _GuardCase(
    'lessons allows Gulf teacher',
    Routes.lessonsManagement,
    'teacher',
    allowed: true,
    modes: [RegistrationMode.gulf],
  ),
  _GuardCase(
    'lessons allows mixed teacher',
    Routes.lessonsManagement,
    'teacher',
    allowed: true,
    modes: RegistrationMode.values,
  ),
  _GuardCase(
    'lessons rejects Egyptian teacher',
    Routes.lessonsManagement,
    'teacher',
    modes: [RegistrationMode.egyptian],
  ),
  _GuardCase(
    'lessons rejects empty teacher',
    Routes.lessonsManagement,
    'teacher',
  ),
  _GuardCase('lessons rejects admin', Routes.lessonsManagement, 'admin'),
  _GuardCase('lessons rejects student', Routes.lessonsManagement, 'student'),
  _GuardCase('lessons rejects parent', Routes.lessonsManagement, 'parent'),
];

const _parentCases = [
  _GuardCase(
    'parent schedule allows parent',
    Routes.parentSchedule,
    'parent',
    allowed: true,
  ),
  _GuardCase('parent schedule rejects admin', Routes.parentSchedule, 'admin'),
  _GuardCase(
    'parent schedule rejects teacher',
    Routes.parentSchedule,
    'teacher',
  ),
  _GuardCase(
    'parent schedule rejects supervisor',
    Routes.parentSchedule,
    'supervisor',
  ),
  _GuardCase(
    'parent schedule rejects student',
    Routes.parentSchedule,
    'student',
  ),
];

const _studentSubjectCases = [
  _GuardCase(
    'student subjects allows student',
    Routes.studentSubjects,
    'student',
    allowed: true,
  ),
  _GuardCase(
    'student subjects rejects parent',
    Routes.studentSubjects,
    'parent',
  ),
  _GuardCase(
    'student subjects rejects teacher',
    Routes.studentSubjects,
    'teacher',
  ),
  _GuardCase(
    'student subjects rejects supervisor',
    Routes.studentSubjects,
    'supervisor',
  ),
  _GuardCase('student subjects rejects admin', Routes.studentSubjects, 'admin'),
];

const _teacherRequestCases = [
  _GuardCase(
    'teacher requests allows Gulf teacher',
    Routes.teacherRegistrationRequest,
    'teacher',
    allowed: true,
    modes: [RegistrationMode.gulf],
  ),
  _GuardCase(
    'teacher requests rejects Egyptian teacher',
    Routes.teacherRegistrationRequest,
    'teacher',
    modes: [RegistrationMode.egyptian],
  ),
  _GuardCase(
    'teacher requests rejects student',
    Routes.teacherRegistrationRequest,
    'student',
    mode: RegistrationMode.gulf,
  ),
];

const _adminDashboardCases = [
  _GuardCase(
    'admin dashboard allows admin',
    Routes.adminHome,
    'admin',
    allowed: true,
  ),
  _GuardCase('admin dashboard rejects teacher', Routes.adminHome, 'teacher'),
  _GuardCase('admin dashboard rejects student', Routes.adminHome, 'student'),
];

const _readOnlyCases = [
  _GuardCase(
    'Egyptian read-only allows teacher',
    Routes.egyptianSchedulesReadOnly,
    'teacher',
    allowed: true,
    modes: [RegistrationMode.egyptian],
  ),
  _GuardCase(
    'Egyptian read-only allows supervisor',
    Routes.egyptianSchedulesReadOnly,
    'supervisor',
    allowed: true,
    mode: RegistrationMode.egyptian,
  ),
  _GuardCase(
    'Egyptian read-only allows student',
    Routes.egyptianSchedulesReadOnly,
    'student',
    allowed: true,
    mode: RegistrationMode.egyptian,
  ),
  _GuardCase(
    'Egyptian read-only rejects Gulf teacher',
    Routes.egyptianSchedulesReadOnly,
    'teacher',
    modes: [RegistrationMode.gulf],
  ),
  _GuardCase(
    'Gulf read-only allows Gulf student',
    Routes.gulfStudentScheduleReadOnly,
    'student',
    allowed: true,
    mode: RegistrationMode.gulf,
  ),
  _GuardCase(
    'Gulf read-only rejects Egyptian student',
    Routes.gulfStudentScheduleReadOnly,
    'student',
    mode: RegistrationMode.egyptian,
  ),
];
