import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/payments/data/models/payment_draft.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_response.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:bnan_app/features/payments/data/payment_draft_store.dart';
import 'package:bnan_app/features/payments/data/repo/tamara_payment_repo.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_state.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  const store = PaymentDraftStore();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

  setUp(store.clear);

  test('timeout with same payload reuses idempotency key', () async {
    final repo = _PaymentRepo()
      ..checkoutFailure = Failure(message: 'timeout', responseReceived: false);
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    await cubit.checkout(_request);
    expect(repo.keys, ['key-1', 'key-1']);
    await cubit.close();
  });

  test('timeout with changed payload creates a new key', () async {
    final repo = _PaymentRepo()
      ..checkoutFailure = Failure(message: 'timeout', responseReceived: false);
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    await cubit.checkout(_requestWith(studentEmail: 'changed@example.com'));
    expect(repo.keys, ['key-1', 'key-2']);
    await cubit.close();
  });

  test('confirmed 400 then corrected payload creates a new key', () async {
    final repo = _PaymentRepo()
      ..checkoutFailure = Failure(
        message: 'validation',
        responseReceived: true,
        statusCode: 400,
      );
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    repo.checkoutFailure = null;
    await cubit.checkout(_requestWith(studentEmail: 'fixed@example.com'));
    expect(repo.keys, ['key-1', 'key-2']);
    await cubit.close();
  });

  test('changing parent creates a new key after timeout', () async {
    final repo = _uncertainRepo();
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    await cubit.checkout(_requestWith(parentEmail: 'other@example.com'));
    expect(repo.keys, ['key-1', 'key-2']);
    await cubit.close();
  });

  test('changing subjects address or package creates a new key', () async {
    final variants = [
      _requestWith(subjects: const ['subject-2']),
      _requestWith(
        address: const PaymentAddress(
          city: 'Jeddah',
          region: 'Makkah',
          line1: 'New address',
        ),
      ),
      _requestWith(packageId: 'package-2'),
    ];
    for (final variant in variants) {
      await store.clear();
      final repo = _uncertainRepo();
      final cubit = _cubit(repo, store);
      await cubit.checkout(_request);
      await cubit.checkout(variant);
      expect(repo.keys, ['key-1', 'key-2']);
      await cubit.close();
    }
  });

  test('does not create checkout or key while payment is pending', () async {
    final repo = _PaymentRepo();
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    await cubit.checkout(_request);
    expect(repo.keys, ['key-1']);
    await cubit.close();
  });

  test('fast repeated taps create one checkout request', () async {
    final repo = _PaymentRepo()..checkoutCompleter = Completer();
    final cubit = _cubit(repo, store);
    final first = cubit.checkout(_request);
    final second = cubit.checkout(_request);
    await Future<void>.delayed(Duration.zero);
    expect(repo.keys, ['key-1']);
    repo.checkoutCompleter!.complete(const Right(_checkoutResponse));
    await Future.wait([first, second]);
    expect(repo.keys, ['key-1']);
    await cubit.close();
  });

  for (final status in [
    PaymentStatus.failed,
    PaymentStatus.cancelled,
    PaymentStatus.expired,
  ]) {
    test('creates a new key after ${status.name}', () async {
      final repo = _PaymentRepo()..statusResponse = _status(status);
      final cubit = _cubit(repo, store);
      await cubit.checkout(_request);
      await cubit.checkStatus();
      await cubit.checkout(_request);
      expect(repo.keys, ['key-1', 'key-2']);
      await cubit.close();
    });
  }

  test(
    'foreground does not reconcile before checkout URL was opened',
    () async {
      final repo = _PaymentRepo();
      final cubit = _cubit(repo, store);
      await cubit.checkout(_request);
      await cubit.onForeground();
      expect(repo.reconcileCalls, 0);
      await cubit.close();
    },
  );

  test('reconcile runs once after browser return', () async {
    final repo = _PaymentRepo();
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    await _markBrowserOpened(cubit);
    cubit.onBackground();
    await cubit.onForeground();
    await cubit.onForeground();
    expect(repo.reconcileCalls, 1);
    await cubit.close();
  });

  test('checkout URL can only be claimed once before background', () async {
    final cubit = _cubit(_PaymentRepo(), store);
    await cubit.checkout(_request);
    expect(cubit.claimCheckoutLaunch(_checkoutUrl), isTrue);
    expect(cubit.claimCheckoutLaunch(_checkoutUrl), isFalse);
    await cubit.completeCheckoutLaunch(opened: true);
    expect(cubit.claimCheckoutLaunch(_checkoutUrl), isFalse);
    cubit.onBackground();
    expect(cubit.claimCheckoutLaunch(_checkoutUrl), isTrue);
    await cubit.close();
  });

  test('student login happens only after completed', () async {
    final repo = _PaymentRepo();
    final auth = _AuthRepo();
    final cubit = _cubit(repo, store, auth: auth);
    await cubit.checkout(_request);
    expect(auth.loginCalls, 0);
    repo.statusResponse = _status(PaymentStatus.completed);
    await cubit.checkStatus();
    expect(auth.loginCalls, 1);
    expect(auth.lastEmail, 'student@example.com');
    expect(store.read(), isNull);
    expect(
      cubit.state,
      isA<TamaraPaymentResult>().having(
        (state) => state.studentLoggedIn,
        'studentLoggedIn',
        isTrue,
      ),
    );
    await cubit.close();
  });

  test('polling stops when cubit is disposed', () async {
    final repo = _PaymentRepo();
    final cubit = _cubit(
      repo,
      store,
      pollInterval: const Duration(milliseconds: 2),
    );
    await cubit.checkout(_request);
    await _markBrowserOpened(cubit);
    cubit.onBackground();
    await cubit.onForeground();
    await Future<void>.delayed(const Duration(milliseconds: 12));
    await cubit.close();
    final callsAtDispose = repo.statusCalls;
    await Future<void>.delayed(const Duration(milliseconds: 12));
    expect(repo.statusCalls, callsAtDispose);
  });

  test('polling stops when status becomes completed', () async {
    final repo = _PaymentRepo()
      ..statusResponse = _status(PaymentStatus.completed);
    final cubit = _cubit(
      repo,
      store,
      pollInterval: const Duration(milliseconds: 2),
    );
    await cubit.checkout(_request);
    await _markBrowserOpened(cubit);
    cubit.onBackground();
    await cubit.onForeground();
    await Future<void>.delayed(const Duration(milliseconds: 12));
    final callsAtCompletion = repo.statusCalls;
    await Future<void>.delayed(const Duration(milliseconds: 12));
    expect(repo.statusCalls, callsAtCompletion);
    expect(cubit.state, isA<TamaraPaymentResult>());
    await cubit.close();
  });

  test('completed draft remains with email when student login fails', () async {
    final repo = _PaymentRepo()
      ..statusResponse = _status(PaymentStatus.completed);
    final auth = _AuthRepo()..loginFailure = true;
    final cubit = _cubit(repo, store, auth: auth);
    await cubit.checkout(_request);
    await cubit.checkStatus();
    final draft = store.read();
    expect(draft?.lastKnownStatus, PaymentStatus.completed);
    expect(draft?.studentEmail, 'student@example.com');
    expect(draft?.packageId, isEmpty);
    await cubit.checkout(_request);
    expect(repo.keys, ['key-1']);
    await cubit.close();
  });

  test('status requests stay single-flight', () async {
    final repo = _PaymentRepo()..statusCompleter = Completer();
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    final first = cubit.checkStatus();
    final second = cubit.checkStatus();
    expect(repo.statusCalls, 1);
    repo.statusCompleter!.complete(Right(_status(PaymentStatus.pending)));
    await Future.wait([first, second]);
    expect(repo.statusCalls, 1);
    await cubit.close();
  });

  test('polling limit keeps pending status', () async {
    final repo = _PaymentRepo();
    final cubit = _cubit(
      repo,
      store,
      pollInterval: const Duration(milliseconds: 2),
      maxPollAttempts: 2,
    );
    await cubit.checkout(_request);
    await _markBrowserOpened(cubit);
    cubit.onBackground();
    await cubit.onForeground();
    await Future<void>.delayed(const Duration(milliseconds: 15));
    final callsAtLimit = repo.statusCalls;
    await Future<void>.delayed(const Duration(milliseconds: 8));
    expect(repo.statusCalls, callsAtLimit);
    expect(cubit.draft?.lastKnownStatus, PaymentStatus.pending);
    await cubit.close();
  });

  test('restores a pending payment draft without passwords', () async {
    await store.save(
      PaymentDraft(
        paymentId: 'payment-1',
        checkoutUrl: 'https://checkout.tamara.co/order',
        idempotencyKey: 'saved-key',
        packageId: 'package-1',
        curriculumId: 'curriculum-1',
        gradeId: 'grade-1',
        subjectIds: const ['subject-1'],
        studentEmail: 'student@example.com',
        paymentStartedAt: DateTime(2026),
        lastKnownStatus: PaymentStatus.pending,
      ),
    );
    final cubit = _cubit(_PaymentRepo(), store);
    await cubit.restore();
    expect(cubit.draft?.idempotencyKey, 'saved-key');
    expect(cubit.state, isA<TamaraPaymentPending>());
    await cubit.close();
  });
}

