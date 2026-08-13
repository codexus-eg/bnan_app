import 'dart:async';
import 'dart:io';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';
import 'package:bnan_app/features/parent_children/data/parent_payment_poller.dart';
import 'package:bnan_app/features/parent_children/data/parent_payment_attempt.dart';
import 'package:bnan_app/features/parent_children/presentation/policies/parent_package_policy.dart';
import 'package:bnan_app/features/parent_children/presentation/policies/parent_error_mapper.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/egyptian_renewal_request.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/gulf_renewal_request.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/renewal_status_response.dart';
import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_state.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentSubscriptionRenewalCubit
    extends Cubit<ParentSubscriptionRenewalState> {
  ParentSubscriptionRenewalCubit({
    required this.repo,
    required IdempotencyKeyGenerator keyGenerator,
    required ParentSubscriptionRenewalArgs args,
    this.pollInterval = const Duration(seconds: 3),
    this.maxPollAttempts = 20,
  }) : _attempt = ParentPaymentAttempt(keyGenerator),
       super(ParentSubscriptionRenewalState(args: args));
  final ParentSubscriptionsRepo repo;
  final ParentPaymentAttempt _attempt;
  final Duration pollInterval;
  final int maxPollAttempts;
  bool _submitting = false;
  bool _checkingPayment = false;
  String? _pollingPaymentId;
  final Set<String> _completedPaymentIds = {};

  void selectPackage(PackageModel value) {
    if (!ParentPackagePolicy.isValid(
          value,
          registrationMode: state.args.registrationMode,
        ) ||
        value.curriculum != null &&
            value.curriculum != state.args.curriculumId) {
      return _error('INVALID_PACKAGE_FOR_CURRICULUM');
    }
    emit(state.copyWith(package: value, subjectId: null, errorMessage: null));
  }

  void selectSubject(String id) {
    if (!state.args.subjects.any((item) => item.id == id)) {
      return _error('SUBJECT_NOT_ASSIGNED_TO_STUDENT');
    }
    emit(state.copyWith(subjectId: id, errorMessage: null));
  }

  void updateDiscount(String value) =>
      emit(state.copyWith(discountCode: value, errorMessage: null));
  void updateEgyptian({String? method, String? reference, File? receipt}) =>
      emit(
        state.copyWith(
          method: method,
          referenceNumber: reference,
          receipt: receipt ?? state.receipt,
          errorMessage: null,
        ),
      );
  void updateAddress({
    String? city,
    String? region,
    String? line1,
    String? line2,
  }) => emit(
    state.copyWith(
      city: city,
      region: region,
      line1: line1,
      line2: line2,
      errorMessage: null,
    ),
  );

  bool nextStep() {
    final error = _validation();
    if (error != null) {
      _error(error);
      return false;
    }
    if (state.currentStep < 5) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
    return true;
  }

  void previousStep() {
    if (state.currentStep > 0 && !state.isBusy) {
      emit(
        state.copyWith(currentStep: state.currentStep - 1, errorMessage: null),
      );
    }
  }

  Future<void> submit() async {
    if (_submitting) return;
    if (!state.hasSupportedRegistrationMode ||
        state.package == null ||
        !ParentPackagePolicy.isValid(
          state.package!,
          registrationMode: state.args.registrationMode,
        )) {
      return _error('INVALID_PACKAGE_FOR_CURRICULUM');
    }
    final error = _validation(payment: true);
    if (error != null) return _error(error);
    _submitting = true;
    try {
      if (state.isGulf) {
        await _submitGulf();
      } else {
        await _submitEgyptian();
      }
    } finally {
      _submitting = false;
    }
  }

  Future<void> retry() async {
    final terminal = {
      RenewalPaymentStatus.rejected,
      RenewalPaymentStatus.failed,
      RenewalPaymentStatus.cancelled,
      RenewalPaymentStatus.expired,
    }.contains(state.status);
    final checkoutFailure =
        state.phase == ParentRenewalPhase.failure && state.status == null;
    if (!terminal && !checkoutFailure) {
      return;
    }
    if (terminal) _attempt.startNew();
    await submit();
  }

  void checkoutOpened() {
    final resumePolling =
        state.phase == ParentRenewalPhase.paymentStatusUnknown &&
        state.paymentId != null;
    emit(
      state.copyWith(
        shouldOpenCheckout: false,
        phase: resumePolling ? ParentRenewalPhase.processing : state.phase,
      ),
    );
    if (resumePolling) unawaited(_pollGulf(state.paymentId!));
  }

  void checkoutOpenFailed() => emit(
    state.copyWith(
      phase: ParentRenewalPhase.paymentStatusUnknown,
      errorMessage: S.current.parentUnableToOpenCheckout,
    ),
  );

  void reopenCheckout() {
    if (state.checkoutUrl?.isNotEmpty == true) {
      emit(state.copyWith(shouldOpenCheckout: true, errorMessage: null));
    }
  }

  Future<void> reconcilePayment() => checkPaymentStatus();

  Future<void> checkPaymentStatus() async {
    final id = state.paymentId;
    if (id == null ||
        _checkingPayment ||
        _pollingPaymentId != null ||
        !{
          ParentRenewalPhase.processing,
          ParentRenewalPhase.pending,
          ParentRenewalPhase.paymentStatusUnknown,
        }.contains(state.phase)) {
      return;
    }
    _checkingPayment = true;
    try {
      RenewalStatusResponse? response;
      if (state.isGulf) {
        (await repo.gulfReconcile(
          id,
        )).fold((_) {}, (value) => response = value);
        if (isClosed) return;
        if (response == null || !response!.status.isTerminal) {
          (await repo.gulfStatus(id)).fold((_) {}, (value) => response = value);
          if (isClosed) return;
        }
      } else {
        (await repo.egyptianStatus(
          id,
        )).fold((_) {}, (value) => response = value);
        if (isClosed) return;
      }
      if (response != null) await _handle(response!);
    } finally {
      _checkingPayment = false;
    }
  }

  Future<void> _submitEgyptian() async {
    emit(
      state.copyWith(
        phase: ParentRenewalPhase.submitting,
        paymentId: null,
        status: null,
        errorMessage: null,
      ),
    );
    final result = await repo.renewEgyptian(
      EgyptianRenewalRequest(
        studentId: state.args.studentId,
        packageId: state.package!.id!,
        subjectId: state.isSingleSubject ? state.subjectId : null,
        discountCode: state.discountCode,
        method: state.method,
        referenceNumber: state.referenceNumber,
        receiptImage: state.receipt!,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            phase: ParentRenewalPhase.failure,
            errorMessage: mapParentFlowFailure(
              failure,
              fallback: S.current.renewalFailed,
            ),
          ),
        );
      },
      (response) async {
        emit(
          state.copyWith(
            phase: ParentRenewalPhase.pending,
            paymentId: response.paymentId,
            status: response.status,
            paymentSummary: response.paymentSummary,
            errorMessage: null,
          ),
        );
        if (response.status.isTerminal) {
          await _handle(response);
        } else if (response.paymentId.isNotEmpty) {
          unawaited(_pollEgyptian(response.paymentId));
        }
      },
    );
  }

  Future<void> _submitGulf() async {
    emit(
      state.copyWith(
        phase: ParentRenewalPhase.submitting,
        paymentId: null,
        checkoutUrl: null,
        status: null,
        shouldOpenCheckout: false,
        errorMessage: null,
      ),
    );
    final request = GulfRenewalRequest(
      studentId: state.args.studentId,
      packageId: state.package!.id!,
      subjectId: state.isSingleSubject ? state.subjectId : null,
      discountCode: state.discountCode,
      paymentAddress: ParentPaymentAddress(
        city: state.city,
        region: state.region,
        line1: state.line1,
        line2: state.line2,
      ),
    );
    final result = await repo.renewGulf(
      request: request,
      idempotencyKey: _attempt.keyFor(request.toJson()),
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        if (failure.responseReceived) _attempt.startNew();
        emit(
          state.copyWith(
            phase: ParentRenewalPhase.failure,
            errorMessage: mapParentFlowFailure(
              failure,
              fallback: S.current.renewalFailed,
            ),
          ),
        );
      },
      (response) async {
        if (response.status.isTerminal) {
          await _handle(response);
          return;
        }
        emit(
          state.copyWith(
            phase: ParentRenewalPhase.processing,
            paymentId: response.paymentId,
            checkoutUrl: response.checkoutUrl,
            status: response.status,
            paymentSummary: response.paymentSummary,
            shouldOpenCheckout: true,
            errorMessage: null,
          ),
        );
        unawaited(_pollGulf(response.paymentId));
      },
    );
  }

  Future<void> _pollEgyptian(String id) async {
    await _poll(
      id,
      status: () => repo.egyptianStatus(id),
      canContinue: () => !isClosed && state.phase == ParentRenewalPhase.pending,
    );
  }

  Future<void> _pollGulf(String id) async {
    await _poll(
      id,
      reconcile: () => repo.gulfReconcile(id),
      status: () => repo.gulfStatus(id),
      canContinue: () =>
          !isClosed && state.phase == ParentRenewalPhase.processing,
    );
  }

  Future<void> _poll(
    String id, {
    ParentPaymentRequest<RenewalStatusResponse>? reconcile,
    required ParentPaymentRequest<RenewalStatusResponse> status,
    required bool Function() canContinue,
  }) async {
    if (_pollingPaymentId != null) return;
    _pollingPaymentId = id;
    try {
      final result =
          await ParentPaymentPoller<RenewalStatusResponse>(
            interval: pollInterval,
            maxAttempts: maxPollAttempts,
          ).poll(
            reconcile: reconcile,
            status: status,
            isTerminal: (value) => value.status.isTerminal,
            canContinue: canContinue,
          );
      if (result.outcome == ParentPaymentPollOutcome.terminal &&
          result.value != null) {
        await _handle(result.value!);
      } else if (result.outcome == ParentPaymentPollOutcome.timedOut &&
          !isClosed) {
        emit(
          state.copyWith(
            phase: ParentRenewalPhase.paymentStatusUnknown,
            errorMessage: S.current.parentPaymentStatusTimeout,
          ),
        );
      }
    } finally {
      if (_pollingPaymentId == id) _pollingPaymentId = null;
    }
  }

  Future<void> _handle(RenewalStatusResponse response) async {
    if (isClosed) return;
    if (response.status == RenewalPaymentStatus.completed) {
      final id = response.paymentId.isEmpty
          ? state.paymentId
          : response.paymentId;
      if (id == null || !_completedPaymentIds.add(id)) return;
      emit(
        state.copyWith(
          phase: ParentRenewalPhase.completed,
          status: response.status,
          paymentSummary: response.paymentSummary,
          errorMessage: null,
        ),
      );
    } else if (response.status.isTerminal) {
      _attempt.startNew();
      emit(
        state.copyWith(
          phase: ParentRenewalPhase.failure,
          status: response.status,
          errorMessage: _mapped(response.status.name),
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: response.status,
          paymentSummary: response.paymentSummary,
        ),
      );
    }
  }

  String? _validation({bool payment = false}) {
    if (!state.hasSupportedRegistrationMode) {
      return 'UNSUPPORTED_REGISTRATION_MODE';
    }
    if (state.currentStep == 1 && state.package == null) {
      return 'PACKAGE_NOT_FOUND';
    }
    if (state.currentStep == 2 &&
        state.isSingleSubject &&
        state.subjectId == null) {
      return 'SINGLE_SUBJECT_SUBSCRIPTION_SUBJECT_REQUIRED';
    }
    if (payment || state.currentStep == 5) {
      if (!state.isGulf && state.receipt == null) return 'RECEIPT_REQUIRED';
      if (state.isGulf &&
          [
            state.city,
            state.region,
            state.line1,
          ].any((v) => v.trim().isEmpty)) {
        return 'ADDRESS_REQUIRED';
      }
    }
    return null;
  }

  void _error(String code, {bool failure = false}) => emit(
    state.copyWith(
      phase: failure ? ParentRenewalPhase.failure : state.phase,
      errorMessage: _mapped(code),
    ),
  );
  String _mapped(String code) {
    final value = code.toUpperCase();
    if (value.contains('SUBSCRIPTION_STILL_ACTIVE')) {
      return S.current.renewalSubscriptionStillActive;
    }
    if (value.contains('SUBJECT_NOT_ASSIGNED')) {
      return S.current.renewalSubjectNotAssigned;
    }
    if (value.contains('SINGLE_SUBJECT')) {
      return S.current.parentSingleSubjectRequired;
    }
    if (value.contains('STUDENT_ACCESS_DENIED')) {
      return S.current.renewalStudentAccessDenied;
    }
    if (value.contains('IDEMPOTENCY_KEY_REQUIRED')) {
      return S.current.renewalIdempotencyRequired;
    }
    if (value.contains('PACKAGE')) return S.current.invalidPackage;
    if (value.contains('RECEIPT')) return S.current.paymentReceiptRequired;
    if (value.contains('ADDRESS')) {
      return S.current.parentPaymentAddressRequired;
    }
    if (value.contains('UNSUPPORTED_REGISTRATION_MODE')) {
      return S.current.parentUnsupportedRegistrationMode;
    }
    return S.current.renewalFailed;
  }
}
