import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_flow_result.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_state.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/parent_subscription_card.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/renewal_result.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('single-subject subscriptions render as independent cards', (
    tester,
  ) async {
    const child = ParentChildSubscriptionsModel(
      studentId: 'child',
      studentName: 'Child',
      subscriptions: [],
    );
    final subscriptions = [
      ParentChildSubscriptionModel(
        id: 'one',
        packageId: 'p',
        packageName: 'Math package',
        curriculumId: 'c',
        accessScope: 'single_subject',
        packageType: 'hours',
        remainingHours: 0,
        subject: ParentSubscriptionSubjectModel(id: 'math', name: 'Math'),
        canRenew: true,
      ),
      ParentChildSubscriptionModel(
        id: 'two',
        packageId: 'p',
        packageName: 'Arabic package',
        curriculumId: 'c',
        accessScope: 'single_subject',
        packageType: 'hours',
        remainingHours: 7,
        subject: ParentSubscriptionSubjectModel(id: 'arabic', name: 'Arabic'),
        canRenew: true,
      ),
      ParentChildSubscriptionModel(
        id: 'three',
        packageId: 'p',
        packageName: 'English package',
        curriculumId: 'c',
        accessScope: 'single_subject',
        packageType: 'monthly',
        endDate: DateTime.utc(2020),
        subject: ParentSubscriptionSubjectModel(id: 'english', name: 'English'),
        canRenew: true,
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: ListView(
            children: subscriptions
                .map(
                  (item) =>
                      ParentSubscriptionCard(child: child, subscription: item),
                )
                .toList(),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(ParentSubscriptionCard), findsNWidgets(3));
    expect(find.text('Math'), findsOneWidget);
    expect(find.text('Arabic'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Renew subscription'), findsNWidgets(2));
  });

  testWidgets('long subscription text does not overflow on a small screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const child = ParentChildSubscriptionsModel(
      studentId: 'child',
      studentName: 'A very long student name that must remain responsive',
      subscriptions: [],
    );
    const subscription = ParentChildSubscriptionModel(
      id: 'sub',
      packageId: 'package',
      packageName: 'A very long package name that should wrap safely',
      curriculumId: 'curriculum',
      accessScope: 'single_subject',
      packageType: 'hours',
      status: 'a_very_long_payment_and_subscription_status',
      subject: ParentSubscriptionSubjectModel(
        id: 'subject',
        name: 'A very long assigned subject name that should not overflow',
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ParentSubscriptionCard(
              child: child,
              subscription: subscription,
              showRenew: false,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  for (final scenario in const [
    ('parent grace monthly', true, 'grace_period', 'monthly', false),
    ('student suspended monthly', false, 'suspended', 'monthly', false),
    ('parent single subject', true, 'grace_period', 'monthly', true),
  ]) {
    testWidgets('${scenario.$1} shows backend-approved renewal', (
      tester,
    ) async {
      await _pumpRenewalCard(
        tester,
        isParent: scenario.$2,
        status: scenario.$3,
        packageType: scenario.$4,
        singleSubject: scenario.$5,
        endDate: DateTime.utc(2020),
      );
      expect(find.text('Renew subscription'), findsOneWidget);
    });
  }

  testWidgets('hours hide Renew while remaining hours are positive', (
    tester,
  ) async {
    await _pumpRenewalCard(
      tester,
      isParent: false,
      status: 'active',
      packageType: 'hours',
      singleSubject: true,
      remainingHours: 5,
    );
    expect(find.text('Renew subscription'), findsNothing);
  });

  testWidgets('hours show Renew when remaining hours reach zero', (
    tester,
  ) async {
    await _pumpRenewalCard(
      tester,
      isParent: false,
      status: 'active',
      packageType: 'hours',
      singleSubject: true,
      remainingHours: 0,
    );
    expect(find.text('Renew subscription'), findsOneWidget);
  });

  testWidgets('monthly hides Renew before end date', (tester) async {
    await _pumpRenewalCard(
      tester,
      isParent: false,
      status: 'active',
      packageType: 'monthly',
      singleSubject: false,
      endDate: DateTime.utc(2100),
    );
    expect(find.text('Renew subscription'), findsNothing);
  });

  testWidgets('monthly shows Renew after end date', (tester) async {
    await _pumpRenewalCard(
      tester,
      isParent: false,
      status: 'expired',
      packageType: 'monthly',
      singleSubject: false,
      endDate: DateTime.utc(2020),
    );
    expect(find.text('Renew subscription'), findsOneWidget);
  });

  for (final status in const ['pending', 'confirmed']) {
    testWidgets('$status renewal hides duplicate action from canRenew', (
      tester,
    ) async {
      await _pumpRenewalCard(
        tester,
        isParent: false,
        status: status,
        packageType: 'monthly',
        singleSubject: false,
        canRenew: false,
      );
      expect(find.text('Renew subscription'), findsNothing);
    });
  }

  testWidgets('Gulf renewal follows remaining hours despite pending flag', (
    tester,
  ) async {
    await _pumpRenewalCard(
      tester,
      isParent: false,
      status: 'active',
      packageType: 'hours',
      singleSubject: true,
      canRenew: true,
      hasPendingRenewal: true,
      registrationMode: 'gulf',
    );
    expect(find.text('Pending review'), findsNothing);
    expect(find.text('Renew subscription'), findsOneWidget);
  });

  testWidgets('expired display status cannot enable backend-denied renewal', (
    tester,
  ) async {
    await _pumpRenewalCard(
      tester,
      isParent: false,
      status: 'expired',
      packageType: 'hours',
      singleSubject: true,
      canRenew: false,
    );
    expect(find.text('Renew subscription'), findsNothing);
  });

  for (final source in const [(false, 'Student'), (true, 'Parent')]) {
    testWidgets('${source.$2} -> Renew -> Back', (tester) async {
      await _verifyRenewalReturn(tester, isParent: source.$1, success: false);
    });
    testWidgets('${source.$2} -> Renew -> Success', (tester) async {
      await _verifyRenewalReturn(tester, isParent: source.$1, success: true);
    });
  }

  testWidgets('Egyptian pending return shows snackbar then refreshes', (
    tester,
  ) async {
    var pending = false;
    var refreshes = 0;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: ParentSubscriptionCard(
                child: const ParentChildSubscriptionsModel(
                  studentId: 'student',
                  studentName: 'Student',
                  curriculumId: 'egyptian-curriculum',
                  registrationMode: 'egyptian',
                  subscriptions: [],
                ),
                subscription: ParentChildSubscriptionModel(
                  id: 'subscription',
                  packageId: 'package',
                  packageName: 'Package',
                  curriculumId: 'curriculum',
                  packageType: 'hours',
                  canRenew: true,
                  hasPendingRenewal: pending,
                ),
                isParent: true,
                onRenewalPending: () => setState(() => pending = true),
                onRenewed: () async {
                  refreshes++;
                },
              ),
            ),
          ),
        ),
        GoRoute(
          path: Routes.parentSubscriptionRenewal,
          builder: (context, _) => Scaffold(
            body: TextButton(
              onPressed: () => context.pop(ParentFlowResult.pendingReview),
              child: const Text('POST accepted'),
            ),
          ),
        ),
      ],
    );
    await tester.pumpWidget(_localizedRouter(router));
    await tester.tap(find.text('Renew subscription'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('POST accepted'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(refreshes, 1);
    expect(find.text('Pending review'), findsOneWidget);
    expect(find.text('Renew subscription'), findsNothing);
    expect(
      find.text(
        'The renewal request was submitted successfully and is now pending administration review.',
      ),
      findsWidgets,
    );
  });

  testWidgets('Gulf pending return refreshes without Egyptian pending label', (
    tester,
  ) async {
    var pending = false;
    var refreshes = 0;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: ParentSubscriptionCard(
                child: const ParentChildSubscriptionsModel(
                  studentId: 'student',
                  studentName: 'Student',
                  curriculumId: 'gulf-curriculum',
                  registrationMode: 'gulf',
                  subscriptions: [],
                ),
                subscription: ParentChildSubscriptionModel(
                  id: 'subscription',
                  packageId: 'package',
                  packageName: 'Package',
                  curriculumId: 'gulf-curriculum',
                  packageType: 'hours',
                  remainingHours: 0,
                  canRenew: true,
                  hasPendingRenewal: pending,
                ),
                isParent: false,
                onRenewed: () async {
                  refreshes++;
                  setState(() => pending = true);
                },
              ),
            ),
          ),
        ),
        GoRoute(
          path: Routes.studentSubscriptionRenewal,
          builder: (context, _) => Scaffold(
            body: TextButton(
              onPressed: () => context.pop(ParentFlowResult.pendingReview),
              child: const Text('POST accepted'),
            ),
          ),
        ),
      ],
    );
    await tester.pumpWidget(_localizedRouter(router));
    await tester.tap(find.text('Renew subscription'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('POST accepted'));
    await tester.pumpAndSettle();

    expect(refreshes, 1);
    expect(find.text('Pending review'), findsNothing);
    expect(find.text('Renew subscription'), findsOneWidget);
  });

  testWidgets(
    'parent renewal uses selected mode and ignores rapid double tap',
    (tester) async {
      ParentSubscriptionRenewalArgs? received;
      var routeBuilds = 0;
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => Scaffold(
              body: ParentSubscriptionCard(
                child: const ParentChildSubscriptionsModel(
                  studentId: 'student',
                  studentName: 'Student',
                  curriculumId: '6a83284e6067abfc995abb3d',
                  registrationMode: 'gulf',
                  subscriptions: [],
                ),
                subscription: const ParentChildSubscriptionModel(
                  id: 'subscription',
                  packageId: 'package',
                  packageName: 'Package',
                  curriculumId: 'curriculum',
                  planKind: 'gulf',
                  packageType: 'hours',
                  canRenew: true,
                ),
                isParent: true,
              ),
            ),
          ),
          GoRoute(
            path: Routes.parentSubscriptionRenewal,
            builder: (_, state) {
              routeBuilds++;
              received = state.extra! as ParentSubscriptionRenewalArgs;
              final renewalState = ParentSubscriptionRenewalState(
                args: received!,
              );
              return Scaffold(
                body: Text(
                  renewalState.hasSupportedRegistrationMode
                      ? 'Parent Gulf renewal'
                      : 'This curriculum registration mode is not supported.',
                ),
              );
            },
          ),
        ],
      );
      await tester.pumpWidget(_localizedRouter(router));
      final renew = tester
          .widget<CustomAppButton>(find.byType(CustomAppButton))
          .onPressed!;
      renew();
      renew();
      await tester.pumpAndSettle();

      expect(routeBuilds, 1);
      expect(received?.registrationMode, 'gulf');
      expect(received?.curriculumId, '6a83284e6067abfc995abb3d');
      expect(find.text('Parent Gulf renewal'), findsOneWidget);
      expect(
        find.text('This curriculum registration mode is not supported.'),
        findsNothing,
      );
      expect(
        ParentSubscriptionRenewalState(
          args: received!,
        ).hasSupportedRegistrationMode,
        isTrue,
      );
      router.pop();
      await tester.pumpAndSettle();
    },
  );
}

