import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/student_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/data/repo/dashboard_repo.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_home_page.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/parent_subscription_card.dart';
import 'package:bnan_app/features/student_subscriptions/data/repo/student_subscriptions_repo.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Egyptian private home renders three independent cards', (
    tester,
  ) async {
    await _pump(tester, student: _privateStudent);
    expect(find.byType(ParentSubscriptionCard), findsNWidgets(3));
  });

  testWidgets('Egyptian monthly uses subscriptions list card', (tester) async {
    await _pump(tester, student: _monthlyStudent);
    expect(find.byType(ParentSubscriptionCard), findsOneWidget);
    expect(find.text('Monthly'), findsOneWidget);
  });

  testWidgets('Gulf all-subjects uses subscriptions list card', (tester) async {
    await _pump(tester, student: _legacyGulfStudent);
    expect(find.byType(ParentSubscriptionCard), findsOneWidget);
  });

  testWidgets('Gulf private home renders three independent cards', (
    tester,
  ) async {
    await _pump(tester, student: _gulfStudent);
    expect(find.byType(ParentSubscriptionCard), findsNWidgets(3));
  });

  testWidgets('empty authoritative Gulf list ignores dashboard fallback', (
    tester,
  ) async {
    await _pump(tester, student: _emptyGulf);
    expect(find.byType(ParentSubscriptionCard), findsNothing);
  });

  testWidgets('empty Egyptian private list does not use singular fallback', (
    tester,
  ) async {
    await _pump(tester, student: _emptyEgyptian);
    expect(find.byType(ParentSubscriptionCard), findsNothing);
  });

  testWidgets('pull refresh reloads dashboard and subscriptions once', (
    tester,
  ) async {
    final repos = await _pump(tester, student: _privateStudent);
    expect(repos.$1.calls, 1);
    expect(repos.$2.homeCalls, 1);

    await tester
        .widget<RefreshIndicator>(find.byType(RefreshIndicator))
        .onRefresh();
    await tester.pump();

    expect(repos.$1.calls, 2);
    expect(repos.$2.homeCalls, 2);
    expect(repos.$2.fullCalls, 0);
  });

  testWidgets('subscriptions failure never displays legacy dashboard card', (
    tester,
  ) async {
    await _pump(tester, failure: Failure(message: 'subscriptions failed'));
    expect(find.text('subscriptions failed'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
  });
}

Future<(_DashboardRepo, _SubscriptionsRepo)> _pump(
  WidgetTester tester, {
  ParentChildSubscriptionsModel student = _gulfStudent,
  Failure? failure,
}) async {
  final dashboardRepo = _DashboardRepo();
  final subscriptionsRepo = _SubscriptionsRepo(student, failure);
  final dashboard = DashboardCubit(dashboardRepo, DashboardRole.student);
  final subscriptions = StudentSubscriptionsCubit(subscriptionsRepo);
  await dashboard.load();
  await subscriptions.loadHome();
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: dashboard),
        BlocProvider.value(value: subscriptions),
      ],
      child: const _App(),
    ),
  );
  await tester.pump();
  addTearDown(dashboard.close);
  addTearDown(subscriptions.close);
  return (dashboardRepo, subscriptionsRepo);
}

class _App extends StatelessWidget {
  const _App();
  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: const Scaffold(
      body: StudentHomePage(onMenuTap: _noop, userName: 'Student'),
    ),
  );
}

void _noop() {}

class _DashboardRepo implements DashboardRepo {
  int calls = 0;
  @override
  Future<Either<Failure, DashboardData>> getDashboard() async {
    calls++;
    return Right(_dashboard());
  }
}

class _SubscriptionsRepo implements StudentSubscriptionsRepo {
  _SubscriptionsRepo(this.student, this.failure);
  final ParentChildSubscriptionsModel student;
  final Failure? failure;
  int homeCalls = 0, fullCalls = 0;
  @override
  getHomeSubscriptions() async {
    homeCalls++;
    return failure == null ? Right(student) : Left(failure!);
  }

  @override
  getSubscriptions() async {
    fullCalls++;
    return Right(student);
  }

  @override
  getStudentSubscription() async => Right(student.subscriptions.first);
}

StudentDashboardModel _dashboard() => StudentDashboardModel(
  generatedAt: null,
  student: const DashboardStudent(
    id: 'student',
    fullName: 'Student',
    email: '',
  ),
  stats: const DashboardStudentStats(
    certificates: 0,
    attendance: DashboardAttendance(
      total: 0,
      present: 0,
      late: 0,
      absent: 0,
      percentage: 0,
    ),
  ),
  weeklyEvaluation: null,
);

const _privateStudent = ParentChildSubscriptionsModel(
  studentId: 'student',
  studentName: 'Student',
  registrationMode: 'egyptian',
  subscriptions: [_math, _arabic, _english],
);
const _monthlyStudent = ParentChildSubscriptionsModel(
  studentId: 'student',
  studentName: 'Student',
  registrationMode: 'egyptian',
  subscriptions: [_monthly],
);
const _gulfStudent = ParentChildSubscriptionsModel(
  studentId: 'student',
  studentName: 'Student',
  registrationMode: 'gulf',
  subscriptions: [_math, _arabic, _english],
);
const _legacyGulfStudent = ParentChildSubscriptionsModel(
  studentId: 'student',
  studentName: 'Student',
  registrationMode: 'gulf',
  subscriptions: [_legacyGulf],
);
const _emptyGulf = ParentChildSubscriptionsModel(
  studentId: 'student',
  studentName: 'Student',
  registrationMode: 'gulf',
  subscriptions: [],
);
const _emptyEgyptian = ParentChildSubscriptionsModel(
  studentId: 'student',
  studentName: 'Student',
  registrationMode: 'egyptian',
  subscriptions: [],
);
const _math = ParentChildSubscriptionModel(
  id: 'math-sub',
  packageId: 'math-package',
  packageName: 'Math',
  curriculumId: 'curriculum',
  accessScope: 'single_subject',
  packageType: 'hours',
  subject: ParentSubscriptionSubjectModel(id: 'math', name: 'Math'),
);
const _legacyGulf = ParentChildSubscriptionModel(
  id: 'legacy-gulf-sub',
  packageId: 'legacy-gulf-package',
  packageName: 'Legacy Gulf',
  curriculumId: 'curriculum',
  accessScope: 'all_subjects',
  packageType: 'hours',
);
const _arabic = ParentChildSubscriptionModel(
  id: 'arabic-sub',
  packageId: 'arabic-package',
  packageName: 'Arabic',
  curriculumId: 'curriculum',
  accessScope: 'single_subject',
  packageType: 'hours',
  subject: ParentSubscriptionSubjectModel(id: 'arabic', name: 'Arabic'),
);
const _english = ParentChildSubscriptionModel(
  id: 'english-sub',
  packageId: 'english-package',
  packageName: 'English',
  curriculumId: 'curriculum',
  accessScope: 'single_subject',
  packageType: 'hours',
  subject: ParentSubscriptionSubjectModel(id: 'english', name: 'English'),
);
const _monthly = ParentChildSubscriptionModel(
  id: 'monthly-sub',
  packageId: 'monthly-package',
  packageName: 'Monthly',
  curriculumId: 'curriculum',
  accessScope: 'all_subjects',
  packageType: 'monthly',
);