_PaymentRepo _uncertainRepo() =>
    _PaymentRepo()
      ..checkoutFailure = Failure(message: 'network', responseReceived: false);

TamaraPaymentCubit _cubit(
  _PaymentRepo repo,
  PaymentDraftStore store, {
  _AuthRepo? auth,
  Duration pollInterval = const Duration(days: 1),
  int maxPollAttempts = 20,
}) {
  return TamaraPaymentCubit(
    repo: repo,
    authRepo: auth ?? _AuthRepo(),
    store: store,
    keyGenerator: _Keys(),
    pollInterval: pollInterval,
    maxPollAttempts: maxPollAttempts,
  );
}

class _Keys extends IdempotencyKeyGenerator {
  int count = 0;

  @override
  String create() => 'key-${++count}';
}

class _PaymentRepo implements TamaraPaymentRepo {
  final keys = <String>[];
  Failure? checkoutFailure;
  int reconcileCalls = 0;
  int statusCalls = 0;
  TamaraStatusResponse statusResponse = _status(PaymentStatus.pending);
  Completer<Either<Failure, TamaraCheckoutResponse>>? checkoutCompleter;
  Completer<Either<Failure, TamaraStatusResponse>>? statusCompleter;

  @override
  Future<Either<Failure, TamaraCheckoutResponse>> checkout({
    required TamaraCheckoutRequest request,
    required String idempotencyKey,
  }) async {
    keys.add(idempotencyKey);
    if (checkoutCompleter != null) return checkoutCompleter!.future;
    if (checkoutFailure != null) return Left(checkoutFailure!);
    return const Right(_checkoutResponse);
  }

