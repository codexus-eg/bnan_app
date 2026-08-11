import 'dart:io';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/egyptian_renewal_request.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/gulf_renewal_request.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscriptions_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/renewal_status_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_state.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

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
    },
  );

  test('Egyptian FormData uses exact fields and studentId', () async {
    final directory = await Directory.systemTemp.createTemp('renewal-');
    final receipt = File('${directory.path}/receipt.png')
      ..writeAsBytesSync([1]);
    final form = await EgyptianRenewalRequest(
      studentId: 'child-1',
      packageId: 'package-1',
      subjectId: 'subject-1',
      receiptImage: receipt,
    ).toFormData();
    expect(form.fields.map((item) => item.key).toSet(), {
      'studentId',
      'packageId',
      'subjectId',
    });
    expect(
      form.fields.firstWhere((item) => item.key == 'studentId').value,
      'child-1',
    );
    expect(form.files.single.key, 'receiptImage');
    await receipt.delete();
    await directory.delete();
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

  test('receipt is required for Egyptian renewal', () async {
    final cubit = _ready(_Repo(), mode: 'egyptian');
    await cubit.submit();
    expect(cubit.state.errorMessage, S.current.paymentReceiptRequired);
    await cubit.close();
  });

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
      final cubit = _ready(repo, mode: 'gulf')
        ..updateAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Street');
      await cubit.submit();
      await _waitFor(cubit, ParentRenewalPhase.failure);
      await cubit.retry();
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
      final cubit = _ready(repo, mode: 'gulf')
        ..updateAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Street');
      await cubit.submit();
      expect(cubit.state.errorMessage, isNot(code));
      expect(cubit.state.phase, ParentRenewalPhase.failure);
      await cubit.close();
    });
  }

  test('duplicate submit sends one Gulf request', () async {
    final repo = _Repo(delay: const Duration(milliseconds: 20))
      ..terminalStatuses.add(RenewalPaymentStatus.completed);
    final cubit = _ready(repo, mode: 'gulf')
      ..updateAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Street');
    await Future.wait([cubit.submit(), cubit.submit()]);
    expect(repo.renewCalls, 1);
    await cubit.close();
  });

  test('Gulf single-subject package is rejected', () async {
    final cubit = _cubit(_Repo(), mode: 'gulf')..nextStep();
    cubit.selectPackage(_singlePackage);
    expect(cubit.state.package, isNull);
    await cubit.close();
  });

  test('Egyptian monthly single-subject package is rejected', () async {
    final cubit = _cubit(_Repo(), mode: 'egyptian')..nextStep();
    cubit.selectPackage(_monthlySinglePackage);
    expect(cubit.state.package, isNull);
    await cubit.close();
  });

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
    final cubit = _ready(repo, mode: 'gulf')
      ..updateAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Street');
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
    final cubit = _ready(repo, mode: 'gulf')
      ..updateAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Street');
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
    final cubit = _ready(repo, mode: 'gulf')
      ..updateAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Street');
    await cubit.submit();
    await cubit.retry();
    expect(repo.keys, ['key-1', 'key-2']);
    await cubit.close();
  });

  test('polling exhaustion exposes manual status check', () async {
    final repo = _Repo();
    final cubit = _ready(repo, mode: 'gulf')
      ..updateAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Street');
    var completedEmissions = 0;
    final subscription = cubit.stream.listen((state) {
      if (state.phase == ParentRenewalPhase.completed) completedEmissions++;
    });
    await cubit.submit();
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

  for (final status in [
    RenewalPaymentStatus.pending,
    RenewalPaymentStatus.confirmed,
  ]) {
    test('Egyptian $status does not refresh subscriptions', () async {
      final directory = await Directory.systemTemp.createTemp('renew-status-');
      final receipt = File('${directory.path}/receipt.png')
        ..writeAsBytesSync([1]);
      final repo = _Repo()..egyptianInitialStatuses.add(status);
      final cubit = _ready(repo, mode: 'egyptian')
        ..updateEgyptian(receipt: receipt);
      await cubit.submit();
      expect(repo.refreshCalls, 0);
      expect(cubit.state.status, status);
      await cubit.close();
      await directory.delete(recursive: true);
    });
  }

  test('checkout URL can be reopened without creating a checkout', () async {
    final repo = _Repo();
    final cubit = _ready(repo, mode: 'gulf')
      ..updateAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Street');
    await cubit.submit();
    await _waitFor(cubit, ParentRenewalPhase.paymentStatusUnknown);
    final calls = repo.renewCalls;
    cubit.reopenCheckout();
    expect(cubit.state.shouldOpenCheckout, isTrue);
    expect(repo.renewCalls, calls);
    await cubit.close();
  });

  test('rejected Egyptian renewal allows retry', () async {
    final directory = await Directory.systemTemp.createTemp('renew-retry-');
    final receipt = File('${directory.path}/receipt.png')
      ..writeAsBytesSync([1]);
    final repo = _Repo()
      ..egyptianInitialStatuses.addAll([
        RenewalPaymentStatus.rejected,
        RenewalPaymentStatus.pending,
      ]);
    final cubit = _ready(repo, mode: 'egyptian')
      ..updateEgyptian(receipt: receipt);
    await cubit.submit();
    expect(cubit.state.phase, ParentRenewalPhase.failure);
    await cubit.retry();
    expect(repo.egyptianRenewCalls, 2);
    await cubit.close();
    await directory.delete(recursive: true);
  });

  test('lifecycle checks do not run beside an active poller', () async {
    final repo = _Repo(statusDelay: const Duration(milliseconds: 20));
    final cubit = _ready(repo, mode: 'gulf')
      ..updateAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Street');
    await cubit.submit();
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
      final cubit = _ready(repo, mode: 'gulf')
        ..updateAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Street');
      await cubit.submit();
      await cubit.close();
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

ParentSubscriptionRenewalCubit _cubit(_Repo repo, {required String mode}) =>
    ParentSubscriptionRenewalCubit(
      repo: repo,
      keyGenerator: _Keys(),
      args: ParentSubscriptionRenewalArgs(
        studentId: 'child-1',
        curriculumId: 'curriculum-1',
        subscription: _subscription,
        subjects: const [
          ParentSubscriptionSubjectModel(id: 'subject-1', name: 'Math'),
        ],
        registrationMode: mode,
      ),
      pollInterval: Duration.zero,
      maxPollAttempts: 2,
    );
ParentSubscriptionRenewalCubit _ready(_Repo repo, {required String mode}) {
  final cubit = _cubit(repo, mode: mode)
    ..nextStep()
    ..selectPackage(_allPackage)
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

class _Repo implements ParentSubscriptionsRepo {
  _Repo({this.delay = Duration.zero, this.statusDelay = Duration.zero});
  final Duration delay, statusDelay;
  final List<RenewalPaymentStatus> terminalStatuses = [];
  final List<RenewalPaymentStatus> egyptianInitialStatuses = [];
  RenewalPaymentStatus egyptianStatusValue = RenewalPaymentStatus.pending;
  final List<Failure> checkoutFailures = [];
  final List<String> keys = [];
  String? failureCode;
  int renewCalls = 0, egyptianRenewCalls = 0, refreshCalls = 0;
  int activeChecks = 0, maxActiveChecks = 0;
  @override
  getSubscriptions() async {
    refreshCalls++;
    return const Right(ParentSubscriptionsResponse());
  }

  @override
  renewGulf({required request, required idempotencyKey}) async {
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
    egyptianRenewCalls++;
    egyptianStatusValue = egyptianInitialStatuses.isEmpty
        ? RenewalPaymentStatus.pending
        : egyptianInitialStatuses.removeAt(0);
    return Right(
      RenewalStatusResponse(paymentId: 'egypt-1', status: egyptianStatusValue),
    );
  }

  @override
  egyptianStatus(String id) async =>
      Right(RenewalStatusResponse(paymentId: id, status: egyptianStatusValue));
}
