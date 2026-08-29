import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dio_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/custom_back_icon.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';
import 'package:bnan_app/features/packages_management/data/repo/packages_repo/packages_repo.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/egyptian_renewal_request.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/gulf_renewal_request.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscriptions_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/renewal_status_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/renewal_payment_draft.dart';
import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo_impl.dart';
import 'package:bnan_app/features/parent_subscriptions/data/store/renewal_payment_store.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_state.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/views/parent_subscription_renewal_view.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/renewal_review_steps.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await S.load(const Locale('en'));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          (_) async => null,
        );
  });

  test(
    'student and parent Gulf renewals use current subscription and package',
    () async {
      for (final isParent in [false, true]) {
        final cubit = _cubit(_Repo(), mode: 'gulf', isParent: isParent);
        final state = cubit.state;

        expect(state.isGulf, isTrue);
        expect(state.lastStep, 1);
        expect(state.hasSupportedRegistrationMode, isTrue);
        await cubit.close();
      }
    },
  );

  test('Gulf payload adds the default payment address', () {
    final json = GulfRenewalRequest(
      subscriptionId: 'math-sub',
      packageId: 'package-1',
      paymentAddress: _defaultPaymentAddress,
    ).toJson();
    expect(json, {
      'provider': 'tamara',
      'subscriptionId': 'math-sub',
      'packageId': 'package-1',
      'paymentAddress': _defaultPaymentAddress.toJson(),
    });
    for (final key in [
      'studentId',
      'subjectId',
      'remainingHours',
      'price',
      'hours',
      'packageType',
    ]) {
      expect(json.containsKey(key), isFalse);
    }
  });

  test('Paymob Gulf renewal payload omits paymentAddress', () {
    final json = GulfRenewalRequest(
      subscriptionId: 'math-sub',
      packageId: 'package-1',
      paymentAddress: _defaultPaymentAddress,
      provider: GulfPaymentProvider.paymob,
    ).toJson();
    expect(json['provider'], 'paymob');
    expect(json, isNot(contains('paymentAddress')));
  });

  test('legacy renewal draft without provider defaults to Tamara', () {
    final json = _renewalDraft('subscription-1').toJson()..remove('provider');
    final draft = RenewalPaymentDraft.fromJson(json);
    expect(draft.provider, GulfPaymentProvider.tamara);
  });

  test('only completed status is treated as completed', () {
    final gulf = RenewalStatusResponse.fromJson({
      'data': {'paymentId': 'payment-1', 'status': 'success'},
    });
    final completed = RenewalStatusResponse.fromJson({
      'data': {'paymentId': 'payment-1', 'status': 'completed'},
    });

    expect(gulf.status, RenewalPaymentStatus.unknown);
    expect(completed.status, RenewalPaymentStatus.completed);
  });

  test('renewal payloads omit studentId when it is not supplied', () {
    final egyptian = const EgyptianRenewalRequest(
      packageId: 'package-1',
    ).toJson();
    final gulf = GulfRenewalRequest(
      subscriptionId: 'math-sub',
      packageId: 'package-1',
      paymentAddress: _defaultPaymentAddress,
    ).toJson();

    expect(egyptian.containsKey('studentId'), isFalse);
    expect(gulf.containsKey('studentId'), isFalse);
  });

  test('Egyptian private JSON uses only subscriptionId and packageId', () {
    final json = const EgyptianRenewalRequest(
      subscriptionId: 'math-subscription-id',
      packageId: 'package-1',
      subjectId: 'subject-1',
    ).toJson();
    expect(json, {
      'subscriptionId': 'math-subscription-id',
      'packageId': 'package-1',
    });
    for (final key in ['subjectId', 'price', 'hours', 'packageType']) {
      expect(json.containsKey(key), isFalse);
    }
  });

  test('PackageModel reads the backend _id as packageId', () {
    expect(PackageModel.fromJson({'_id': 'package-1'}).id, 'package-1');
  });

  test(
    'Egyptian repo posts the minimal payload to the renewal endpoint',
    () async {
      final dio = Dio();
      final consumer = DioConsumer(dio: dio);
      late RequestOptions sent;
      dio.interceptors.insert(
        0,
        InterceptorsWrapper(
          onRequest: (options, handler) {
            sent = options;
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'status': 'completed'},
              ),
            );
          },
        ),
      );
      await ParentSubscriptionsRepoImpl(consumer).renewEgyptian(
        const EgyptianRenewalRequest(
          subscriptionId: 'math-sub',
          packageId: 'package-1',
        ),
      );
      expect(sent.path, EndPoints.egyptianSubscriptionRenewal);
      expect(sent.data, {
        'subscriptionId': 'math-sub',
        'packageId': 'package-1',
      });
    },
  );

  test(
    'Parent and Student private renew the exact selected subscription',
    () async {
      for (final isParent in [true, false]) {
        final repo = _Repo();
        final cubit = _cubit(
          repo,
          mode: 'egyptian',
          isParent: isParent,
          subscription: _mathPrivateSubscription,
        )..nextStep();
        cubit.selectPackage(_singlePackage);

        expect(cubit.state.lastStep, 1);
        await cubit.submit();

        expect(repo.lastEgyptianRequest?.toJson(), {
          'subscriptionId': 'math-sub',
          'packageId': 'package-1',
          if (isParent) 'studentId': 'child-1',
        });
        await cubit.close();
      }
    },
  );

  test('Parent Egyptian monthly sends current child and package IDs', () async {
    final repo = _Repo();
    final cubit = _cubit(
      repo,
      mode: 'egyptian',
      isParent: true,
      studentId: 'selected-child-42',
      subscription: _monthlySubscription,
    );

    cubit.selectAutomaticMonthlyPackage([_singlePackage, _monthlyAllPackage]);
    await cubit.submit();

    expect(repo.lastEgyptianRequest?.toJson(), {
      'packageId': 'monthly-package',
      'studentId': 'selected-child-42',
    });
    await cubit.close();
  });

  test('Student Egyptian monthly keeps studentId omitted', () async {
    final repo = _Repo();
    final cubit = _cubit(
      repo,
      mode: 'egyptian',
      isParent: false,
      subscription: _monthlySubscription,
    );

    cubit.selectAutomaticMonthlyPackage([_singlePackage, _monthlyAllPackage]);
    await cubit.submit();

    expect(repo.lastEgyptianRequest?.toJson(), {
      'packageId': 'monthly-package',
    });
    await cubit.close();
  });

  test('Parent and Student monthly auto-select the monthly package', () async {
    for (final isParent in [true, false]) {
      final repo = _Repo();
      final cubit = _cubit(
        repo,
        mode: 'egyptian',
        isParent: isParent,
        subscription: _monthlySubscription,
      );

      expect(cubit.state.lastStep, 0);
      cubit.selectAutomaticMonthlyPackage([_singlePackage, _monthlyAllPackage]);
      expect(cubit.state.package, _monthlyAllPackage);

      await cubit.submit();
      await cubit.submit();

      expect(repo.egyptianRenewCalls, 1);
      expect(repo.lastEgyptianRequest?.packageId, _monthlyAllPackage.id);
      await cubit.close();
    }
  });

  test('Egyptian private only accepts single-subject hours packages', () async {
    final cubit = _cubit(
      _Repo(),
      mode: 'egyptian',
      subscription: _mathPrivateSubscription,
    )..nextStep();

    cubit.selectPackage(_monthlyAllPackage);
    expect(cubit.state.package, isNull);
    cubit.selectPackage(_singlePackage);
    expect(cubit.state.package, _singlePackage);
    await cubit.close();
  });

  test('Egyptian private without subscription ID does not call repo', () async {
    final repo = _Repo();
    final cubit = _cubit(
      repo,
      mode: 'egyptian',
      subscription: _missingIdPrivateSubscription,
    )..nextStep();
    cubit.selectPackage(_singlePackage);

    await cubit.submit();

    expect(repo.egyptianRenewCalls, 0);
    expect(cubit.state.errorMessage, S.current.invalidData);
    await cubit.close();
  });

  test(
    'single subject requires one assigned subject and package curriculum',
    () async {
      final cubit = _cubit(_Repo(), mode: 'egyptian');
      cubit.nextStep();
      cubit.selectPackage(
        const PackageModel(id: 'bad', curriculum: 'other', isActive: true),
      );
      expect(cubit.state.package, isNull);
      cubit.selectPackage(_singlePackage);
      expect(cubit.nextStep(), isTrue);
      expect(cubit.nextStep(), isFalse);
      cubit.selectSubject('subject-1');
      expect(cubit.nextStep(), isTrue);
      await cubit.close();
    },
  );

  test('Egyptian renewal submits without receipt', () async {
    final repo = _Repo();
    final cubit = _ready(repo, mode: 'egyptian');
    await cubit.submit();
    expect(repo.egyptianRenewCalls, 1);
    await cubit.close();
  });

  test(
    'Egyptian package without id never enters loading or calls repo',
    () async {
      final repo = _Repo();
      final cubit = _cubit(repo, mode: 'egyptian')
        ..nextStep()
        ..selectPackage(
          const PackageModel(
            curriculum: 'curriculum-1',
            accessScope: 'all_subjects',
            type: 'monthly',
            isActive: true,
          ),
        )
        ..nextStep()
        ..nextStep();
      await cubit.submit();
      expect(repo.egyptianRenewCalls, 0);
      expect(cubit.state.phase, ParentRenewalPhase.editing);
      await cubit.close();
    },
  );

  testWidgets('Egyptian monthly confirm pops without polling', (tester) async {
    var refreshes = 0;
    final repo = _Repo();
    final cubit =
        _cubit(
            repo,
            mode: 'egyptian',
            isParent: false,
            onCompleted: () async => refreshes++,
          )
          ..nextStep()
          ..selectPackage(_monthlyAllPackage)
          ..nextStep()
          ..nextStep();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            body: TextButton(
              onPressed: () => context.push('/renewal'),
              child: const Text('Student source'),
            ),
          ),
        ),
        GoRoute(
          path: '/renewal',
          builder: (_, __) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: cubit),
              BlocProvider(
                create: (_) => GetPackagesCubit(_UnusedPackagesRepo()),
              ),
            ],
            child: const ParentSubscriptionRenewalView(),
          ),
        ),
      ],
    );
    await tester.pumpWidget(_app(router));
    await tester.tap(find.text('Student source'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit renewal request'));
    await tester.pumpAndSettle();
    expect(repo.egyptianRenewCalls, 1);
    expect(refreshes, 0);
    expect(repo.egyptianStatusCalls, 0);
    expect(cubit.state.phase, ParentRenewalPhase.pending);
    expect(find.text('Student source'), findsOneWidget);
    expect(find.text('Back to children'), findsNothing);
    await cubit.close();
  });

  testWidgets(
    'second back after Tamara return exits immediately without payment work',
    (tester) async {
      final repo = _Repo();
      final store = _MemoryRenewalStore();
      final cubit = _ready(repo, mode: 'gulf', store: store);
      await tester.runAsync(cubit.submit);
      cubit.checkoutOpened();
      await tester.runAsync(cubit.checkoutClosed);
      final renewCalls = repo.renewCalls;
      final reconcileCalls = repo.gulfReconcileCalls;
      final statusCalls = repo.gulfStatusCalls;
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) => Scaffold(
              body: TextButton(
                onPressed: () => context.push('/renewal'),
                child: const Text('Previous screen'),
              ),
            ),
          ),
          GoRoute(
            path: '/renewal',
            builder: (_, __) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: cubit),
                BlocProvider(
                  create: (_) => GetPackagesCubit(_UnusedPackagesRepo()),
                ),
              ],
              child: const ParentSubscriptionRenewalView(),
            ),
          ),
        ],
      );
      await tester.pumpWidget(_app(router));
      await tester.tap(find.text('Previous screen'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final backIcon = tester.widget<CustomBackIcon>(
        find.byType(CustomBackIcon),
      );
      backIcon.onTap!();
      backIcon.onTap!();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Previous screen'), findsOneWidget);
      expect(cubit.state.isBusy, isFalse);
      expect(repo.renewCalls, renewCalls);
      expect(repo.gulfReconcileCalls, reconcileCalls);
      expect(repo.gulfStatusCalls, statusCalls);
      expect(store.draft, isNotNull);
      await cubit.close();
    },
  );

  testWidgets('Gulf renewal review exposes discount and fixed payment CTA', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final cubit = _ready(_Repo(), mode: 'gulf');
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: cubit),
              BlocProvider(
                create: (_) => GetPackagesCubit(_UnusedPackagesRepo()),
              ),
            ],
            child: const ParentSubscriptionRenewalView(),
          ),
        ),
      ],
    );
    await tester.pumpWidget(_app(router));
    await tester.pump();

    expect(find.byType(RenewalDiscountStep), findsOneWidget);
    expect(find.text(S.current.renewalConfirmPayment), findsOneWidget);
    expect(find.text(S.current.paymob), findsOneWidget);
    await cubit.close();
  });

  test('Gulf renewal without checkout fails without pending review', () async {
    final repo = _Repo()..gulfCheckoutUrl = null;
    final store = _MemoryRenewalStore();
    final cubit = _ready(repo, mode: 'gulf', isParent: false, store: store);

    await cubit.submit();

    expect(repo.renewCalls, 1);
    expect(cubit.state.phase, ParentRenewalPhase.failure);
    expect(cubit.state.status, isNull);
    expect(cubit.state.shouldOpenCheckout, isFalse);
    expect(cubit.state.errorMessage, S.current.renewalFailed);
    expect(store.draft, isNull);
    await cubit.close();
  });

  for (final isParent in [false, true]) {
    final owner = isParent ? 'parent' : 'student';
    test('$owner Egyptian renewal stays pending after one request', () async {
      var refreshes = 0;
      final repo = _Repo();
      final cubit = _ready(
        repo,
        mode: 'egyptian',
        isParent: isParent,
        onCompleted: () async => refreshes++,
      );

      await cubit.submit();

      expect(repo.egyptianRenewCalls, 1);
      expect(repo.lastEgyptianRequest?.packageId, _monthlyAllPackage.id);
      expect(refreshes, 0);
      expect(repo.egyptianStatusCalls, 0);
      expect(cubit.state.phase, ParentRenewalPhase.pending);
      await cubit.close();
    });

    test(
      '$owner Gulf renewal uses exact subscription and package IDs',
      () async {
        var refreshes = 0;
        final repo = _Repo()
          ..terminalStatuses.add(RenewalPaymentStatus.completed);
        final cubit = _ready(
          repo,
          mode: 'gulf',
          isParent: isParent,
          onCompleted: () async => refreshes++,
        );

        await cubit.submit();
        cubit.checkoutOpened();
        await Future.wait([cubit.reconcilePayment(), cubit.reconcilePayment()]);

        expect(repo.lastGulfRequest?.subscriptionId, 'sub');
        expect(repo.lastGulfRequest?.toJson(), {
          'provider': 'tamara',
          'subscriptionId': 'sub',
          'packageId': 'package-1',
          'paymentAddress': _defaultPaymentAddress.toJson(),
        });
        expect(repo.keys.single, 'key-1');
        expect(cubit.state.phase, ParentRenewalPhase.completed);
        expect(refreshes, 1);
        await cubit.reconcilePayment();
        expect(refreshes, 1);
        await cubit.close();
      },
    );
  }

  test('single_subject renewal sends its selected subjectId', () async {
    final repo = _Repo();
    final cubit = _cubit(repo, mode: 'egyptian')
      ..nextStep()
      ..selectPackage(_singlePackage)
      ..nextStep()
      ..selectSubject('subject-1')
      ..nextStep()
      ..nextStep();

    await cubit.submit();

    expect(repo.lastEgyptianRequest?.subjectId, 'subject-1');
    await cubit.close();
  });

  test(
    'completed renewal refreshes the originating subscriptions once',
    () async {
      var refreshes = 0;
      final repo = _Repo()
        ..terminalStatuses.add(RenewalPaymentStatus.completed);
      final cubit = _ready(
        repo,
        mode: 'gulf',
        onCompleted: () async {
          refreshes++;
        },
      );

      await cubit.submit();
      cubit.checkoutOpened();
      await cubit.reconcilePayment();

      expect(refreshes, 1);
      await cubit.checkPaymentStatus();
      expect(refreshes, 1);
      await cubit.close();
    },
  );

  test(
    'Gulf terminal retry creates a new key and keeps parent session',
    () async {
      await SessionManager.instance.saveSession(
        accessToken: 'parent-token',
        refreshToken: 'refresh',
        userRole: UserRole.parent.name,
      );
      final repo = _Repo()
        ..terminalStatuses.addAll([
          RenewalPaymentStatus.failed,
          RenewalPaymentStatus.completed,
        ]);
      final cubit = _ready(repo, mode: 'gulf');
      await cubit.submit();
      cubit.checkoutOpened();
      await cubit.reconcilePayment();
      await _waitFor(cubit, ParentRenewalPhase.failure);
      await cubit.retry();
      cubit.checkoutOpened();
      await cubit.reconcilePayment();
      await _waitFor(cubit, ParentRenewalPhase.completed);
      expect(repo.keys, ['key-1', 'key-2']);
      expect(repo.refreshCalls, 0);
      expect(SessionManager.instance.role, UserRole.parent);
      expect(SessionManager.instance.accessToken, 'parent-token');
      await cubit.close();
      await SessionManager.instance.clearSession();
    },
  );

  for (final code in ['SUBSCRIPTION_STILL_ACTIVE', 'STUDENT_ACCESS_DENIED']) {
    test('$code is mapped without raw backend text', () async {
      final repo = _Repo()..failureCode = code;
      final cubit = _ready(repo, mode: 'gulf');
      await cubit.submit();
      expect(cubit.state.errorMessage, isNot(code));
      expect(cubit.state.phase, ParentRenewalPhase.failure);
      await cubit.close();
    });
  }

  test('duplicate submit sends one Gulf request', () async {
    final repo = _Repo(delay: const Duration(milliseconds: 20))
      ..terminalStatuses.add(RenewalPaymentStatus.completed);
    final cubit = _ready(repo, mode: 'gulf');
    await Future.wait([cubit.submit(), cubit.submit()]);
    expect(repo.renewCalls, 1);
    await cubit.close();
  });

  test(
    'active Gulf single-subject package follows server package response',
    () async {
      final cubit = _cubit(
        _Repo(),
        mode: 'gulf',
        subscription: _mathPrivateSubscription,
      )..nextStep();
      cubit.selectPackage(_singlePackage);
      expect(cubit.state.package?.id, _singlePackage.id);
      await cubit.close();
    },
  );

  test('Gulf Math renewal never asks for or sends a subject', () async {
    final repo = _Repo();
    final cubit = _cubit(
      repo,
      mode: 'gulf',
      isParent: false,
      subscription: _mathPrivateSubscription,
    )..nextStep();
    cubit.selectPackage(_singlePackage);

    expect(cubit.state.lastStep, 1);
    await cubit.submit();

    expect(repo.lastGulfRequest?.toJson(), {
      'provider': 'tamara',
      'subscriptionId': 'math-sub',
      'packageId': 'package-1',
      'paymentAddress': _defaultPaymentAddress.toJson(),
    });
    await cubit.close();
  });

  test(
    'Egyptian monthly single-subject package is rejected by current policy',
    () async {
      final cubit = _cubit(_Repo(), mode: 'egyptian')..nextStep();
      cubit.selectPackage(_monthlySinglePackage);
      expect(cubit.state.package, isNull);
      expect(cubit.state.errorMessage, S.current.invalidPackage);
      await cubit.close();
    },
  );

  test('unknown registration mode is rejected', () async {
    final cubit = _cubit(_Repo(), mode: '')..nextStep();
    cubit.selectPackage(_allPackage);
    expect(cubit.state.package, isNull);
    await cubit.close();
  });

  test('uncertain checkout retry reuses the same key', () async {
    final repo = _Repo()
      ..checkoutFailures.add(
        Failure(message: 'timeout', responseReceived: false),
      );
    final cubit = _ready(repo, mode: 'gulf');
    await cubit.submit();
    await cubit.retry();
    expect(repo.keys, ['key-1', 'key-1']);
    await cubit.close();
  });

  test(
    'uncertain renewal persists its idempotency key before response',
    () async {
      final store = _MemoryRenewalStore();
      final repo = _Repo()
        ..checkoutFailures.add(
          Failure(message: 'timeout', responseReceived: false),
        );
      final cubit = _ready(repo, mode: 'gulf', store: store);
      await cubit.submit();
      expect(store.draft?.paymentId, isEmpty);
      expect(store.draft?.idempotencyKey, 'key-1');
      expect(store.draft?.provider, GulfPaymentProvider.tamara);
      await cubit.close();
    },
  );

  test('Paymob renewal status path skips reconcile', () async {
    final repo = _Repo();
    final cubit = _ready(
      repo,
      mode: 'gulf',
      provider: GulfPaymentProvider.paymob,
    );
    await cubit.submit();
    cubit.checkoutOpened();
    await cubit.checkoutClosed();
    expect(repo.gulfReconcileCalls, 0);
    expect(repo.gulfStatusCalls, greaterThanOrEqualTo(1));
    await cubit.close();
  });

  test(
    'renewal defaults to Tamara and selected Paymob reaches request',
    () async {
      final repo = _Repo();
      final cubit = _ready(repo, mode: 'gulf');
      expect(cubit.state.selectedProvider, GulfPaymentProvider.tamara);
      cubit.selectPaymentProvider(GulfPaymentProvider.paymob);
      await cubit.submit();
      expect(cubit.state.selectedProvider, GulfPaymentProvider.paymob);
      expect(repo.lastGulfRequest?.provider, GulfPaymentProvider.paymob);
      expect(repo.lastGulfRequest?.toJson(), isNot(contains('paymentAddress')));
      await cubit.close();
    },
  );

  test('payload change after uncertainty creates a new key', () async {
    final repo = _Repo()
      ..checkoutFailures.add(
        Failure(message: 'timeout', responseReceived: false),
      );
    final cubit = _ready(repo, mode: 'gulf');
    await cubit.submit();
    cubit.selectPackage(
      const PackageModel(
        id: 'package-2',
        curriculum: 'curriculum-1',
        accessScope: 'all_subjects',
        type: 'hours',
        isActive: true,
      ),
    );
    await cubit.retry();
    expect(repo.keys, ['key-1', 'key-2']);
    await cubit.close();
  });

  test('definite checkout failure retries with a new key', () async {
    final repo = _Repo()
      ..checkoutFailures.add(
        Failure(message: 'rejected request', responseReceived: true),
      );
    final cubit = _ready(repo, mode: 'gulf');
    await cubit.submit();
    await cubit.retry();
    expect(repo.keys, ['key-1', 'key-2']);
    await cubit.close();
  });

  test('polling exhaustion exposes manual status check', () async {
    final repo = _Repo();
    final cubit = _ready(repo, mode: 'gulf');
    var completedEmissions = 0;
    final subscription = cubit.stream.listen((state) {
      if (state.phase == ParentRenewalPhase.completed) completedEmissions++;
    });
    await cubit.submit();
    cubit.checkoutOpened();
    await cubit.reconcilePayment();
    await _waitFor(cubit, ParentRenewalPhase.paymentStatusUnknown);
    repo.terminalStatuses.add(RenewalPaymentStatus.completed);
    await cubit.checkPaymentStatus();
    await cubit.checkPaymentStatus();
    expect(cubit.state.phase, ParentRenewalPhase.completed);
    expect(completedEmissions, 1);
    expect(repo.refreshCalls, 0);
    await subscription.cancel();
    await cubit.close();
  });

  test('checkout URL can be reopened without creating a checkout', () async {
    final repo = _Repo();
    final cubit = _ready(repo, mode: 'gulf');
    await cubit.submit();
    cubit.checkoutOpened();
    await cubit.reconcilePayment();
    await _waitFor(cubit, ParentRenewalPhase.paymentStatusUnknown);
    final calls = repo.renewCalls;
    cubit.reopenCheckout();
    expect(cubit.state.shouldOpenCheckout, isTrue);
    expect(repo.renewCalls, calls);
    await cubit.close();
  });

  test('Tamara back ends loading without reporting payment success', () async {
    final repo = _Repo();
    final cubit = _ready(repo, mode: 'gulf');
    await cubit.submit();
    cubit.checkoutOpened();

    await cubit.checkoutClosed();

    expect(cubit.state.phase, ParentRenewalPhase.paymentStatusUnknown);
    expect(cubit.state.isBusy, isFalse);
    expect(repo.renewCalls, 1);
    expect(repo.gulfReconcileCalls, 1);
    expect(repo.gulfStatusCalls, 1);
    await cubit.close();
  });

  test('Tamara back keeps the same checkout retryable', () async {
    final repo = _Repo();
    final cubit = _ready(repo, mode: 'gulf');
    await cubit.submit();
    cubit.checkoutOpened();
    await cubit.checkoutClosed();

    cubit.reopenCheckout();

    expect(cubit.state.shouldOpenCheckout, isTrue);
    expect(repo.renewCalls, 1);
    await cubit.close();
  });

  test('duplicate Tamara close events share one reconcile', () async {
    final repo = _Repo(statusDelay: const Duration(milliseconds: 20));
    final cubit = _ready(
      repo,
      mode: 'gulf',
      checkoutCloseTimeout: const Duration(milliseconds: 100),
    );
    await cubit.submit();
    cubit.checkoutOpened();

    await Future.wait([cubit.checkoutClosed(), cubit.checkoutClosed()]);

    expect(repo.gulfReconcileCalls, 1);
    expect(repo.maxActiveChecks, 1);
    await cubit.close();
  });

  test('Tamara close preserves an authoritative completed result', () async {
    var refreshes = 0;
    final repo = _Repo()..terminalStatuses.add(RenewalPaymentStatus.completed);
    final cubit = _ready(
      repo,
      mode: 'gulf',
      onCompleted: () async => refreshes++,
    );
    await cubit.submit();
    cubit.checkoutOpened();

    await cubit.checkoutClosed();

    expect(cubit.state.phase, ParentRenewalPhase.completed);
    expect(refreshes, 1);
    expect(repo.gulfReconcileCalls, 1);
    await cubit.close();
  });

  test('Tamara close failure and timeout never leave loading active', () async {
    final failureRepo = _Repo()
      ..reconcileFailure = Failure(message: 'reconcile failed');
    final failureCubit = _ready(failureRepo, mode: 'gulf');
    await failureCubit.submit();
    failureCubit.checkoutOpened();
    await failureCubit.checkoutClosed();
    expect(failureCubit.state.phase, ParentRenewalPhase.paymentStatusUnknown);
    expect(failureCubit.state.isBusy, isFalse);
    await failureCubit.close();

    final timeoutRepo = _Repo(statusDelay: const Duration(milliseconds: 30));
    final timeoutCubit = _ready(
      timeoutRepo,
      mode: 'gulf',
      checkoutCloseTimeout: const Duration(milliseconds: 1),
    );
    await timeoutCubit.submit();
    timeoutCubit.checkoutOpened();
    await timeoutCubit.checkoutClosed();
    expect(timeoutCubit.state.phase, ParentRenewalPhase.paymentStatusUnknown);
    expect(timeoutCubit.state.isBusy, isFalse);
    await timeoutCubit.close();
  });

  test('matching subscriptionId restores Gulf renewal', () async {
    await SessionManager.instance.saveSession(
      accessToken: 'token',
      refreshToken: '',
      userId: 'parent-1',
      userRole: UserRole.parent.name,
    );
    final store = _MemoryRenewalStore();
    final first = _ready(_Repo(), mode: 'gulf', store: store);
    await first.submit();
    expect(store.draft?.paymentId, 'payment-1');
    expect(store.draft?.subscriptionId, _subscription.id);
    await first.close();

    final repo = _Repo()..terminalStatuses.add(RenewalPaymentStatus.completed);
    final restored = _cubit(repo, mode: 'gulf', store: store);
    await restored.restore();
    expect(restored.state.phase, ParentRenewalPhase.completed);
    expect(store.draft, isNull);
    await restored.close();
    await SessionManager.instance.clearSession();
  });

  test('different subscriptionId is ignored and cleared', () async {
    await _saveParentSession();
    final store = _MemoryRenewalStore()..draft = _renewalDraft('other-sub');
    final repo = _Repo();
    final cubit = _cubit(repo, mode: 'gulf', store: store);

    await cubit.restore();

    expect(cubit.state.phase, ParentRenewalPhase.editing);
    expect(store.draft, isNull);
    expect(repo.maxActiveChecks, 0);
    await cubit.close();
    await SessionManager.instance.clearSession();
  });

  test('legacy draft without subscriptionId is ignored and cleared', () async {
    await _saveParentSession();
    final json = _renewalDraft(_subscription.id).toJson()
      ..remove('subscriptionId');
    final store = _MemoryRenewalStore()
      ..draft = RenewalPaymentDraft.fromJson(json);
    final repo = _Repo();
    final cubit = _cubit(repo, mode: 'gulf', store: store);

    await cubit.restore();

    expect(cubit.state.phase, ParentRenewalPhase.editing);
    expect(store.draft, isNull);
    expect(repo.maxActiveChecks, 0);
    await cubit.close();
    await SessionManager.instance.clearSession();
  });

  test('renewal restore keeps the saved Paymob provider', () async {
    await _saveParentSession();
    final json = _renewalDraft(_subscription.id).toJson()
      ..['provider'] = 'paymob'
      ..['paymentId'] = '';
    final store = _MemoryRenewalStore()
      ..draft = RenewalPaymentDraft.fromJson(json);
    final cubit = _cubit(_Repo(), mode: 'gulf', store: store);
    await cubit.restore();
    expect(cubit.state.selectedProvider, GulfPaymentProvider.paymob);
    await cubit.close();
    await SessionManager.instance.clearSession();
  });

  test('Egyptian 409 stays on the wizard and allows retry', () async {
    final repo = _Repo()
      ..egyptianFailures.add(
        Failure(
          message: 'SUBSCRIPTION_STILL_ACTIVE',
          code: 'SUBSCRIPTION_STILL_ACTIVE',
          statusCode: 409,
        ),
      );
    final cubit = _ready(repo, mode: 'egyptian');
    await cubit.submit();
    expect(cubit.state.phase, ParentRenewalPhase.editing);
    expect(cubit.state.errorMessage, S.current.renewalSubscriptionStillActive);
    await cubit.submit();
    expect(repo.egyptianRenewCalls, 2);
    expect(cubit.state.phase, ParentRenewalPhase.pending);
    await cubit.close();
  });

  for (final isParent in [false, true]) {
    test(
      '${isParent ? 'Parent' : 'Student'} Egyptian already-in-progress becomes pending',
      () async {
        final repo = _Repo()
          ..egyptianFailures.add(
            Failure(
              message: 'يوجد طلب تجديد قيد المراجعة بالفعل لهذا الاشتراك.',
              code: 'RENEWAL_ALREADY_IN_PROGRESS',
              statusCode: 409,
            ),
          );
        final cubit = _ready(repo, mode: 'egyptian', isParent: isParent);

        await cubit.submit();

        expect(repo.egyptianRenewCalls, 1);
        expect(cubit.state.phase, ParentRenewalPhase.pending);
        expect(cubit.state.status, RenewalPaymentStatus.pending);
        expect(cubit.state.errorMessage, isNull);
        expect(cubit.state.shouldOpenCheckout, isFalse);
        await cubit.close();
      },
    );
  }

  test('lifecycle checks do not run beside an active poller', () async {
    final repo = _Repo(statusDelay: const Duration(milliseconds: 20));
    final cubit = _ready(repo, mode: 'gulf');
    await cubit.submit();
    cubit.checkoutOpened();
    await Future<void>.delayed(Duration.zero);
    await Future.wait([cubit.reconcilePayment(), cubit.reconcilePayment()]);
    await _waitFor(cubit, ParentRenewalPhase.paymentStatusUnknown);
    expect(repo.maxActiveChecks, 1);
    await cubit.close();
  });

  test(
    'disposing during polling stops without a completion emission',
    () async {
      final repo = _Repo(statusDelay: const Duration(milliseconds: 20));
      final cubit = _ready(repo, mode: 'gulf');
      await cubit.submit();
      cubit.checkoutOpened();
      final polling = cubit.reconcilePayment();
      await Future<void>.delayed(Duration.zero);
      await cubit.close();
      await polling;
      await Future<void>.delayed(const Duration(milliseconds: 25));
      expect(cubit.isClosed, isTrue);
    },
  );
}