  @override
  Future<Either<Failure, TamaraStatusResponse>> reconcile(
    String paymentId,
  ) async {
    reconcileCalls++;
    return Right(_status(PaymentStatus.pending));
  }

  @override
  Future<Either<Failure, TamaraStatusResponse>> status(String paymentId) async {
    statusCalls++;
    if (statusCompleter != null) return statusCompleter!.future;
    return Right(statusResponse);
  }
}

class _AuthRepo implements AuthRepo {
  int loginCalls = 0;
  String? lastEmail;
  bool loginFailure = false;

  @override
  Future<Either<Failure, AuthResponseModel>> loginStudentAfterPayment({
    required String email,
    required String password,
  }) async {
    loginCalls++;
    lastEmail = email;
    if (loginFailure) return Left(Failure(message: 'login failed'));
    return Right(
      AuthResponseModel.fromJson({
        'success': true,
        'token': 'student-token',
        'data': {
          'id': 'student-1',
          'role': 'student',
          'status': 'active',
          'email': email,
        },
      }),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _markBrowserOpened(TamaraPaymentCubit cubit) async {
  expect(cubit.claimCheckoutLaunch(_checkoutUrl), isTrue);
  await cubit.completeCheckoutLaunch(opened: true);
}

TamaraStatusResponse _status(PaymentStatus status) => TamaraStatusResponse(
  paymentId: 'payment-1',
  status: status,
  checkoutUrl: 'https://checkout.tamara.co/order',
);

const _request = TamaraCheckoutRequest(
  parentEmail: 'parent@example.com',
  parentPassword: 'ParentPass123',
  student: RegisterStudentModel(
    fullName: 'Student',
    email: 'student@example.com',
    password: 'StudentPass123',
    grade: 'grade-1',
    subjects: ['subject-1'],
  ),
  curriculumId: 'curriculum-1',
  packageId: 'package-1',
  address: PaymentAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Address'),
);

TamaraCheckoutRequest _requestWith({
  String? parentEmail,
  String? studentEmail,
  List<String>? subjects,
  String? packageId,
  PaymentAddress? address,
}) {
  return TamaraCheckoutRequest(
    parentEmail: parentEmail ?? _request.parentEmail,
    parentPassword: _request.parentPassword,
    student: RegisterStudentModel(
      fullName: _request.student.fullName,
      email: studentEmail ?? _request.student.email,
      password: _request.student.password,
      grade: _request.student.grade,
      subjects: subjects ?? _request.student.subjects,
    ),
    curriculumId: _request.curriculumId,
    packageId: packageId ?? _request.packageId,
    address: address ?? _request.address,
    locale: _request.locale,
  );
}

const _checkoutUrl = 'https://checkout.tamara.co/order';
const _checkoutResponse = TamaraCheckoutResponse(
  paymentId: 'payment-1',
  checkoutUrl: _checkoutUrl,
  orderId: 'order-1',
  status: 'pending',
  providerStatus: 'new',
);
