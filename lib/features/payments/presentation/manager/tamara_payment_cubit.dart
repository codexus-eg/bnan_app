import 'dart:async';

import 'package:bnan_app/features/payments/data/checkout_payload_fingerprint.dart';
import 'package:bnan_app/features/payments/data/gulf_payment_polling_policy.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
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
    this.pollInterval,
    this.maxPollAttempts,
    this.checkoutReturnTimeout = const Duration(seconds: 10),
  }) : keyGenerator = keyGenerator ?? IdempotencyKeyGenerator(),
       super(const TamaraPaymentInitial()) {
    SessionManager.instance.addSessionChangeListener(_onSessionChanged);
  }

  final TamaraPaymentRepo repo;
  final AuthRepo authRepo;
  final PaymentDraftStore store;
  final IdempotencyKeyGenerator keyGenerator;
  final Duration? pollInterval;
  final int? maxPollAttempts;
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
  DateTime? _pollStartedAt;
  int _attemptGeneration = 0;
  int _pollGeneration = 0;
  bool _checkoutExplicitlyClosed = false;

  PaymentDraft? get draft => _draft;
  PaymentAmountSummary? get paymentSummary => _paymentSummary;
  bool get canOpenAccountVerification => _accountVerificationAttemptActive;
  bool get isAwaitingVerification =>
      _draft?.paymentId.isNotEmpty == true &&
      _draft?.checkoutOpenedAt != null &&
      _draft?.lastKnownStatus.isProcessing == true;

  void invalidateAmountSummary() {
    if (_paymentSummary == null) return;
    _paymentSummary = null;
    if (!isClosed) emit(const TamaraPaymentInitial());
  }

  Future<void> restore() async {
    _accountVerificationAttemptActive = false;
    _draft = await _readOwnedDraft();
    final draft = _draft;
    _checkoutExplicitlyClosed = draft?.checkoutExplicitlyClosed == true;
    if (draft?.lastKnownStatus == PaymentStatus.completed) {
      _draft = null;
      await store.clear();
      return;
    }
    if (draft?.lastKnownStatus.isProcessing == true &&
        draft?.paymentId.isNotEmpty == true) {
      GulfRegistrationDiagnostics.flow('pending restore started');
      if (draft?.checkoutExplicitlyClosed == true) {
        emit(
          TamaraPaymentPending(
            checkoutUrl: draft?.checkoutUrl,
            shouldOpenCheckout: false,
          ),
        );
        return;
      }
      emit(const TamaraPaymentVerificationPending());
      _reconciledThisForeground = false;
      await _reconcileAndCheckStatus(reason: 'pending restore');
    }
  }

  Future<void> checkout(TamaraCheckoutRequest request) async {
    if (_checkoutInFlight) return;
    _checkoutInFlight = true;
    _checkoutExplicitlyClosed = false;
    _checkoutLaunchClaimed = false;
    final fingerprint = checkoutPayloadFingerprint(request);
    var existing = _draft ?? await _readOwnedDraft();
    if (existing != null && !_belongsToCurrentUser(existing)) {
      await _resetAttempt();
      existing = null;
    }
    if (existing?.lastKnownStatus == PaymentStatus.completed) {
      _accountVerificationAttemptActive = true;
      emit(const TamaraPaymentResult(status: PaymentStatus.completed));
      _checkoutInFlight = false;
      return;
    }
    if (existing?.lastKnownStatus == PaymentStatus.refunded) {
      emit(const TamaraPaymentResult(status: PaymentStatus.refunded));
      _checkoutInFlight = false;
      return;
    }
    if (existing != null && existing.payloadFingerprint != fingerprint) {
      await _resetAttempt();
      existing = null;
    }
    _accountVerificationAttemptActive = true;
    if (existing != null &&
        existing.lastKnownStatus.isProcessing &&
        existing.paymentId.isNotEmpty) {
      emit(
        TamaraPaymentPending(
          checkoutUrl: existing.checkoutUrl,
          shouldOpenCheckout: existing.checkoutUrl != null,
        ),
      );
      _checkoutInFlight = false;
      return;
    }

    final canRetrySameAttempt =
        existing?.paymentId.isEmpty == true &&
        existing?.idempotencyKey.isNotEmpty == true &&
        existing?.payloadFingerprint == fingerprint;
    final key = canRetrySameAttempt
        ? existing!.idempotencyKey
        : keyGenerator.create();
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
          endpoint: EndPoints.paymentCheckout,
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
          provider: request.provider,
          purpose: PaymentDraftPurpose.registration,
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
    GulfRegistrationDiagnostics.flow('resume detected');
    if (_browserReturnPending) {
      _browserReturnPending = false;
      await verifyCheckoutClosedOnce();
      return;
    }
    final draft = _draft ?? await _readOwnedDraft();
    _draft = draft;
    _checkoutExplicitlyClosed = draft?.checkoutExplicitlyClosed == true;
    if (draft?.lastKnownStatus == PaymentStatus.completed) {
      emit(const TamaraPaymentResult(status: PaymentStatus.completed));
      return;
    }
    if (draft == null ||
        draft.paymentId.isEmpty ||
        !draft.lastKnownStatus.isProcessing ||
        draft.checkoutExplicitlyClosed) {
      return;
    }
    await _reconcileAndCheckStatus(reason: 'lifecycle resume');
  }

  Future<void> handleReturn(Uri uri) async {
    final paymentReturn = TamaraReturn.tryParse(uri);
    if (paymentReturn == null) return;
    final draft = _draft ?? await _readOwnedDraft();
    _draft = draft;
    if (draft == null ||
        draft.paymentId.isEmpty ||
        !draft.lastKnownStatus.isProcessing) {
      return;
    }
    final key = '${draft.paymentId}:${paymentReturn.outcome.name}';
    if (!_handledReturns.add(key)) return;
    if (paymentReturn.outcome != TamaraReturnOutcome.success) {
      await verifyCheckoutClosedOnce();
      return;
    }
    _checkoutLaunchClaimed = true;
    await _reconcileAndCheckStatus(reason: 'payment return success');
  }

  Future<void> verifyProviderSuccess() async {
    _reconciledThisForeground = false;
    await _reconcileAndCheckStatus(reason: 'provider success');
  }

  Future<void> verifyCheckoutClosed() async {
    if (_draft?.lastKnownStatus.isProcessing != true) return;
    _stopPolling(reason: 'checkout success verification');
    _checkoutLaunchClaimed = true;
    _reconciledThisForeground = false;
    if (!isClosed) emit(const TamaraPaymentVerificationPending());
    await _reconcileAndCheckStatus(reason: 'checkout success verification');
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
        !draft.lastKnownStatus.isProcessing ||
        _reconcileInFlight) {
      return;
    }
    final paymentId = draft.paymentId;
    final generation = _attemptGeneration;
    GulfRegistrationDiagnostics.flow('checkout closed');
    _checkoutExplicitlyClosed = true;
    _stopPolling(reason: 'explicit checkout close');
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
        draft.provider,
      ).timeout(checkoutReturnTimeout);
      if (isClosed ||
          generation != _attemptGeneration ||
          _draft?.paymentId != paymentId ||
          response == null) {
        return;
      }
      await _handleStatus(response, allowBlockingVerification: false);
    } on TimeoutException {
      // A closed checkout remains retryable when verification times out.
    } catch (_) {
      // Returning from Tamara must never leave the registration blocked.
    } finally {
      _reconcileInFlight = false;
      if (!isClosed &&
          generation == _attemptGeneration &&
          _draft?.paymentId == paymentId &&
          _draft?.lastKnownStatus.isProcessing == true) {
        emit(
          TamaraPaymentPending(
            checkoutUrl: _draft?.checkoutUrl,
            shouldOpenCheckout: false,
          ),
        );
      }
    }
  }

  Future<TamaraStatusResponse?> _closedCheckoutStatus(
    String paymentId,
    GulfPaymentProvider provider,
  ) async {
    TamaraStatusResponse? response;
    if (_statusInFlight) return null;
    if (provider.supportsReconcile) {
      (await repo.reconcile(
        paymentId,
      )).fold((_) {}, (value) => response = value);
    }
    if (response?.status.isTerminal != true) {
      (await repo.status(
        paymentId,
        provider: provider,
      )).fold((_) {}, (value) => response = value);
    }
    return response;
  }

  Future<void> _saveCheckoutClosed(PaymentDraft draft) async {
    _draft = PaymentDraft(
      paymentId: draft.paymentId,
      checkoutUrl: draft.checkoutUrl,
      checkoutOpenedAt: null,
      checkoutExplicitlyClosed: true,
      idempotencyKey: draft.idempotencyKey,
      packageId: draft.packageId,
      curriculumId: draft.curriculumId,
      gradeId: draft.gradeId,
      subjectIds: draft.subjectIds,
      studentEmail: draft.studentEmail,
      paymentStartedAt: draft.paymentStartedAt,
      lastKnownStatus: draft.lastKnownStatus,
      provider: draft.provider,
      purpose: draft.purpose,
      payloadFingerprint: draft.payloadFingerprint,
      ownerUserId: draft.ownerUserId,
    );
    await store.save(_draft!);
  }

  Future<void> _reconcileAndCheckStatus({required String reason}) async {
    final draft = _draft;
    if (draft == null ||
        draft.paymentId.isEmpty ||
        !draft.lastKnownStatus.isProcessing ||
        _reconciledThisForeground ||
        _reconcileInFlight) {
      return;
    }
    _reconciledThisForeground = true;
    _reconcileInFlight = true;
    final paymentId = draft.paymentId;
    final generation = _attemptGeneration;
    final reconciled = draft.provider.supportsReconcile
        ? await repo.reconcile(paymentId)
        : null;
    if (generation != _attemptGeneration || _draft?.paymentId != paymentId) {
      return;
    }
    _reconcileInFlight = false;
    if (isClosed) return;
    await reconciled?.fold((_) async {}, _handleStatus);
    if (_draft?.lastKnownStatus.isTerminal == true) return;
    await checkStatus();
    if (_draft?.lastKnownStatus.isProcessing == true &&
        !_checkoutExplicitlyClosed) {
      _startPolling(reason: reason);
    }
  }

  void onBackground() {
    _browserReturnPending =
        _draft?.lastKnownStatus.isProcessing == true &&
        _draft?.checkoutOpenedAt != null;
    _stopPolling(reason: 'lifecycle background');
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
    final result = await repo.status(paymentId, provider: draft.provider);
    _statusInFlight = false;
    if (isClosed ||
        generation != _attemptGeneration ||
        _draft?.paymentId != paymentId) {
      return false;
    }
    await result.fold((_) async {}, _handleStatus);
    return result.isRight();
  }

  Future<void> _handleStatus(
    TamaraStatusResponse response, {
    bool allowBlockingVerification = true,
  }) async {
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
      checkoutExplicitlyClosed: current.checkoutExplicitlyClosed,
      lastKnownStatus: effectiveStatus,
      provider: current.provider,
      purpose: current.purpose,
      payloadFingerprint: current.payloadFingerprint,
      ownerUserId: current.ownerUserId,
    );
    await store.save(_draft!);
    if (isClosed) return;

    if (effectiveStatus == PaymentStatus.completed) {
      _stopPolling(reason: 'payment completed');
      await _completeRegistration();
      return;
    }
    if (effectiveStatus.isTerminal) {
      _stopPolling(reason: 'terminal payment status');
      if (effectiveStatus != PaymentStatus.refunded) await store.clear();
      // TODO: Refunded subscription behavior must remain a backend rule.
      emit(TamaraPaymentResult(status: effectiveStatus));
      return;
    }
    emit(
      _checkoutLaunchClaimed ||
              _checkoutExplicitlyClosed ||
              !allowBlockingVerification
          ? TamaraPaymentPending(checkoutUrl: _draft!.checkoutUrl)
          : const TamaraPaymentVerificationPending(),
    );
  }

  Future<void> retryAfterTerminal(TamaraCheckoutRequest request) async {
    if (!{
      PaymentStatus.failed,
      PaymentStatus.cancelled,
      PaymentStatus.expired,
    }.contains(_draft?.lastKnownStatus)) {
      return;
    }
    _draft = null;
    await checkout(request);
  }

  void _startPolling({required String reason}) {
    if (_timer != null ||
        _checkoutExplicitlyClosed ||
        _draft?.lastKnownStatus.isProcessing != true) {
      return;
    }
    _pollAttempts = 0;
    _pollStartedAt = DateTime.now();
    final generation = ++_pollGeneration;
    GulfRegistrationDiagnostics.flow('polling started; source/reason=$reason');
    _scheduleNextPoll(generation);
  }

  void _scheduleNextPoll(int generation) {
    if (isClosed ||
        generation != _pollGeneration ||
        _checkoutExplicitlyClosed ||
        _draft?.lastKnownStatus.isProcessing != true) {
      return;
    }
    final attemptsExhausted =
        maxPollAttempts != null && _pollAttempts >= maxPollAttempts!;
    final elapsed = DateTime.now().difference(_pollStartedAt!);
    final delay =
        pollInterval ?? const GulfPaymentPollingPolicy().nextDelay(elapsed);
    if (attemptsExhausted || delay == null) {
      _checkoutLaunchClaimed = false;
      final draft = _draft;
      _stopPolling(reason: 'polling limit reached');
      if (draft != null) unawaited(_settlePendingCheckout(draft));
      return;
    }
    _timer = Timer(delay, () async {
      _timer = null;
      _pollAttempts++;
      await checkStatus();
      _scheduleNextPoll(generation);
    });
  }

  Future<void> _settlePendingCheckout(PaymentDraft draft) async {
    await _saveCheckoutClosed(draft);
    if (!isClosed && _draft?.lastKnownStatus.isProcessing == true) {
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
        !draft.lastKnownStatus.isProcessing ||
        draft.checkoutUrl?.trim() != url.trim()) {
      return false;
    }
    _checkoutLaunchClaimed = true;
    return true;
  }

  Future<void> completeCheckoutLaunch({required bool opened}) async {
    final draft = _draft;
    if (opened && draft != null) {
      _checkoutExplicitlyClosed = false;
      _draft = PaymentDraft(
        paymentId: draft.paymentId,
        checkoutUrl: draft.checkoutUrl,
        checkoutOpenedAt: DateTime.now(),
        checkoutExplicitlyClosed: false,
        idempotencyKey: draft.idempotencyKey,
        packageId: draft.packageId,
        curriculumId: draft.curriculumId,
        gradeId: draft.gradeId,
        subjectIds: draft.subjectIds,
        studentEmail: draft.studentEmail,
        paymentStartedAt: draft.paymentStartedAt,
        lastKnownStatus: draft.lastKnownStatus,
        provider: draft.provider,
        purpose: draft.purpose,
        payloadFingerprint: draft.payloadFingerprint,
        ownerUserId: draft.ownerUserId,
      );
      await store.save(_draft!);
    }
    if (!opened) _checkoutLaunchClaimed = false;
  }

  Future<void> abandonCheckout() async {
    _attemptGeneration++;
    _checkoutExplicitlyClosed = true;
    _stopPolling(reason: 'checkout abandoned');
    _statusInFlight = false;
    _checkoutInFlight = false;
    _reconcileInFlight = false;
    _reconciledThisForeground = false;
    _checkoutLaunchClaimed = false;
    if (!isClosed && _draft?.lastKnownStatus.isProcessing == true) {
      emit(
        TamaraPaymentPending(
          checkoutUrl: _draft?.checkoutUrl,
          shouldOpenCheckout: false,
        ),
      );
    }
  }

  void _stopPolling({required String reason}) {
    final wasActive = _timer != null || _pollStartedAt != null;
    _pollGeneration++;
    _timer?.cancel();
    _timer = null;
    _pollStartedAt = null;
    if (wasActive) {
      GulfRegistrationDiagnostics.flow(
        'polling stopped; source/reason=$reason',
      );
    }
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
      provider: current.provider,
      purpose: current.purpose,
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
      provider: request.provider,
      purpose: PaymentDraftPurpose.registration,
      payloadFingerprint: fingerprint,
      ownerUserId: SessionManager.instance.userId?.trim() ?? '',
    );
  }

  Future<void> discardStaleAttempt() async {
    final current = _draft ?? await _readOwnedDraft();
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
    if (saved?.purpose != PaymentDraftPurpose.registration) return null;
    if (saved == null || _belongsToCurrentUser(saved)) return saved;
    await store.clear();
    return null;
  }

  Future<void> _onSessionChanged(String? previous, String? next) =>
      _resetAttempt();

  Future<void> _resetAttempt() async {
    _attemptGeneration++;
    _checkoutExplicitlyClosed = false;
    _stopPolling(reason: 'payment attempt reset');
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
    _stopPolling(reason: 'cubit closed');
    SessionManager.instance.removeSessionChangeListener(_onSessionChanged);
    return super.close();
  }
}