Future<void> _verifyRenewalReturn(
  WidgetTester tester, {
  required bool isParent,
  required bool success,
}) async {
  final source = isParent ? 'Parent source' : 'Student source';
  final args = ParentSubscriptionRenewalArgs(
    studentId: 'student',
    curriculumId: 'curriculum',
    subscription: const ParentChildSubscriptionModel(
      id: 'subscription',
      packageId: 'package',
      packageName: 'Package',
      curriculumId: 'curriculum',
    ),
    subjects: const [],
    registrationMode: 'egyptian',
    isParent: isParent,
  );
  final router = GoRouter(
    initialLocation: '/source',
    routes: [
      GoRoute(
        path: '/source',
        builder: (context, _) => Scaffold(
          body: Column(
            children: [
              Text(source),
              TextButton(
                onPressed: () => context.push('/renewal'),
                child: const Text('Renew'),
              ),
            ],
          ),
        ),
      ),
      GoRoute(
        path: '/renewal',
        builder: (_, __) => Scaffold(
          appBar: const CustomAppbar(headerText: 'Renewal'),
          body: RenewalResult(
            state: ParentSubscriptionRenewalState(
              args: args,
              phase: ParentRenewalPhase.completed,
            ),
          ),
        ),
      ),
    ],
  );
  await tester.pumpWidget(_localizedRouter(router));
  await tester.tap(find.text('Renew'));
  await tester.pumpAndSettle();
  final back = success
      ? find.text(isParent ? 'Back to children' : 'Subscriptions')
      : find.byIcon(Icons.arrow_back);
  if (success) {
    final leave = tester
        .widget<CustomAppButton>(find.byType(CustomAppButton))
        .onPressed!;
    leave();
    leave();
  } else {
    await tester.tap(back);
  }
  await tester.pumpAndSettle();
  expect(find.text(source), findsOneWidget);
}

Widget _localizedRouter(GoRouter router) => MaterialApp.router(
  routerConfig: router,
  locale: const Locale('en'),
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
);

Future<void> _pumpRenewalCard(
  WidgetTester tester, {
  required bool isParent,
  required String status,
  required String packageType,
  required bool singleSubject,
  bool canRenew = true,
  bool hasPendingRenewal = false,
  num remainingHours = 0,
  DateTime? endDate,
  String? registrationMode,
}) => tester.pumpWidget(
  MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Scaffold(
      body: ParentSubscriptionCard(
        child: ParentChildSubscriptionsModel(
          studentId: 'student',
          studentName: 'Student',
          registrationMode: registrationMode,
          subscriptions: [],
        ),
        subscription: ParentChildSubscriptionModel(
          id: 'subscription',
          packageId: 'package',
          packageName: 'Package',
          curriculumId: '',
          packageType: packageType,
          computedStatus: status,
          canRenew: canRenew,
          hasPendingRenewal: hasPendingRenewal,
          remainingHours: remainingHours,
          endDate: endDate,
          accessScope: singleSubject ? 'single_subject' : 'all_subjects',
        ),
        isParent: isParent,
      ),
    ),
  ),
);
