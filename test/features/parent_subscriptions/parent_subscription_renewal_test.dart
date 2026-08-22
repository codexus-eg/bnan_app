import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dio_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/data/repo/packages_repo/packages_repo.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';
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
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
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
    'student and parent Gulf renewals share the same six-step flow',
    () async {
      for (final isParent in [false, true]) {
        final cubit = _cubit(_Repo(), mode: 'gulf', isParent: isParent);
        final state = cubit.state;

        expect(state.isGulf, isTrue);
        expect(state.lastStep, 5);
        expect(state.hasSupportedRegistrationMode, isTrue);
        await cubit.close();
      }
    },
  );

  test(
    'Gulf payload always sends studentId and omits subject for all subjects',
    () {
      final json = GulfRenewalRequest(
        studentId: 'child-1',
        packageId: 'package-1',
        paymentAddress: const ParentPaymentAddress(
          city: 'Riyadh',
          region: 'Riyadh',
          line1: 'Street',
        ),
      ).toJson();
      expect(json['studentId'], 'child-1');
      expect(json.containsKey('subjectId'), isFalse);
      expect(json.containsKey('password'), isFalse);
      expect(json['isMobile'], isTrue);
    },
  );

  test('renewal payloads omit studentId', () {
    final egyptian = const EgyptianRenewalRequest(
      packageId: 'package-1',
    ).toJson();
    final gulf = GulfRenewalRequest(
      packageId: 'package-1',
      paymentAddress: const ParentPaymentAddress(
        city: 'Riyadh',
        region: 'Riyadh',
        line1: 'Street',
      ),
    ).toJson();

    expect(egyptian.containsKey('studentId'), isFalse);
    expect(gulf.containsKey('studentId'), isFalse);
  });

  test('Egyptian JSON uses minimal fields without receipt', () {
    final json = const EgyptianRenewalRequest(
      packageId: 'package-1',
      subjectId: 'subject-1',
    ).toJson();
    expect(json.keys.toSet(), {'packageId', 'subjectId'});
    expect(json.containsKey('receiptImage'), isFalse);
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
      await ParentSubscriptionsRepoImpl(
        consumer,
      ).renewEgyptian(const EgyptianRenewalRequest(packageId: 'package-1'));
      expect(sent.path, EndPoints.egyptianSubscriptionRenewal);
      expect(sent.data, {'packageId': 'package-1'});
    },
  );

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
      '$owner Gulf renewal uses Tamara status and correct studentId',
      () async {
        final repo = _Repo()
          ..terminalStatuses.add(RenewalPaymentStatus.completed);
        final cubit = _ready(repo, mode: 'gulf', isParent: isParent);

        await cubit.submit();
        cubit.checkoutOpened();
        await cubit.reconcilePayment();

        expect(repo.lastGulfRequest?.studentId, isParent ? 'child-1' : null);
        expect(repo.keys.single, 'key-1');
        expect(cubit.state.phase, ParentRenewalPhase.completed);
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
      final cubit = _cubit(_Repo(), mode: 'gulf')..nextStep();
      cubit.selectPackage(_singlePackage);
      expect(cubit.state.package?.id, _singlePackage.id);
      await cubit.close();
    },
  );

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

  test('payload change after uncertainty creates a new key', () async {
    final repo = _Repo()
      ..checkoutFailures.add(
        Failure(message: 'timeout', responseReceived: false),
      );
    final cubit = _ready(repo, mode: 'gulf');
    await cubit.submit();
    cubit.updateDiscount('NEW');
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

  test('pending Gulf renewal restores and verifies after reopening', () async {
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
    await first.close();

    final repo = _Repo()..terminalStatuses.add(RenewalPaymentStatus.completed);
    final restored = _cubit(repo, mode: 'gulf', store: store);
    await restored.restore();
    expect(restored.state.phase, ParentRenewalPhase.completed);
    expect(store.draft, isNull);
    await restored.close();
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

const _subscription = ParentChildSubscriptionModel(
  id: 'sub',
  packageId: 'old',
  packageName: 'Old',
  curriculumId: 'curriculum-1',
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
  Future<void> Function()? onCompleted,
}) => ParentSubscriptionRenewalCubit(
  repo: repo,
  keyGenerator: _Keys(),
  store: store,
  args: ParentSubscriptionRenewalArgs(
    studentId: 'child-1',
    curriculumId: 'curriculum-1',
    subscription: _subscription,
    subjects: const [
      ParentSubscriptionSubjectModel(id: 'subject-1', name: 'Math'),
    ],
    registrationMode: mode,
    isParent: isParent,
    onCompleted: onCompleted,
  ),
  pollInterval: Duration.zero,
  maxPollAttempts: 2,
);
ParentSubscriptionRenewalCubit _ready(
  _Repo repo, {
  required String mode,
  RenewalPaymentStore? store,
  bool isParent = true,
  Future<void> Function()? onCompleted,
}) {
  final cubit =
      _cubit(
          repo,
          mode: mode,
          store: store,
          isParent: isParent,
          onCompleted: onCompleted,
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
  final List<String> keys = [];
  String? failureCode;
  EgyptianRenewalRequest? lastEgyptianRequest;
  GulfRenewalRequest? lastGulfRequest;
  int renewCalls = 0, egyptianRenewCalls = 0, refreshCalls = 0;
  int egyptianStatusCalls = 0;
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
    return const Right(
      RenewalStatusResponse(
        paymentId: 'payment-1',
        status: RenewalPaymentStatus.pending,
        checkoutUrl: 'https://checkout.example.com',
      ),
    );
  }

  @override
  gulfReconcile(String id) async {
    activeChecks++;
    if (activeChecks > maxActiveChecks) maxActiveChecks = activeChecks;
    await Future<void>.delayed(statusDelay);
    activeChecks--;
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
  gulfStatus(String id) async => Right(
    RenewalStatusResponse(paymentId: id, status: RenewalPaymentStatus.pending),
  );
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
