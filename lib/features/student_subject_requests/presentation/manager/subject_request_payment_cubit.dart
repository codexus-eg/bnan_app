import 'dart:async';

import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/payments/data/checkout_payload_fingerprint.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payloads.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payment.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payment_draft.dart';
import 'package:bnan_app/features/student_subject_requests/data/repo/student_subject_requests_repo.dart';
import 'package:bnan_app/features/student_subject_requests/data/store/subject_request_payment_store.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/subject_request_payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectRequestPaymentCubit extends Cubit<SubjectRequestPaymentState> {
  SubjectRequestPaymentCubit({
    required StudentSubjectRequestsRepo repo,
    required IdempotencyKeyGenerator keyGenerator,
    required SubjectRequestPaymentStore store,
    this.pollInterval = const Duration(seconds: 4),
    this.maxPollAttempts = 15,
    this.checkoutReturnTimeout = const Duration(seconds: 10),
  }) : _repo = repo,
       _keys = keyGenerator,
       _store = store,
       super(const SubjectRequestPaymentState());

  final StudentSubjectRequestsRepo _repo;
  final IdempotencyKeyGenerator _keys;
  final SubjectRequestPaymentStore _store;
  final Duration pollInterval;
  final int maxPollAttempts;
  final Duration checkoutReturnTimeout;
  String? _key;
  String? _fingerprint;
  bool _polling = false;
  Future<void>? _closedCheckFlight;

  Future<void> restore() async {
    final draft = _store.read();
    if (draft == null) return;
    if (draft.ownerUserId != _ownerUserId) {
      await _store.clear();
      return;
    }
    _key = draft.idempotencyKey;
    _fingerprint = draft.payloadFingerprint;
    if (draft.paymentId.isEmpty) return;
    emit(
      SubjectRequestPaymentState(
        phase: SubjectRequestPaymentPhase.verifying,
        payment: SubjectRequestPayment(
          paymentId: draft.paymentId,
          status: SubjectRequestPaymentStatus.pending,
          checkoutUrl: draft.checkoutUrl,
        ),
      ),
    );
    await verify(reconcileFirst: true);
  }

  Future<void> checkout(GulfSubjectRequestPayload payload) async {
    if (_isBusy) return;
    final fingerprint = checkoutMapFingerprint(payload.toJson());
    final currentPayment = state.payment;
    if (currentPayment?.status.isProcessing == true) {
      if (_fingerprint == fingerprint) {
        emit(
          SubjectRequestPaymentState(
            phase: SubjectRequestPaymentPhase.openingTamara,
            payment: currentPayment,
          ),
        );
      }
      return;
    }
    if (_key == null || _fingerprint != fingerprint) {
      _key = _keys.create();
      _fingerprint = fingerprint;
    }
    emit(
      const SubjectRequestPaymentState(
        phase: SubjectRequestPaymentPhase.creatingCheckout,
      ),
    );
    final pendingDraft = SubjectRequestPaymentDraft(
      paymentId: '',
      idempotencyKey: _key!,
      subjectId: payload.subjectId,
      packageId: payload.packageId,
      payloadFingerprint: fingerprint,
      ownerUserId: _ownerUserId,
    );
    await _store.save(pendingDraft);
    if (isClosed) return;
    final result = await _repo.checkout(
      payload: payload,
      idempotencyKey: _key!,
    );
    await result.fold(
      (failure) async {
        if (failure.responseReceived) {
          _resetAttempt();
          await _store.clear();
        }
        if (isClosed) return;
        emit(
          SubjectRequestPaymentState(
            phase: SubjectRequestPaymentPhase.failure,
            message: failure.message,
          ),
        );
      },
      (payment) async {
        await _store.save(
          SubjectRequestPaymentDraft(
            paymentId: payment.paymentId,
            idempotencyKey: _key!,
            subjectId: payload.subjectId,
            packageId: payload.packageId,
            payloadFingerprint: fingerprint,
            ownerUserId: _ownerUserId,
            checkoutUrl: payment.checkoutUrl,
          ),
        );
        if (isClosed) return;
        emit(
          SubjectRequestPaymentState(
            phase: SubjectRequestPaymentPhase.openingTamara,
            payment: payment,
          ),
        );
      },
    );
  }

  Future<void> tamaraReturned() {
    if (state.phase == SubjectRequestPaymentPhase.completed ||
        state.phase == SubjectRequestPaymentPhase.terminalFailure) {
      return Future.value();
    }
    return verify(reconcileFirst: true);
  }

  Future<void> checkoutClosed() {
    final current = _closedCheckFlight;
    if (current != null) return current;
    late final Future<void> flight;
    flight = _runClosedCheck().whenComplete(() {
      if (identical(_closedCheckFlight, flight)) _closedCheckFlight = null;
    });
    _closedCheckFlight = flight;
    return flight;
  }

  Future<void> _runClosedCheck() async {
    final paymentId = state.payment?.paymentId;
    if (paymentId == null || paymentId.isEmpty) return;
    _polling = false;
    emit(
      SubjectRequestPaymentState(
        phase: SubjectRequestPaymentPhase.failure,
        payment: state.payment,
      ),
    );
    try {
      await _check(paymentId, reconcile: true).timeout(checkoutReturnTimeout);
      if (state.phase == SubjectRequestPaymentPhase.failure) {
        await _check(paymentId).timeout(checkoutReturnTimeout);
      }
    } on TimeoutException {
      // The saved checkout remains available for another user attempt.
    } catch (_) {
      // A return failure must not leave the submit button loading.
    }
  }

  void checkoutLaunchFailed(String message) {
    if (state.phase != SubjectRequestPaymentPhase.openingTamara) return;
    emit(
      SubjectRequestPaymentState(
        phase: SubjectRequestPaymentPhase.failure,
        payment: state.payment,
        message: message,
      ),
    );
  }

  void completeHandling() {
    if (state.phase == SubjectRequestPaymentPhase.completed) {
      emit(const SubjectRequestPaymentState());
    }
  }

  Future<void> verify({bool reconcileFirst = false}) async {
    final paymentId = state.payment?.paymentId;
    if (paymentId == null || paymentId.isEmpty || _polling) return;
    _polling = true;
    emit(
      SubjectRequestPaymentState(
        phase: SubjectRequestPaymentPhase.verifying,
        payment: state.payment,
      ),
    );
    if (reconcileFirst) await _check(paymentId, reconcile: true);
    var attempts = 0;
    while (!isClosed &&
        _polling &&
        attempts < maxPollAttempts &&
        state.phase == SubjectRequestPaymentPhase.verifying) {
      if (attempts > 0) await Future<void>.delayed(pollInterval);
      if (isClosed || !_polling) break;
      await _check(paymentId);
      attempts++;
    }
    if (!isClosed && state.phase == SubjectRequestPaymentPhase.verifying) {
      _polling = false;
      emit(
        SubjectRequestPaymentState(
          phase: SubjectRequestPaymentPhase.verificationTimeout,
          payment: state.payment,
        ),
      );
    }
  }

  Future<void> _check(String paymentId, {bool reconcile = false}) async {
    final result = reconcile
        ? await _repo.reconcile(paymentId)
        : await _repo.status(paymentId);
    await result.fold<Future<void>>((failure) async {}, (payment) async {
      if (isClosed) return;
      if (payment.status == SubjectRequestPaymentStatus.completed) {
        _polling = false;
        await _store.clear();
        _resetAttempt();
        if (isClosed) return;
        emit(
          SubjectRequestPaymentState(
            phase: SubjectRequestPaymentPhase.completed,
            payment: payment,
          ),
        );
      } else if (payment.status.isTerminal) {
        _polling = false;
        await _store.clear();
        _resetAttempt();
        if (isClosed) return;
        emit(
          SubjectRequestPaymentState(
            phase: SubjectRequestPaymentPhase.terminalFailure,
            payment: payment,
          ),
        );
      }
    });
  }

  void _resetAttempt() {
    _key = null;
    _fingerprint = null;
  }

  bool get _isBusy =>
      state.phase == SubjectRequestPaymentPhase.creatingCheckout ||
      state.phase == SubjectRequestPaymentPhase.openingTamara ||
      state.phase == SubjectRequestPaymentPhase.verifying ||
      state.phase == SubjectRequestPaymentPhase.completed;

  String get _ownerUserId => SessionManager.instance.userId?.trim() ?? '';

  @override
  Future<void> close() {
    _polling = false;
    return super.close();
  }
}
