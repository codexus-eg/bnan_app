import 'dart:async';

import 'package:bnan_app/features/payments/data/checkout_payload_fingerprint.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/payments/data/models/payment_draft.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:bnan_app/features/payments/data/payment_draft_store.dart';
import 'package:bnan_app/features/payments/data/repo/tamara_payment_repo.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_state.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TamaraPaymentCubit extends Cubit<TamaraPaymentState> {
  TamaraPaymentCubit({
    required this.repo,
    required this.authRepo,
    required this.store,
    IdempotencyKeyGenerator? keyGenerator,
    this.pollInterval = const Duration(seconds: 3),
    this.maxPollAttempts = 20,
  }) : keyGenerator = keyGenerator ?? IdempotencyKeyGenerator(),
       super(const TamaraPaymentInitial());

  final TamaraPaymentRepo repo;
  final AuthRepo authRepo;
  final PaymentDraftStore store;
  final IdempotencyKeyGenerator keyGenerator;
  final Duration pollInterval;
  final int maxPollAttempts;

  Timer? _timer;
  TamaraCheckoutRequest? _request;
  PaymentDraft? _draft;
  bool _statusInFlight = false;
  bool _checkoutInFlight = false;
  bool _checkoutLaunchClaimed = false;
  bool _reconciledThisForeground = false;
  int _pollAttempts = 0;

  PaymentDraft? get draft => _draft;

  Future<void> restore() async {
    _draft = store.read();
    final draft = _draft;
    if (draft?.lastKnownStatus == PaymentStatus.pending &&
        draft?.paymentId.isNotEmpty == true) {
      emit(TamaraPaymentPending(checkoutUrl: draft?.checkoutUrl));
    }
  }

  Future<void> checkout(TamaraCheckoutRequest request) async {
    if (_checkoutInFlight) return;
    _request = request;
    final existing = _draft;
    if (existing?.lastKnownStatus == PaymentStatus.completed) {
      emit(const TamaraPaymentResult(status: PaymentStatus.completed));
      return;
    }
    if (existing?.lastKnownStatus == PaymentStatus.refunded) {
      emit(const TamaraPaymentResult(status: PaymentStatus.refunded));
      return;
    }
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

    final fingerprint = checkoutPayloadFingerprint(request);
    final canRetrySameAttempt =
        existing?.paymentId.isEmpty == true &&
        existing?.idempotencyKey.isNotEmpty == true &&
        existing?.payloadFingerprint == fingerprint;
    final key = canRetrySameAttempt
        ? existing!.idempotencyKey
        : keyGenerator.create();
    _checkoutInFlight = true;
    emit(const TamaraPaymentLoading());
    _draft = _newDraft(request, key, fingerprint);
    await store.save(_draft!);
    if (isClosed) {
      _checkoutInFlight = false;
      return;
    }

    final result = await repo.checkout(request: request, idempotencyKey: key);
    _checkoutInFlight = false;
    if (isClosed) return;
    await result.fold(
      (failure) async {
        if (failure.responseReceived) {
          _draft = null;
          await store.clear();
        }
        if (!isClosed) emit(TamaraPaymentFailure(failure.message));
      },
      (response) async {
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
          paymentStartedAt: _draft!.paymentStartedAt,
          checkoutOpenedAt: null,
          lastKnownStatus: status == PaymentStatus.unknown
              ? PaymentStatus.pending
              : status,
          payloadFingerprint: fingerprint,
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
    final draft = _draft ?? store.read();
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
    var canPoll = false;
    if (!_reconciledThisForeground) {
      _reconciledThisForeground = true;
      final result = await repo.reconcile(draft.paymentId);
      if (isClosed) return;
      await result.fold((_) async => canPoll = await checkStatus(), (
        response,
      ) async {
        await _handleStatus(response);
        canPoll = true;
      });
    }
    if (canPoll && _draft?.lastKnownStatus == PaymentStatus.pending) {
      _startPolling();
    }
  }

  void onBackground() {
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
    _statusInFlight = true;
    final result = await repo.status(draft.paymentId);
    _statusInFlight = false;
    if (isClosed) return false;
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
    _draft = PaymentDraft(
      paymentId: response.paymentId.isEmpty
          ? current.paymentId
          : response.paymentId,
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
    );
    await store.save(_draft!);
    if (isClosed) return;

    if (effectiveStatus == PaymentStatus.completed) {
      _stopPolling();
      await _loginStudent();
      return;
    }
    if (effectiveStatus.isTerminal) {
      _stopPolling();
      // TODO: Refunded subscription behavior must remain a backend rule.
      emit(TamaraPaymentResult(status: effectiveStatus));
      return;
    }
    emit(TamaraPaymentPending(checkoutUrl: _draft!.checkoutUrl));
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
        return;
      }
      _pollAttempts++;
      checkStatus();
    });
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
      );
      await store.save(_draft!);
    }
    if (!opened) _checkoutLaunchClaimed = false;
  }

  void _stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _loginStudent() async {
    final request = _request;
    if (request == null) {
      await _retainCompletedEmail();
      if (isClosed) return;
      emit(const TamaraPaymentResult(status: PaymentStatus.completed));
      return;
    }
    final result = await authRepo.loginStudentAfterPayment(
      email: request.student.email,
      password: request.student.password,
    );
    if (isClosed) return;
    await result.fold(
      (_) async {
        _request = null;
        await _retainCompletedEmail();
        if (isClosed) return;
        emit(const TamaraPaymentResult(status: PaymentStatus.completed));
      },
      (response) async {
        _request = null;
        await store.clear();
        if (isClosed) return;
        emit(
          const TamaraPaymentResult(
            status: PaymentStatus.completed,
            studentLoggedIn: true,
          ),
        );
      },
    );
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
    );
    await store.save(_draft!);
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
    );
  }

  Future<void> discardStaleAttempt() async {
    final current = _draft ?? store.read();
    if (current == null ||
        current.lastKnownStatus == PaymentStatus.completed ||
        current.lastKnownStatus == PaymentStatus.refunded ||
        (current.lastKnownStatus == PaymentStatus.pending &&
            current.paymentId.isNotEmpty)) {
      return;
    }
    _draft = null;
    await store.clear();
  }

  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }
}