const _defaultPaymentAddress = ParentPaymentAddress(
  city: 'Riyadh',
  region: 'Riyadh',
  line1: 'Riyadh',
);
const _subscription = ParentChildSubscriptionModel(
  id: 'sub',
  packageId: 'old',
  packageName: 'Old',
  curriculumId: 'curriculum-1',
);
const _mathPrivateSubscription = ParentChildSubscriptionModel(
  id: 'math-sub',
  packageId: 'old-private',
  packageName: 'Math',
  curriculumId: 'curriculum-1',
  accessScope: 'single_subject',
  packageType: 'hours',
  subject: ParentSubscriptionSubjectModel(id: 'math', name: 'Math'),
);
const _monthlySubscription = ParentChildSubscriptionModel(
  id: 'monthly-sub',
  packageId: 'old-monthly',
  packageName: 'Monthly',
  curriculumId: 'curriculum-1',
  accessScope: 'all_subjects',
  packageType: 'monthly',
);
const _missingIdPrivateSubscription = ParentChildSubscriptionModel(
  id: '',
  packageId: 'old-private',
  packageName: 'Math',
  curriculumId: 'curriculum-1',
  accessScope: 'single_subject',
  packageType: 'hours',
);
const _singlePackage = PackageModel(
  id: 'package-1',
  curriculum: 'curriculum-1',
  accessScope: 'single_subject',
  type: 'hours',
  isActive: true,
);
const _allPackage = PackageModel(
  id: 'package-1',
  curriculum: 'curriculum-1',
  accessScope: 'all_subjects',
  type: 'hours',
  isActive: true,
);
const _monthlySinglePackage = PackageModel(
  id: 'monthly-single',
  curriculum: 'curriculum-1',
  accessScope: 'single_subject',
  type: 'monthly',
  isActive: true,
);
const _monthlyAllPackage = PackageModel(
  id: 'monthly-package',
  curriculum: 'curriculum-1',
  accessScope: 'all_subjects',
  type: 'monthly',
  isActive: true,
);

