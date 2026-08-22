import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/student_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/data/repo/dashboard_repo.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/monthly_subscription_info.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/package_details_card.dart';
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
    expect(find.byType(PackageDetailsCard), findsNothing);
  });

  testWidgets('Egyptian monthly keeps old card and remaining days', (
    tester,
  ) async {
    await _pump(
      tester,
      student: _monthlyStudent,
      dashboardSubscription: _monthlyDashboard,
    );
    expect(find.byType(PackageDetailsCard), findsOneWidget);
    expect(find.byType(MonthlySubscriptionInfo), findsOneWidget);
    expect(find.textContaining('12'), findsOneWidget);
    expect(find.byType(ParentSubscriptionCard), findsNothing);
  });

  testWidgets('Gulf keeps old dashboard subscription card', (tester) async {
    await _pump(tester, student: _gulfStudent);
    expect(find.byType(PackageDetailsCard), findsOneWidget);
    expect(find.byType(ParentSubscriptionCard), findsNothing);
  });

  testWidgets('empty Egyptian private list does not use singular fallback', (
    tester,
  ) async {
    await _pump(tester, student: _emptyEgyptian);
    expect(find.byType(PackageDetailsCard), findsNothing);
    expect(find.byType(ParentSubscriptionCard), findsNothing);
  });

  testWidgets('empty Egyptian monthly list keeps old monthly card', (
    tester,
  ) async {
    await _pump(
      tester,
      student: _emptyEgyptian,
      dashboardSubscription: _monthlyDashboard,
    );
    expect(find.byType(PackageDetailsCard), findsOneWidget);
    expect(find.byType(MonthlySubscriptionInfo), findsOneWidget);
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

  testWidgets('subscriptions failure keeps dashboard content', (tester) async {
    await _pump(tester, failure: Failure(message: 'subscriptions failed'));
    expect(find.byType(PackageDetailsCard), findsOneWidget);
    expect(find.text('subscriptions failed'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
  });
}

Future<(_DashboardRepo, _SubscriptionsRepo)> _pump(
  WidgetTester tester, {
  ParentChildSubscriptionsModel student = _gulfStudent,
  DashboardSubscription dashboardSubscription = _gulfDashboard,
  Failure? failure,
}) async {
  final dashboardRepo = _DashboardRepo(dashboardSubscription);
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
  _DashboardRepo(this.subscription);
  final DashboardSubscription subscription;
  int calls = 0;
  @override
  Future<Either<Failure, DashboardData>> getDashboard() async {
    calls++;
    return Right(_dashboard(subscription));
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
}

StudentDashboardModel _dashboard(DashboardSubscription subscription) =>
    StudentDashboardModel(
      generatedAt: null,
      student: const DashboardStudent(
        id: 'student',
        fullName: 'Student',
        email: '',
      ),
      subscription: subscription,
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

const _gulfDashboard = DashboardSubscription(
  packageName: 'Gulf hours',
  packageType: 'hours',
  totalHours: 10,
  usedHours: 2,
  remainingHours: 8,
  progressPercentage: 20,
  isActive: true,
);
const _monthlyDashboard = DashboardSubscription(
  packageName: 'Monthly',
  packageType: 'monthly',
  totalHours: 0,
  usedHours: 0,
  remainingHours: 0,
  progressPercentage: 0,
  isActive: true,
  planKind: 'egyptian_monthly',
  remainingType: 'days',
  remainingValue: 12,
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
  subscriptions: [_math],
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
