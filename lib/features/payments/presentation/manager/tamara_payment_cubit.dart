import 'dart:async';

import 'package:bnan_app/features/payments/data/checkout_payload_fingerprint.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/payments/data/models/payment_draft.dart';
import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:bnan_app/features/payments/data/models/tamara_return.dart';
import 'package:bnan_app/features/payments/data/payment_draft_store.dart';
import 'package:bnan_app/features/payments/data/repo/tamara_payment_repo.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_state.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_auth/data/debug/gulf_registration_diagnostics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TamaraPaymentCubit extends Cubit<TamaraPaymentState> {
  TamaraPaymentCubit({
    required this.repo,
    required this.authRepo,
    required this.store,
    IdempotencyKeyGenerator? keyGenerator,
    this.pollInterval = const Duration(seconds: 3),
    this.maxPollAttempts = 20,
    this.checkoutReturnTimeout = const Duration(seconds: 10),
  }) : keyGenerator = keyGenerator ?? IdempotencyKeyGenerator(),
       super(const TamaraPaymentInitial()) {
    SessionManager.instance.addSessionChangeListener(_onSessionChanged);
  }

  final TamaraPaymentRepo repo;
  final AuthRepo authRepo;
  final PaymentDraftStore store;
  final IdempotencyKeyGenerator keyGenerator;
  final Duration pollInterval;
  final int maxPollAttempts;
  final Duration checkoutReturnTimeout;

  Timer? _timer;
  PaymentDraft? _draft;
  bool _statusInFlight = false;
  bool _checkoutInFlight = false;
  bool _checkoutLaunchClaimed = false;
  bool _reconciledThisForeground = false;
  bool _reconcileInFlight = false;
  bool _accountVerificationAttemptActive = false;
  bool _browserReturnPending = false;
  Future<void>? _closedCheckFlight;
  final Set<String> _handledReturns = {};
  PaymentAmountSummary? _paymentSummary;
  int _pollAttempts = 0;
  int _attemptGeneration = 0;

  PaymentDraft? get draft => _draft;
  PaymentAmountSummary? get paymentSummary => _paymentSummary;
  bool get canOpenAccountVerification => _accountVerificationAttemptActive;
  bool get isAwaitingVerification =>
      _draft?.paymentId.isNotEmpty == true &&
      _draft?.checkoutOpenedAt != null &&
      _draft?.lastKnownStatus == PaymentStatus.pending;

  Future<void> restore() async {
    _accountVerificationAttemptActive = false;
    _draft = await _readOwnedDraft();
    final draft = _draft;
    if (draft?.lastKnownStatus == PaymentStatus.completed) {
      _draft = null;
      await store.clear();
      return;
    }
    if (draft?.lastKnownStatus == PaymentStatus.pending &&
        draft?.paymentId.isNotEmpty == true) {
      emit(const TamaraPaymentVerificationPending());
    }
  }

  Future<void> checkout(TamaraCheckoutRequest request) async {
    if (_checkoutInFlight) return;
    final fingerprint = checkoutPayloadFingerprint(request);
    var existing = _draft ?? store.read();
    if (existing != null && !_belongsToCurrentUser(existing)) {
      await _resetAttempt();
      existing = null;
    }
    if (existing?.lastKnownStatus == PaymentStatus.completed) {
      _accountVerificationAttemptActive = true;
      emit(const TamaraPaymentResult(status: PaymentStatus.completed));
      return;
    }
    if (existing?.lastKnownStatus == PaymentStatus.refunded) {
      emit(const TamaraPaymentResult(status: PaymentStatus.refunded));
      return;
    }
    if (existing != null && existing.payloadFingerprint != fingerprint) {
      await _resetAttempt();
      existing = null;
    }
    _accountVerificationAttemptActive = true;
    if (existing != null &&
        existing.lastKnownStatus == PaymentStatus.pending &&
        existing.paymentId.isNotEmpty) {
      emit(
        TamaraPaymentPending(
          checkoutUrl: existing.checkoutUrl,
          shouldOpenCheckout: existing.checkoutUrl != null,
        ),
      );
      return;
    }

    final canRetrySameAttempt =
        existing?.paymentId.isEmpty == true &&
        existing?.idempotencyKey.isNotEmpty == true &&
        existing?.payloadFingerprint == fingerprint;
    final key = canRetrySameAttempt
        ? existing!.idempotencyKey
        : keyGenerator.create();
    _checkoutInFlight = true;
    final generation = _attemptGeneration;
    _paymentSummary = null;
    emit(const TamaraPaymentLoading());
    _draft = _newDraft(request, key, fingerprint);
    final checkoutDraft = _draft!;
    await store.save(checkoutDraft);
    if (isClosed) {
      if (generation == _attemptGeneration) _checkoutInFlight = false;
      return;
    }

    final result = await repo.checkout(request: request, idempotencyKey: key);
    if (generation != _attemptGeneration || isClosed) return;
    _checkoutInFlight = false;
    await result.fold(
      (failure) async {
        GulfRegistrationDiagnostics.uiFailure(
          endpoint: EndPoints.tamaraCheckout,
          cubit: 'TamaraPaymentCubit',
          state: 'TamaraPaymentFailure',
          message: failure.message,
        );
        if (failure.responseReceived) {
          _draft = null;
          await store.clear();
        }
        if (!isClosed) emit(TamaraPaymentFailure(failure.message));
      },
      (response) async {
        _paymentSummary = response.paymentSummary;
        final status = PaymentStatus.fromValue(response.status);
        _draft = PaymentDraft(
          paymentId: response.paymentId,
          checkoutUrl: response.checkoutUrl,
          idempotencyKey: key,
          packageId: request.packageId,
          curriculumId: request.curriculumId,
          gradeId: request.student.grade,
          subjectIds: request.student.subjects,
          studentEmail: request.student.email,
          paymentStartedAt: checkoutDraft.paymentStartedAt,
          checkoutOpenedAt: null,
          lastKnownStatus: status == PaymentStatus.unknown
              ? PaymentStatus.pending
              : status,
          payloadFingerprint: fingerprint,
          ownerUserId: checkoutDraft.ownerUserId,
        );
        await store.save(_draft!);
        if (isClosed) return;
        emit(
          TamaraPaymentPending(
            checkoutUrl: response.checkoutUrl,
            shouldOpenCheckout: true,
          ),
        );
      },
    );
  }

  Future<void> onForeground() async {
    if (_browserReturnPending) {
      _browserReturnPending = false;
      await verifyCheckoutClosedOnce();
      return;
    }
    final draft = _draft ?? await _readOwnedDraft();
    _draft = draft;
    if (draft?.lastKnownStatus == PaymentStatus.completed) {
      emit(const TamaraPaymentResult(status: PaymentStatus.completed));
      return;
    }
    if (draft == null ||
        draft.paymentId.isEmpty ||
        draft.lastKnownStatus != PaymentStatus.pending ||
        draft.checkoutOpenedAt == null) {
      return;
    }
    await _reconcileAndCheckStatus();
  }

  Future<void> handleReturn(Uri uri) async {
    final paymentReturn = TamaraReturn.tryParse(uri);
    if (paymentReturn == null) return;
    final draft = _draft ?? await _readOwnedDraft();
    _draft = draft;
    if (draft == null ||
        draft.paymentId.isEmpty ||
        draft.lastKnownStatus != PaymentStatus.pending) {
      return;
    }
    final key = '${draft.paymentId}:${paymentReturn.outcome.name}';
    if (!_handledReturns.add(key)) return;
    if (paymentReturn.outcome != TamaraReturnOutcome.success) {
      await verifyCheckoutClosedOnce();
      return;
    }
    _checkoutLaunchClaimed = true;
    await _reconcileAndCheckStatus();
  }

  Future<void> verifyProviderSuccess() async {
    _reconciledThisForeground = false;
    await _reconcileAndCheckStatus();
  }

  Future<void> verifyCheckoutClosed() async {
    if (_draft?.lastKnownStatus != PaymentStatus.pending) return;
    _stopPolling();
    _checkoutLaunchClaimed = true;
    _reconciledThisForeground = false;
    if (!isClosed) emit(const TamaraPaymentVerificationPending());
    await _reconcileAndCheckStatus();
  }

  Future<void> verifyCheckoutClosedOnce() {
    final current = _closedCheckFlight;
    if (current != null) return current;
    late final Future<void> flight;
    flight = _runClosedCheckoutCheck().whenComplete(() {
      if (identical(_closedCheckFlight, flight)) _closedCheckFlight = null;
    });
    _closedCheckFlight = flight;
    return flight;
  }

  Future<void> _runClosedCheckoutCheck() async {
    final draft = _draft ?? await _readOwnedDraft();
    _draft = draft;
    if (draft == null ||
        draft.paymentId.isEmpty ||
        draft.lastKnownStatus != PaymentStatus.pending ||
        _reconcileInFlight) {
      return;
    }
    final paymentId = draft.paymentId;
    final generation = _attemptGeneration;
    _stopPolling();
    _checkoutLaunchClaimed = false;
    _reconciledThisForeground = true;
    _reconcileInFlight = true;
    await _saveCheckoutClosed(draft);
    if (!isClosed) {
      emit(
        TamaraPaymentPending(
          checkoutUrl: _draft?.checkoutUrl,
          shouldOpenCheckout: false,
        ),
      );
    }
    try {
      final response = await _closedCheckoutStatus(
        paymentId,
      ).timeout(checkoutReturnTimeout);
      if (isClosed ||
          generation != _attemptGeneration ||
          _draft?.paymentId != paymentId ||
          response == null) {
        return;
      }
      await _handleStatus(response);
    } on TimeoutException {
      // A closed checkout remains retryable when verification times out.
    } catch (_) {
      // Returning from Tamara must never leave the registration blocked.
    } finally {
      _reconcileInFlight = false;
      if (!isClosed &&
          generation == _attemptGeneration &&
          _draft?.paymentId == paymentId &&
          _draft?.lastKnownStatus == PaymentStatus.pending) {
        emit(
          TamaraPaymentPending(
            checkoutUrl: _draft?.checkoutUrl,
            shouldOpenCheckout: false,
          ),
        );
      }
    }
  }

  Future<TamaraStatusResponse?> _closedCheckoutStatus(String paymentId) async {
    TamaraStatusResponse? response;
    (await repo.reconcile(paymentId)).fold((_) {}, (value) => response = value);
    if (response?.status.isTerminal != true) {
      (await repo.status(paymentId)).fold((_) {}, (value) => response = value);
    }
    return response;
  }

  Future<void> _saveCheckoutClosed(PaymentDraft draft) async {
    _draft = PaymentDraft(
      paymentId: draft.paymentId,
      checkoutUrl: draft.checkoutUrl,
      checkoutOpenedAt: null,
      idempotencyKey: draft.idempotencyKey,
      packageId: draft.packageId,
      curriculumId: draft.curriculumId,
      gradeId: draft.gradeId,
      subjectIds: draft.subjectIds,
      studentEmail: draft.studentEmail,
      paymentStartedAt: draft.paymentStartedAt,
      lastKnownStatus: draft.lastKnownStatus,
      payloadFingerprint: draft.payloadFingerprint,
      ownerUserId: draft.ownerUserId,
    );
    await store.save(_draft!);
  }

  Future<void> _reconcileAndCheckStatus() async {
    final draft = _draft;
    if (draft == null ||
        draft.paymentId.isEmpty ||
        draft.lastKnownStatus != PaymentStatus.pending ||
        _reconciledThisForeground ||
        _reconcileInFlight) {
      return;
    }
    _reconciledThisForeground = true;
    _reconcileInFlight = true;
    final paymentId = draft.paymentId;
    final generation = _attemptGeneration;
    final reconciled = await repo.reconcile(paymentId);
    if (generation != _attemptGeneration || _draft?.paymentId != paymentId) {
      return;
    }
    _reconcileInFlight = false;
    if (isClosed) return;
    await reconciled.fold((_) async {}, _handleStatus);
    if (_draft?.lastKnownStatus.isTerminal == true) return;
    await checkStatus();
    if (_checkoutLaunchClaimed &&
        _draft?.lastKnownStatus == PaymentStatus.pending) {
      _startPolling();
    }
  }

  void onBackground() {
    _browserReturnPending =
        _draft?.lastKnownStatus == PaymentStatus.pending &&
        _draft?.checkoutOpenedAt != null;
    _timer?.cancel();
    _timer = null;
    _checkoutLaunchClaimed = false;
    _reconciledThisForeground = false;
  }

  Future<void> resumeAfterParentAuth() async {
    _reconciledThisForeground = false;
    await onForeground();
  }

  Future<bool> checkStatus() async {
    final draft = _draft;
    if (draft == null || draft.paymentId.isEmpty || _statusInFlight) {
      return false;
    }
    final paymentId = draft.paymentId;
    final generation = _attemptGeneration;
    _statusInFlight = true;
    final result = await repo.status(paymentId);
    _statusInFlight = false;
    if (isClosed ||
        generation != _attemptGeneration ||
        _draft?.paymentId != paymentId) {
      return false;
    }
    await result.fold(
      (failure) async => emit(TamaraPaymentFailure(failure.message)),
      _handleStatus,
    );
    return result.isRight();
  }

  Future<void> _handleStatus(TamaraStatusResponse response) async {
    final current = _draft;
    if (current == null) return;
    final effectiveStatus = response.status == PaymentStatus.unknown
        ? PaymentStatus.pending
        : response.status;
    _paymentSummary = response.paymentSummary ?? _paymentSummary;
    _draft = PaymentDraft(
      paymentId: current.paymentId,
      checkoutUrl: response.checkoutUrl ?? current.checkoutUrl,
      idempotencyKey: current.idempotencyKey,
      packageId: current.packageId,
      curriculumId: current.curriculumId,
      gradeId: current.gradeId,
      subjectIds: current.subjectIds,
      studentEmail: current.studentEmail,
      paymentStartedAt: current.paymentStartedAt,
      checkoutOpenedAt: current.checkoutOpenedAt,
      lastKnownStatus: effectiveStatus,
      payloadFingerprint: current.payloadFingerprint,
      ownerUserId: current.ownerUserId,
    );
    await store.save(_draft!);
    if (isClosed) return;

    if (effectiveStatus == PaymentStatus.completed) {
      _stopPolling();
      await _completeRegistration();
      return;
    }
    if (effectiveStatus.isTerminal) {
      _stopPolling();
      if (effectiveStatus != PaymentStatus.refunded) await store.clear();
      // TODO: Refunded subscription behavior must remain a backend rule.
      emit(TamaraPaymentResult(status: effectiveStatus));
      return;
    }
    emit(
      _checkoutLaunchClaimed
          ? TamaraPaymentPending(checkoutUrl: _draft!.checkoutUrl)
          : const TamaraPaymentVerificationPending(),
    );
  }

  Future<void> retryAfterTerminal(TamaraCheckoutRequest request) async {
    if (_draft?.lastKnownStatus.isTerminal != true) return;
    _draft = null;
    await checkout(request);
  }

  void _startPolling() {
    if (_timer != null || _draft?.lastKnownStatus != PaymentStatus.pending) {
      return;
    }
    _pollAttempts = 0;
    _timer = Timer.periodic(pollInterval, (_) {
      if (_pollAttempts >= maxPollAttempts) {
        _stopPolling();
        _checkoutLaunchClaimed = false;
        final draft = _draft;
        if (draft != null && !isClosed) {
          unawaited(_settlePendingCheckout(draft));
        }
        return;
      }
      _pollAttempts++;
      checkStatus();
    });
  }

  Future<void> _settlePendingCheckout(PaymentDraft draft) async {
    await _saveCheckoutClosed(draft);
    if (!isClosed && _draft?.lastKnownStatus == PaymentStatus.pending) {
      emit(
        TamaraPaymentPending(
          checkoutUrl: _draft?.checkoutUrl,
          shouldOpenCheckout: false,
        ),
      );
    }
  }

  bool claimCheckoutLaunch(String url) {
    final draft = _draft;
    if (_checkoutLaunchClaimed ||
        draft == null ||
        draft.lastKnownStatus != PaymentStatus.pending ||
        draft.checkoutUrl?.trim() != url.trim()) {
      return false;
    }
    _checkoutLaunchClaimed = true;
    return true;
  }

  Future<void> completeCheckoutLaunch({required bool opened}) async {
    final draft = _draft;
    if (opened && draft != null) {
      _draft = PaymentDraft(
        paymentId: draft.paymentId,
        checkoutUrl: draft.checkoutUrl,
        checkoutOpenedAt: DateTime.now(),
        idempotencyKey: draft.idempotencyKey,
        packageId: draft.packageId,
        curriculumId: draft.curriculumId,
        gradeId: draft.gradeId,
        subjectIds: draft.subjectIds,
        studentEmail: draft.studentEmail,
        paymentStartedAt: draft.paymentStartedAt,
        lastKnownStatus: draft.lastKnownStatus,
        payloadFingerprint: draft.payloadFingerprint,
        ownerUserId: draft.ownerUserId,
      );
      await store.save(_draft!);
    }
    if (!opened) _checkoutLaunchClaimed = false;
  }

  Future<void> abandonCheckout() async {
    _attemptGeneration++;
    _stopPolling();
    _statusInFlight = false;
    _checkoutInFlight = false;
    _reconcileInFlight = false;
    _reconciledThisForeground = false;
    _checkoutLaunchClaimed = false;
    if (!isClosed && _draft?.lastKnownStatus == PaymentStatus.pending) {
      emit(
        TamaraPaymentPending(
          checkoutUrl: _draft?.checkoutUrl,
          shouldOpenCheckout: false,
        ),
      );
    }
  }

  void _stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _completeRegistration() async {
    await _retainCompletedEmail();
    if (isClosed) return;
    emit(const TamaraPaymentResult(status: PaymentStatus.completed));
  }

  Future<void> _retainCompletedEmail() async {
    final current = _draft;
    if (current == null) return;
    _draft = PaymentDraft(
      paymentId: current.paymentId,
      idempotencyKey: '',
      packageId: '',
      curriculumId: '',
      gradeId: '',
      subjectIds: const [],
      studentEmail: current.studentEmail,
      paymentStartedAt: current.paymentStartedAt,
      lastKnownStatus: PaymentStatus.completed,
      payloadFingerprint: '',
      ownerUserId: current.ownerUserId,
    );
    await store.clear();
  }

  PaymentDraft _newDraft(
    TamaraCheckoutRequest request,
    String key,
    String fingerprint,
  ) {
    return PaymentDraft(
      paymentId: '',
      idempotencyKey: key,
      packageId: request.packageId,
      curriculumId: request.curriculumId,
      gradeId: request.student.grade,
      subjectIds: request.student.subjects,
      studentEmail: request.student.email,
      paymentStartedAt: DateTime.now(),
      lastKnownStatus: PaymentStatus.pending,
      payloadFingerprint: fingerprint,
      ownerUserId: SessionManager.instance.userId?.trim() ?? '',
    );
  }

  Future<void> discardStaleAttempt() async {
    final current = _draft ?? store.read();
    if (current == null ||
        current.lastKnownStatus == PaymentStatus.completed ||
        current.lastKnownStatus == PaymentStatus.refunded) {
      return;
    }
    await _resetAttempt();
  }

  bool _belongsToCurrentUser(PaymentDraft draft) =>
      draft.ownerUserId == (SessionManager.instance.userId?.trim() ?? '');

  Future<PaymentDraft?> _readOwnedDraft() async {
    final saved = store.read();
    if (saved == null || _belongsToCurrentUser(saved)) return saved;
    await store.clear();
    return null;
  }

  Future<void> _onSessionChanged(String? previous, String? next) =>
      _resetAttempt();

  Future<void> _resetAttempt() async {
    _attemptGeneration++;
    _stopPolling();
    _draft = null;
    _paymentSummary = null;
    _statusInFlight = false;
    _checkoutInFlight = false;
    _checkoutLaunchClaimed = false;
    _reconciledThisForeground = false;
    _reconcileInFlight = false;
    _accountVerificationAttemptActive = false;
    _browserReturnPending = false;
    _closedCheckFlight = null;
    _handledReturns.clear();
    await store.clear();
    if (!isClosed) emit(const TamaraPaymentInitial());
  }

  @override
  Future<void> close() {
    _stopPolling();
    SessionManager.instance.removeSessionChangeListener(_onSessionChanged);
    return super.close();
  }
}