Widget _app(GoRouter router) => MaterialApp.router(
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

ParentSubscriptionRenewalCubit _cubit(
  _Repo repo, {
  required String mode,
  RenewalPaymentStore? store,
  bool isParent = true,
  String studentId = 'child-1',
  Future<void> Function()? onCompleted,
  ParentChildSubscriptionModel subscription = _subscription,
  Duration checkoutCloseTimeout = const Duration(milliseconds: 50),
  GulfPaymentProvider provider = GulfPaymentProvider.tamara,
}) => ParentSubscriptionRenewalCubit(
  repo: repo,
  keyGenerator: _Keys(),
  store: store,
  args: ParentSubscriptionRenewalArgs(
    studentId: studentId,
    curriculumId: 'curriculum-1',
    subscription: subscription,
    subjects: const [
      ParentSubscriptionSubjectModel(id: 'subject-1', name: 'Math'),
    ],
    registrationMode: mode,
    isParent: isParent,
    onCompleted: onCompleted,
  ),
  pollInterval: Duration.zero,
  maxPollAttempts: 2,
  checkoutCloseTimeout: checkoutCloseTimeout,
  provider: provider,
);
ParentSubscriptionRenewalCubit _ready(
  _Repo repo, {
  required String mode,
  RenewalPaymentStore? store,
  bool isParent = true,
  Future<void> Function()? onCompleted,
  Duration checkoutCloseTimeout = const Duration(milliseconds: 50),
  GulfPaymentProvider provider = GulfPaymentProvider.tamara,
}) {
  final cubit =
      _cubit(
          repo,
          mode: mode,
          store: store,
          isParent: isParent,
          onCompleted: onCompleted,
          checkoutCloseTimeout: checkoutCloseTimeout,
          provider: provider,
        )
        ..nextStep()
        ..selectPackage(mode == 'egyptian' ? _monthlyAllPackage : _allPackage)
        ..nextStep()
        ..nextStep()
        ..nextStep()
        ..nextStep();
  return cubit;
}

Future<void> _waitFor(
  ParentSubscriptionRenewalCubit cubit,
  ParentRenewalPhase phase,
) async {
  for (var i = 0; i < 100 && cubit.state.phase != phase; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
  expect(cubit.state.phase, phase);
}

class _Keys extends IdempotencyKeyGenerator {
  int count = 0;
  @override
  String create() => 'key-${++count}';
}

Future<void> _saveParentSession() => SessionManager.instance.saveSession(
  accessToken: 'token',
  refreshToken: '',
  userId: 'parent-1',
  userRole: UserRole.parent.name,
);

RenewalPaymentDraft _renewalDraft(String subscriptionId) => RenewalPaymentDraft(
  paymentId: 'payment-1',
  checkoutUrl: 'https://checkout.example.com',
  studentId: 'child-1',
  subscriptionId: subscriptionId,
  ownerUserId: 'parent-1',
  idempotencyKey: 'key-1',
  payloadFingerprint: 'fingerprint-1',
  isParent: true,
  createdAt: DateTime.utc(2026).toIso8601String(),
  registrationMode: 'gulf',
);

class _MemoryRenewalStore extends RenewalPaymentStore {
  RenewalPaymentDraft? draft;
  @override
  RenewalPaymentDraft? read() => draft;
  @override
  Future<void> save(RenewalPaymentDraft value) async => draft = value;
  @override
  Future<void> clear() async => draft = null;
}

class _Repo implements ParentSubscriptionsRepo {
  _Repo({this.delay = Duration.zero, this.statusDelay = Duration.zero});
  final Duration delay, statusDelay;
  final List<RenewalPaymentStatus> terminalStatuses = [];
  final List<RenewalPaymentStatus> egyptianInitialStatuses = [];
  final List<RenewalPaymentStatus> egyptianPollStatuses = [];
  RenewalPaymentStatus egyptianStatusValue = RenewalPaymentStatus.pending;
  final List<Failure> checkoutFailures = [];
  final List<Failure> egyptianFailures = [];
  Failure? reconcileFailure;
  final List<String> keys = [];
  String? failureCode;
  String? gulfCheckoutUrl = 'https://checkout.example.com';
  EgyptianRenewalRequest? lastEgyptianRequest;
  GulfRenewalRequest? lastGulfRequest;
  int renewCalls = 0, egyptianRenewCalls = 0, refreshCalls = 0;
  int egyptianStatusCalls = 0;
  int gulfReconcileCalls = 0, gulfStatusCalls = 0;
  int activeChecks = 0, maxActiveChecks = 0;
  @override
  getSubscriptions() async {
    refreshCalls++;
    return const Right(ParentSubscriptionsResponse());
  }

  @override
  renewGulf({required request, required idempotencyKey}) async {
    lastGulfRequest = request;
    renewCalls++;
    keys.add(idempotencyKey);
    await Future<void>.delayed(delay);
    if (checkoutFailures.isNotEmpty) {
      return Left(checkoutFailures.removeAt(0));
    }
    if (failureCode != null) return Left(Failure(message: failureCode!));
    return Right(
      RenewalStatusResponse(
        paymentId: 'payment-1',
        status: RenewalPaymentStatus.pending,
        checkoutUrl: gulfCheckoutUrl,
      ),
    );
  }

  @override
  gulfReconcile(String id) async {
    gulfReconcileCalls++;
    activeChecks++;
    if (activeChecks > maxActiveChecks) maxActiveChecks = activeChecks;
    await Future<void>.delayed(statusDelay);
    activeChecks--;
    if (reconcileFailure != null) return Left(reconcileFailure!);
    return Right(
      RenewalStatusResponse(
        paymentId: id,
        status: terminalStatuses.isEmpty
            ? RenewalPaymentStatus.pending
            : terminalStatuses.removeAt(0),
      ),
    );
  }

  @override
  gulfStatus(String id) async {
    gulfStatusCalls++;
    return Right(
      RenewalStatusResponse(
        paymentId: id,
        status: RenewalPaymentStatus.pending,
      ),
    );
  }

  @override
  renewEgyptian(EgyptianRenewalRequest request) async {
    lastEgyptianRequest = request;
    egyptianRenewCalls++;
    if (egyptianFailures.isNotEmpty) {
      return Left(egyptianFailures.removeAt(0));
    }
    egyptianStatusValue = egyptianInitialStatuses.isEmpty
        ? RenewalPaymentStatus.pending
        : egyptianInitialStatuses.removeAt(0);
    return Right(
      RenewalStatusResponse(paymentId: 'egypt-1', status: egyptianStatusValue),
    );
  }

  @override
  egyptianStatus(String id) async {
    egyptianStatusCalls++;
    return Right(
      RenewalStatusResponse(
        paymentId: id,
        status: egyptianPollStatuses.isEmpty
            ? egyptianStatusValue
            : egyptianPollStatuses.removeAt(0),
      ),
    );
  }
}

class _UnusedPackagesRepo implements PackagesRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
