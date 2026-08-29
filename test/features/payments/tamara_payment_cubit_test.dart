import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/payments/data/models/payment_draft.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  const store = PaymentDraftStore();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    FlutterSecureStorage.setMockInitialValues({});
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

  test('Paymob verification skips reconcile and uses status', () async {
    final repo = _PaymentRepo();
    final cubit = _cubit(repo, store);
    await cubit.checkout(_requestWith(provider: GulfPaymentProvider.paymob));
    await cubit.verifyProviderSuccess();
    expect(repo.reconcileCalls, 0);
    expect(repo.statusCalls, 1);
    await cubit.close();
  });

  test('registration restore ignores an add-child draft', () async {
    await store.save(
      PaymentDraft(
        paymentId: 'add-child-payment',
        idempotencyKey: 'saved-key',
        packageId: 'package-1',
        curriculumId: 'curriculum-1',
        gradeId: 'grade-1',
        subjectIds: const ['subject-1'],
        studentEmail: 'student@example.com',
        paymentStartedAt: DateTime(2026),
        lastKnownStatus: PaymentStatus.pending,
        purpose: PaymentDraftPurpose.addChild,
      ),
    );
    final cubit = _cubit(_PaymentRepo(), store);
    await cubit.restore();
    expect(cubit.draft, isNull);
    expect(store.read()?.purpose, PaymentDraftPurpose.addChild);
    await cubit.close();
  });

  test(
    'discarding a registration attempt preserves an add-child draft',
    () async {
      await store.save(
        PaymentDraft(
          paymentId: 'add-child-payment',
          idempotencyKey: 'saved-key',
          packageId: 'package-1',
          curriculumId: 'curriculum-1',
          gradeId: 'grade-1',
          subjectIds: const ['subject-1'],
          studentEmail: 'student@example.com',
          paymentStartedAt: DateTime(2026),
          lastKnownStatus: PaymentStatus.pending,
          purpose: PaymentDraftPurpose.addChild,
        ),
      );
      final cubit = _cubit(_PaymentRepo(), store);
      await cubit.discardStaleAttempt();
      expect(store.read()?.purpose, PaymentDraftPurpose.addChild);
      await cubit.close();
    },
  );

  test(
    'starting a registration flow discards an old pending payment',
    () async {
      final repo = _PaymentRepo();
      final cubit = _cubit(repo, store);
      await cubit.checkout(_request);
      await cubit.discardStaleAttempt();
      expect(cubit.draft, isNull);
      expect(store.read(), isNull);
      await cubit.close();
    },
  );

  test('pending payment with changed payload starts a new checkout', () async {
    final repo = _PaymentRepo();
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    repo.checkoutResponse = const TamaraCheckoutResponse(
      paymentId: 'payment-2',
      checkoutUrl: _checkoutUrl,
      orderId: 'order-2',
      status: 'pending',
      providerStatus: 'new',
    );
    await cubit.checkout(_requestWith(studentEmail: 'new@example.com'));
    expect(repo.keys, ['key-1', 'key-2']);
    expect(cubit.draft?.paymentId, 'payment-2');
    await cubit.close();
  });

  test('changing authenticated parent clears the pending draft', () async {
    await SessionManager.instance.saveSession(
      accessToken: 'parent-1-token',
      refreshToken: '',
      userId: 'parent-1',
      userRole: 'parent',
    );
    final repo = _PaymentRepo();
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    await SessionManager.instance.saveSession(
      accessToken: 'parent-2-token',
      refreshToken: '',
      userId: 'parent-2',
      userRole: 'parent',
    );
    expect(cubit.draft, isNull);
    await cubit.onForeground();
    expect(repo.reconcileCalls, 0);
    expect(repo.statusCalls, 0);
    await cubit.close();
    await SessionManager.instance.clearSession();
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

  test('retains the payment summary returned by checkout', () async {
    final repo = _PaymentRepo()
      ..checkoutResponse = TamaraCheckoutResponse.fromJson({
        'data': {
          'paymentId': 'payment-1',
          'checkoutUrl': _checkoutUrl,
          'status': 'pending',
          'originalAmount': '500',
          'discountAmount': 125,
          'finalAmount': 375,
          'currency': 'SAR',
          'discount': {'code': 'FAMILY25', 'type': 'children'},
        },
      });
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    expect(cubit.paymentSummary?.finalAmount, 375);
    expect(cubit.paymentSummary?.discount?.code, 'FAMILY25');
    await cubit.close();
  });

  test('changing payment input clears the stale backend amount', () async {
    final repo = _PaymentRepo()
      ..checkoutResponse = TamaraCheckoutResponse.fromJson({
        'data': {
          'paymentId': 'payment-1',
          'checkoutUrl': _checkoutUrl,
          'status': 'pending',
          'finalAmount': 375,
          'currency': 'SAR',
        },
      });
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);

    cubit.invalidateAmountSummary();

    expect(cubit.paymentSummary, isNull);
    expect(cubit.state, isA<TamaraPaymentInitial>());
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
    'foreground verifies a saved pending attempt before checkout opens',
    () async {
      final repo = _PaymentRepo();
      final cubit = _cubit(repo, store);
      await cubit.checkout(_request);
      await cubit.onForeground();
      expect(repo.reconcileCalls, 1);
      expect(repo.statusCalls, 1);
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
    expect(repo.statusCalls, 1);
    await cubit.close();
  });

  test(
    'provider success reconciles then checks authoritative status',
    () async {
      final repo = _PaymentRepo()
        ..statusResponse = _status(PaymentStatus.completed);
      final cubit = _cubit(repo, store);
      await cubit.checkout(_request);
      await _markBrowserOpened(cubit);

      await cubit.verifyProviderSuccess();

      expect(repo.reconcileCalls, 1);
      expect(repo.statusCalls, 1);
      expect(cubit.state, isA<TamaraPaymentResult>());
      await cubit.close();
    },
  );

  test('deep link is deduplicated and status remains authoritative', () async {
    final repo = _PaymentRepo()
      ..statusResponse = _status(PaymentStatus.pending);
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    final link = Uri.parse('bnanacademy://payment/tamara/success');
    await cubit.handleReturn(link);
    await cubit.handleReturn(link);
    expect(repo.reconcileCalls, 1);
    expect(repo.statusCalls, 1);
    expect(cubit.state, isA<TamaraPaymentPending>());
    expect(cubit.isAwaitingVerification, isFalse);
    await cubit.checkout(_requestWith(provider: GulfPaymentProvider.paymob));
    expect(repo.keys, ['key-1']);
    expect(
      cubit.state,
      isA<TamaraPaymentPending>().having(
        (state) => state.shouldOpenCheckout,
        'shouldOpenCheckout',
        isTrue,
      ),
    );
    await cubit.close();
  });

  test(
    'cold-start return reconciles without checkout opened timestamp',
    () async {
      final repo = _PaymentRepo()
        ..statusResponse = _status(PaymentStatus.cancelled);
      await store.save(
        PaymentDraft(
          paymentId: 'payment-1',
          checkoutUrl: _checkoutUrl,
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
      final cubit = _cubit(repo, store);
      await cubit.handleReturn(
        Uri.parse('bnanacademy://payment/tamara/cancel'),
      );
      expect(repo.reconcileCalls, 1);
      expect(repo.statusCalls, 1);
      expect(cubit.draft?.lastKnownStatus, PaymentStatus.cancelled);
      await cubit.close();
    },
  );

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

  test('current payment keeps verification email in memory only', () async {
    final repo = _PaymentRepo();
    final auth = _AuthRepo();
    final cubit = _cubit(repo, store, auth: auth);
    await cubit.checkout(_request);
    expect(auth.loginCalls, 0);
    repo.statusResponse = _status(PaymentStatus.completed);
    await cubit.checkStatus();
    expect(auth.loginCalls, 0);
    expect(cubit.draft?.studentEmail, 'student@example.com');
    expect(cubit.draft?.lastKnownStatus, PaymentStatus.completed);
    expect(cubit.canOpenAccountVerification, isTrue);
    expect(store.read(), isNull);
    expect(
      cubit.state,
      isA<TamaraPaymentResult>().having(
        (state) => state.studentLoggedIn,
        'studentLoggedIn',
        isFalse,
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
    await cubit.onForeground();
    await Future<void>.delayed(const Duration(milliseconds: 12));
    final callsAtCompletion = repo.statusCalls;
    await Future<void>.delayed(const Duration(milliseconds: 12));
    expect(repo.statusCalls, callsAtCompletion);
    expect(cubit.state, isA<TamaraPaymentResult>());
    await cubit.close();
  });

  test('completed attempt keeps email only for the current run', () async {
    final repo = _PaymentRepo()
      ..statusResponse = _status(PaymentStatus.completed);
    final auth = _AuthRepo()..loginFailure = true;
    final cubit = _cubit(repo, store, auth: auth);
    await cubit.checkout(_request);
    await cubit.checkStatus();
    expect(cubit.draft?.lastKnownStatus, PaymentStatus.completed);
    expect(cubit.draft?.studentEmail, 'student@example.com');
    expect(cubit.draft?.packageId, isEmpty);
    expect(cubit.canOpenAccountVerification, isTrue);
    expect(store.read(), isNull);
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

  test('status response cannot replace the checkout payment id', () async {
    final repo = _PaymentRepo()
      ..statusResponse = const TamaraStatusResponse(
        paymentId: 'unrelated-payment',
        status: PaymentStatus.pending,
      );
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    await cubit.checkStatus();
    expect(cubit.draft?.paymentId, 'payment-1');
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
    await cubit.onForeground();
    await Future<void>.delayed(const Duration(milliseconds: 15));
    final callsAtLimit = repo.statusCalls;
    await Future<void>.delayed(const Duration(milliseconds: 8));
    expect(repo.statusCalls, callsAtLimit);
    expect(cubit.draft?.lastKnownStatus, PaymentStatus.pending);
    expect(cubit.state, isA<TamaraPaymentPending>());
    expect(cubit.isAwaitingVerification, isFalse);
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
    expect(cubit.canOpenAccountVerification, isFalse);
    expect(cubit.state, isA<TamaraPaymentVerificationPending>());
    await cubit.close();
  });

  test('restore clears completed account verification state', () async {
    await store.save(
      PaymentDraft(
        paymentId: 'payment-1',
        idempotencyKey: '',
        packageId: '',
        curriculumId: '',
        gradeId: '',
        subjectIds: const [],
        studentEmail: 'student@example.com',
        paymentStartedAt: DateTime(2026),
        lastKnownStatus: PaymentStatus.completed,
      ),
    );
    final cubit = _cubit(_PaymentRepo(), store);

    await cubit.restore();

    expect(cubit.draft, isNull);
    expect(store.read(), isNull);
    expect(cubit.canOpenAccountVerification, isFalse);
    expect(cubit.state, isA<TamaraPaymentInitial>());
    await cubit.close();
  });

  test(
    'restored pending completion cannot reopen account verification',
    () async {
      await store.save(
        PaymentDraft(
          paymentId: 'payment-1',
          checkoutUrl: _checkoutUrl,
          checkoutOpenedAt: DateTime(2026),
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
      final repo = _PaymentRepo()
        ..statusResponse = _status(PaymentStatus.completed);
      final cubit = _cubit(repo, store);

      await cubit.restore();
      await cubit.onForeground();

      expect(cubit.state, isA<TamaraPaymentResult>());
      expect(cubit.canOpenAccountVerification, isFalse);
      expect(store.read(), isNull);
      await cubit.close();
    },
  );

  test(
    'leaving a pending checkout stops polling without verification',
    () async {
      final repo = _PaymentRepo();
      final auth = _AuthRepo();
      final cubit = _cubit(
        repo,
        store,
        auth: auth,
        pollInterval: const Duration(milliseconds: 2),
      );
      await cubit.checkout(_request);
      await _markBrowserOpened(cubit);
      await cubit.onForeground();
      await cubit.abandonCheckout();
      final callsAtClose = repo.statusCalls;
      await Future<void>.delayed(const Duration(milliseconds: 12));
      expect(repo.statusCalls, callsAtClose);
      expect(auth.loginCalls, 0);
      expect(
        cubit.state,
        isA<TamaraPaymentPending>().having(
          (state) => state.shouldOpenCheckout,
          'shouldOpenCheckout',
          isFalse,
        ),
      );
      await cubit.close();
    },
  );

  test('Tamara cancel ends loading and reopens the saved checkout', () async {
    final repo = _PaymentRepo();
    final cubit = _cubit(
      repo,
      store,
      pollInterval: const Duration(milliseconds: 2),
    );
    await cubit.checkout(_request);
    await _markBrowserOpened(cubit);

    await cubit.verifyCheckoutClosedOnce();

    expect(cubit.state, isA<TamaraPaymentPending>());
    expect(cubit.isAwaitingVerification, isFalse);
    expect(repo.reconcileCalls, 1);
    expect(repo.statusCalls, 1);
    await Future<void>.delayed(const Duration(milliseconds: 12));
    expect(repo.statusCalls, 1);
    await cubit.checkout(_request);
    expect(repo.keys, hasLength(1));
    expect(
      cubit.state,
      isA<TamaraPaymentPending>().having(
        (state) => state.shouldOpenCheckout,
        'shouldOpenCheckout',
        isTrue,
      ),
    );
    await cubit.close();
  });

  test('duplicate Tamara close callbacks share one status check', () async {
    final repo = _PaymentRepo()..statusCompleter = Completer();
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    await _markBrowserOpened(cubit);

    final first = cubit.verifyCheckoutClosedOnce();
    final second = cubit.verifyCheckoutClosedOnce();
    await Future<void>.delayed(Duration.zero);
    expect(repo.reconcileCalls, 1);
    expect(repo.statusCalls, 1);
    repo.statusCompleter!.complete(Right(_status(PaymentStatus.pending)));
    await Future.wait([first, second]);
    expect(repo.reconcileCalls, 1);
    expect(repo.statusCalls, 1);
    await cubit.close();
  });

  test('Tamara cancel still accepts authoritative completion', () async {
    final repo = _PaymentRepo()
      ..statusResponse = _status(PaymentStatus.completed);
    final cubit = _cubit(repo, store);
    await cubit.checkout(_request);
    await _markBrowserOpened(cubit);

    await cubit.verifyCheckoutClosedOnce();

    expect(
      cubit.state,
      isA<TamaraPaymentResult>().having(
        (state) => state.status,
        'status',
        PaymentStatus.completed,
      ),
    );
    await cubit.close();
  });

  test('Paymob close checks status once without polling', () async {
    final repo = _PaymentRepo();
    final cubit = _cubit(
      repo,
      store,
      pollInterval: const Duration(milliseconds: 2),
    );
    await cubit.checkout(_requestWith(provider: GulfPaymentProvider.paymob));
    await _markBrowserOpened(cubit);

    await cubit.verifyCheckoutClosedOnce();
    await cubit.onForeground();
    await Future<void>.delayed(const Duration(milliseconds: 12));

    expect(repo.reconcileCalls, 0);
    expect(repo.statusCalls, 1);
    expect(cubit.state, isA<TamaraPaymentPending>());
    expect(cubit.isAwaitingVerification, isFalse);
    await cubit.close();
  });

  test('old poller cannot reschedule after checkout close', () async {
    final repo = _PaymentRepo();
    final cubit = _cubit(
      repo,
      store,
      pollInterval: const Duration(milliseconds: 2),
    );
    await cubit.checkout(_requestWith(provider: GulfPaymentProvider.paymob));
    await _markBrowserOpened(cubit);
    await cubit.onForeground();
    await Future<void>.delayed(const Duration(milliseconds: 5));

    await cubit.verifyCheckoutClosedOnce();
    final callsAfterClose = repo.statusCalls;
    await Future<void>.delayed(const Duration(milliseconds: 12));

    expect(repo.statusCalls, callsAfterClose);
    expect(cubit.isAwaitingVerification, isFalse);
    await cubit.close();
  });

  test('explicitly closed Paymob draft does not poll after restart', () async {
    final firstRepo = _PaymentRepo();
    final first = _cubit(firstRepo, store);
    await first.checkout(_requestWith(provider: GulfPaymentProvider.paymob));
    await _markBrowserOpened(first);
    await first.verifyCheckoutClosedOnce();
    expect(firstRepo.statusCalls, 1);
    expect(store.read()?.checkoutExplicitlyClosed, isTrue);
    await first.close();

    final restoredRepo = _PaymentRepo();
    final restored = _cubit(
      restoredRepo,
      store,
      pollInterval: const Duration(milliseconds: 2),
    );
    await restored.restore();
    await restored.onForeground();
    await Future<void>.delayed(const Duration(milliseconds: 12));

    expect(restoredRepo.statusCalls, 0);
    expect(restored.isAwaitingVerification, isFalse);
    await restored.close();
  });

  test('Tamara return timeout leaves a retryable stable state', () async {
    final repo = _PaymentRepo()..statusCompleter = Completer();
    final cubit = _cubit(
      repo,
      store,
      checkoutReturnTimeout: const Duration(milliseconds: 1),
    );
    await cubit.checkout(_request);
    await _markBrowserOpened(cubit);

    await cubit.verifyCheckoutClosedOnce();

    expect(cubit.state, isA<TamaraPaymentPending>());
    expect(cubit.isAwaitingVerification, isFalse);
    await cubit.close();
  });

  test('restart pending reconciles once without polling or login', () async {
    await store.save(
      PaymentDraft(
        paymentId: 'payment-1',
        checkoutUrl: _checkoutUrl,
        checkoutOpenedAt: DateTime(2026),
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
    final repo = _PaymentRepo();
    final auth = _AuthRepo();
    final cubit = _cubit(repo, store, auth: auth);
    await cubit.restore();
    await cubit.onForeground();
    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(repo.reconcileCalls, 1);
    expect(repo.statusCalls, 1);
    expect(auth.loginCalls, 0);
    expect(cubit.state, isA<TamaraPaymentVerificationPending>());
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
  Duration checkoutReturnTimeout = const Duration(seconds: 1),
}) {
  return TamaraPaymentCubit(
    repo: repo,
    authRepo: auth ?? _AuthRepo(),
    store: store,
    keyGenerator: _Keys(),
    pollInterval: pollInterval,
    maxPollAttempts: maxPollAttempts,
    checkoutReturnTimeout: checkoutReturnTimeout,
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
  TamaraCheckoutResponse checkoutResponse = _checkoutResponse;

  @override
  Future<Either<Failure, TamaraCheckoutResponse>> checkout({
    required TamaraCheckoutRequest request,
    required String idempotencyKey,
  }) async {
    keys.add(idempotencyKey);
    if (checkoutCompleter != null) return checkoutCompleter!.future;
    if (checkoutFailure != null) return Left(checkoutFailure!);
    return Right(checkoutResponse);
  }

  @override
  Future<Either<Failure, TamaraStatusResponse>> reconcile(
    String paymentId,
  ) async {
    reconcileCalls++;
    return Right(_status(PaymentStatus.pending));
  }

  @override
  Future<Either<Failure, TamaraStatusResponse>> status(
    String paymentId, {
    GulfPaymentProvider provider = GulfPaymentProvider.tamara,
  }) async {
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
  GulfPaymentProvider? provider,
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
    provider: provider ?? _request.provider,
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
