import 'dart:async';
import 'dart:io';

import 'package:bnan_app/core/constants/tamara_default_address.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_egyptian_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_gulf_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_child_student_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';
import 'package:bnan_app/features/parent_children/data/parent_payment_poller.dart';
import 'package:bnan_app/features/parent_children/data/parent_payment_attempt.dart';
import 'package:bnan_app/features/parent_children/data/repo/parent_add_child_repo.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_state.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_validation.dart';
import 'package:bnan_app/features/parent_children/presentation/policies/parent_error_mapper.dart';
import 'package:bnan_app/features/parent_children/presentation/policies/parent_package_policy.dart';
import 'package:bnan_app/features/payments/data/models/payment_draft.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:bnan_app/features/payments/data/payment_draft_store.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_auth/data/debug/gulf_registration_diagnostics.dart';
import 'package:bnan_app/features/student_auth/data/models/registration_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentAddChildCubit extends Cubit<ParentAddChildState> {
  ParentAddChildCubit({
    required this.repo,
    required IdempotencyKeyGenerator keyGenerator,
    this.store,
    this.pollInterval,
    this.maxPollAttempts,
    this.checkoutReturnTimeout = const Duration(seconds: 10),
    GulfPaymentProvider provider = GulfPaymentProvider.tamara,
  }) : _attempt = ParentPaymentAttempt(keyGenerator),
       super(ParentAddChildState(selectedProvider: provider));

  final ParentAddChildRepo repo;
  final ParentPaymentAttempt _attempt;
  final PaymentDraftStore? store;
  final Duration? pollInterval;
  final int? maxPollAttempts;
  final Duration checkoutReturnTimeout;
  bool _submitting = false;
  bool _checkingPayment = false;
  String? _pollingPaymentId;
  final Set<String> _completedPaymentIds = {};

  void start(AcademicCurriculumModel? curriculum, {bool? parentHasChildren}) {
    final hasChildren = parentHasChildren ?? curriculum != null;
    emit(
      ParentAddChildState(
        phase: ParentAddChildPhase.editing,
        parentHasChildren: hasChildren,
        curriculum: curriculum,
        selectedProvider: state.selectedProvider,
      ),
    );
    if (curriculum == null) return;
    final draft = _resumableDraft(curriculum.id);
    if (draft == null) return;
    emit(
      state.copyWith(
        phase: ParentAddChildPhase.paymentStatusUnknown,
        paymentId: draft.paymentId,
        checkoutUrl: draft.checkoutUrl,
        paymentStatus: draft.lastKnownStatus,
        selectedProvider: draft.provider,
      ),
    );
    _log('state transition: restored pending payment');
    unawaited(verifyPaymentSuccess());
  }

  void updateAccount({String? fullName, String? email, String? password}) =>
      emit(
        state.copyWith(
          fullName: fullName,
          email: email,
          password: password,
          errorMessage: null,
        ),
      );

  void selectCurriculum(AcademicCurriculumModel? value) {
    if (state.parentHasChildren || state.curriculum?.id == value?.id) return;
    emit(
      state.copyWith(
        curriculum: value,
        grade: null,
        package: null,
        selectedSubjectIds: const [],
        errorMessage: null,
      ),
    );
  }

  void selectGrade(AcademicGradeModel? value) => emit(
    state.copyWith(
      grade: value,
      selectedSubjectIds: const [],
      errorMessage: null,
    ),
  );

  void setGradeSubjectIds(Iterable<String> subjectIds) {
    if (state.isGulf || !state.isAllSubjects) return;
    final ids = subjectIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);
    emit(state.copyWith(selectedSubjectIds: ids, errorMessage: null));
  }

  void selectPackage(PackageModel value) {
    if (!_packageMatchesCurriculum(value) ||
        !ParentPackagePolicy.isValid(
          value,
          registrationMode: state.curriculum?.registrationMode,
        )) {
      return emit(state.copyWith(errorMessage: S.current.invalidPackage));
    }
    emit(
      state.copyWith(
        package: value,
        selectedSubjectIds: const [],
        errorMessage: null,
      ),
    );
  }

  void toggleSubject(String id) {
    final selected = [...state.selectedSubjectIds];
    if (state.isSingleSubject && !state.isEgyptianPrivate && !state.isGulf) {
      emit(state.copyWith(selectedSubjectIds: [id], errorMessage: null));
      return;
    }
    selected.contains(id) ? selected.remove(id) : selected.add(id);
    emit(state.copyWith(selectedSubjectIds: selected, errorMessage: null));
  }

  void updateDiscount(String value) =>
      emit(state.copyWith(discountCode: value, errorMessage: null));

  void selectPaymentProvider(GulfPaymentProvider provider) {
    if (!state.isGulf || state.selectedProvider == provider) return;
    emit(state.copyWith(selectedProvider: provider, errorMessage: null));
  }

  void updateEgyptianPayment({
    String? method,
    String? referenceNumber,
    File? receipt,
  }) => emit(
    state.copyWith(
      paymentMethod: method,
      referenceNumber: referenceNumber,
      receipt: receipt ?? state.receipt,
      errorMessage: null,
    ),
  );

  bool nextStep() {
    final error = ParentAddChildValidation.currentStep(state);
    if (error != null) {
      emit(state.copyWith(errorMessage: error));
      return false;
    }
    if (state.currentStep < state.lastStep) {
      final nextStep = state.currentStep == 2 && !state.requiresSubjectSelection
          ? 4
          : state.currentStep + 1;
      emit(state.copyWith(currentStep: nextStep));
    }
    return true;
  }

  void previousStep() {
    if (state.currentStep == 0 || state.isBusy) return;
    final previousStep =
        state.currentStep == 4 && !state.requiresSubjectSelection
        ? 2
        : state.currentStep - 1;
    emit(state.copyWith(currentStep: previousStep, errorMessage: null));
  }

  Future<void> submit() async {
    if (_submitting) return;
    _log('submit started; mode=${state.curriculum?.registrationMode}');
    if (state.curriculum == null ||
        !state.hasSupportedRegistrationMode ||
        state.package == null ||
        !_packageMatchesCurriculum(state.package!) ||
        !ParentPackagePolicy.isValid(
          state.package!,
          registrationMode: state.curriculum?.registrationMode,
        )) {
      _log('submit rejected: invalid package or registration mode');
      return emit(state.copyWith(errorMessage: S.current.invalidPackage));
    }
    final error = ParentAddChildValidation.currentStep(state);
    if (error != null) {
      _log('submit rejected: current-step validation failed');
      return emit(state.copyWith(errorMessage: error));
    }
    _submitting = true;
    try {
      if (state.isGulf) {
        await _checkoutGulf();
      } else {
        await _submitEgyptian();
      }
    } catch (error, stackTrace) {
      _log('cubit error: $error');
      if (kDebugMode) debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } finally {
      _submitting = false;
    }
  }

  Future<void> retryPayment() async {
    if (!{
      PaymentStatus.failed,
      PaymentStatus.cancelled,
      PaymentStatus.expired,
    }.contains(state.paymentStatus)) {
      return;
    }
    _attempt.startNew();
    await submit();
  }

  void checkoutOpened() {
    final resumePolling =
        state.phase == ParentAddChildPhase.paymentStatusUnknown &&
        state.paymentId != null;
    emit(
      state.copyWith(
        shouldOpenCheckout: false,
        phase: resumePolling
            ? ParentAddChildPhase.processingPayment
            : state.phase,
      ),
    );
    if (resumePolling) unawaited(_poll(state.paymentId!));
  }

  void checkoutOpenFailed() => emit(
    state.copyWith(
      phase: ParentAddChildPhase.paymentStatusUnknown,
      errorMessage: S.current.parentUnableToOpenCheckout,
    ),
  );

  Future<void> checkoutClosed() async {
    if (state.phase != ParentAddChildPhase.processingPayment) return;
    emit(
      state.copyWith(
        phase: ParentAddChildPhase.paymentStatusUnknown,
        shouldOpenCheckout: false,
        errorMessage: null,
      ),
    );
    try {
      await verifyPaymentSuccess().timeout(checkoutReturnTimeout);
    } on TimeoutException {
      // The existing checkout remains available after a slow status check.
    } catch (_) {
      // Closing Tamara must not leave the add-child flow processing.
    }
  }

  void reopenCheckout() {
    if (state.checkoutUrl?.isNotEmpty == true) {
      emit(state.copyWith(shouldOpenCheckout: true, errorMessage: null));
    }
  }

  Future<void> reconcilePayment() => checkPaymentStatus();

  Future<void> verifyPaymentSuccess() async {
    final id = state.paymentId;
    if (id == null || id.isEmpty) return;
    if (state.phase == ParentAddChildPhase.paymentStatusUnknown) {
      emit(state.copyWith(phase: ParentAddChildPhase.processingPayment));
    }
    await _poll(id);
  }

  Future<void> checkPaymentStatus() async {
    final id = state.paymentId;
    if (id == null ||
        _checkingPayment ||
        _pollingPaymentId != null ||
        !{
          ParentAddChildPhase.processingPayment,
          ParentAddChildPhase.paymentStatusUnknown,
        }.contains(state.phase)) {
      return;
    }
    _checkingPayment = true;
    try {
      final reconciled = state.selectedProvider.supportsReconcile
          ? await repo.reconcile(id)
          : null;
      if (isClosed) return;
      TamaraStatusResponse? response;
      reconciled?.fold((_) {}, (value) => response = value);
      if (response == null || !response!.status.isTerminal) {
        final status = await repo.status(id, provider: state.selectedProvider);
        if (isClosed) return;
        status.fold((_) {}, (value) => response = value);
      }
      if (response != null) await _handlePaymentStatus(response!);
    } finally {
      _checkingPayment = false;
    }
  }

  ParentChildStudentRequest _student() => ParentChildStudentRequest(
    fullName: state.fullName,
    email: state.email,
    password: state.password,
    gradeId: state.grade!.id,
    subjectIds: state.selectedSubjectIds,
  );

  Future<void> _submitEgyptian() async {
    emit(state.copyWith(phase: ParentAddChildPhase.submitting));
    _log('state emitted: submitting');
    final request = ParentAddChildEgyptianRequest(
      student: _student(),
      curriculumId: state.curriculum!.id,
      packageId: state.package!.id!,
      discountCode: state.discountCode,
    );
    _log('Egyptian request model built');
    _log('Egyptian repository call started');
    final result = await repo.registerEgyptian(request);
    if (isClosed) return;
    _log('Egyptian repository call completed');
    result.fold(
      (failure) {
        _log('Egyptian submission failure: ${failure.message}');
        _fail(failure.message);
      },
      (_) {
        _log('Egyptian submission success');
        emit(
          state.copyWith(
            phase: ParentAddChildPhase.pendingReview,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _checkoutGulf() async {
    emit(
      state.copyWith(
        phase: ParentAddChildPhase.submitting,
        paymentId: null,
        checkoutUrl: null,
        paymentStatus: null,
        shouldOpenCheckout: false,
        errorMessage: null,
      ),
    );
    _log('state emitted: submitting');
    final request = ParentAddChildGulfRequest(
      student: _student(),
      curriculumId: state.curriculum!.id,
      packageId: state.package!.id!,
      items: state.isSingleSubject
          ? state.selectedSubjectIds
                .map(
                  (subjectId) => RegistrationItem(
                    subjectId: subjectId,
                    packageId: state.package!.id!,
                  ),
                )
                .toList(growable: false)
          : const [],
      discountCode: state.discountCode,
      paymentAddress: const ParentPaymentAddress(
        city: TamaraDefaultAddress.city,
        region: TamaraDefaultAddress.region,
        line1: TamaraDefaultAddress.line1,
        line2: TamaraDefaultAddress.line2,
      ),
      provider: state.selectedProvider,
    );
    final key = await _beginAttempt(request);
    if (isClosed) return;
    _log('idempotency attempt prepared');
    _log('combined checkout started');
    final result = await repo.checkoutGulf(
      request: request,
      idempotencyKey: key,
    );
    if (isClosed) return;
    await result.fold(
      (failure) async {
        GulfRegistrationDiagnostics.uiFailure(
          endpoint: EndPoints.parentChildGulfCheckout,
          cubit: 'ParentAddChildCubit',
          state: 'ParentAddChildPhase.failure',
          message: failure.message,
        );
        _log(
          'checkout failure; responseReceived=${failure.responseReceived}, '
          'statusCode=${failure.statusCode}, code=${failure.code}',
        );
        _handleCheckoutFailure(failure);
      },
      (checkout) async {
        _log('checkout response accepted; paymentId present');
        await _saveCheckout(request, checkout.paymentId, checkout.checkoutUrl!);
        if (isClosed) return;
        emit(
          state.copyWith(
            phase: ParentAddChildPhase.processingPayment,
            paymentId: checkout.paymentId,
            checkoutUrl: checkout.checkoutUrl,
            paymentSummary: checkout.paymentSummary,
            paymentStatus: PaymentStatus.pending,
            shouldOpenCheckout: true,
          ),
        );
        _log('state emitted: processingPayment; checkout launch requested');
        _log('checkout opening');
      },
    );
  }

  Future<void> _poll(String paymentId) async {
    if (_pollingPaymentId != null) return;
    _pollingPaymentId = paymentId;
    try {
      final result =
          await ParentPaymentPoller<TamaraStatusResponse>(
            interval: pollInterval,
            maxAttempts: maxPollAttempts,
          ).poll(
            reconcile: state.selectedProvider.supportsReconcile
                ? () => repo.reconcile(paymentId)
                : null,
            status: () =>
                repo.status(paymentId, provider: state.selectedProvider),
            isTerminal: (value) => value.status.isTerminal,
            canContinue: () =>
                !isClosed &&
                state.phase == ParentAddChildPhase.processingPayment,
          );
      if (result.outcome == ParentPaymentPollOutcome.terminal &&
          result.value != null) {
        await _handlePaymentStatus(result.value!);
      } else if (result.outcome == ParentPaymentPollOutcome.timedOut &&
          !isClosed &&
          state.phase == ParentAddChildPhase.processingPayment) {
        emit(
          state.copyWith(
            phase: ParentAddChildPhase.paymentStatusUnknown,
            errorMessage: S.current.parentPaymentStatusTimeout,
          ),
        );
      }
    } finally {
      if (_pollingPaymentId == paymentId) _pollingPaymentId = null;
    }
  }

  Future<void> _handlePaymentStatus(TamaraStatusResponse response) async {
    if (isClosed) return;
    _log('payment status: ${response.status.name}');
    if (response.status == PaymentStatus.completed) {
      final id = response.paymentId.isEmpty
          ? state.paymentId
          : response.paymentId;
      if (id == null || !_completedPaymentIds.add(id)) return;
      await store?.clear();
      if (isClosed) return;
      emit(
        state.copyWith(
          phase: ParentAddChildPhase.completed,
          paymentStatus: response.status,
          paymentSummary: response.paymentSummary,
          errorMessage: null,
        ),
      );
      return;
    }
    if ({
      PaymentStatus.failed,
      PaymentStatus.cancelled,
      PaymentStatus.expired,
    }.contains(response.status)) {
      _attempt.startNew();
      await store?.clear();
      if (isClosed) return;
      emit(
        state.copyWith(
          phase: ParentAddChildPhase.failure,
          paymentStatus: response.status,
          errorMessage: S.current.parentPaymentFailed,
        ),
      );
      return;
    }
    if (response.status == PaymentStatus.refunded) {
      emit(
        state.copyWith(
          phase: ParentAddChildPhase.failure,
          paymentStatus: response.status,
          errorMessage: S.current.parentPaymentFailed,
        ),
      );
    }
  }

  void _fail(String message) => emit(
    state.copyWith(
      phase: ParentAddChildPhase.failure,
      errorMessage: _safeMessage(message),
    ),
  );

  void _handleCheckoutFailure(Failure failure) {
    final message = mapParentFlowFailure(
      failure,
      fallback: _safeMessage(failure.message),
    );
    if (isParentPaymentInputFailure(failure)) {
      emit(
        state.copyWith(
          phase: ParentAddChildPhase.editing,
          currentStep: 5,
          errorMessage: message,
        ),
      );
      _log('state transition: editable payment error');
      return;
    }
    _fail(message);
  }

  Future<String> _beginAttempt(ParentAddChildGulfRequest request) async {
    final payload = request.toJson();
    final fingerprint = _attempt.fingerprintFor(payload);
    final cached = store?.read();
    if (_owns(cached) &&
        cached!.paymentId.isEmpty &&
        cached.payloadFingerprint == 'parent_add_child:$fingerprint') {
      _attempt.restore(fingerprint: fingerprint, key: cached.idempotencyKey);
    }
    final key = _attempt.keyFor(payload);
    await store?.save(_draft(request, key, fingerprint));
    return key;
  }

  Future<void> _saveCheckout(
    ParentAddChildGulfRequest request,
    String paymentId,
    String checkoutUrl,
  ) async {
    final payload = request.toJson();
    final fingerprint = _attempt.fingerprintFor(payload);
    final key = _attempt.keyFor(payload);
    await store?.save(
      _draft(
        request,
        key,
        fingerprint,
        paymentId: paymentId,
        checkoutUrl: checkoutUrl,
      ),
    );
  }

  PaymentDraft _draft(
    ParentAddChildGulfRequest request,
    String key,
    String fingerprint, {
    String paymentId = '',
    String? checkoutUrl,
  }) => PaymentDraft(
    paymentId: paymentId,
    checkoutUrl: checkoutUrl,
    idempotencyKey: key,
    packageId: request.packageId,
    curriculumId: request.curriculumId,
    gradeId: request.student.gradeId,
    subjectIds: request.student.subjectIds,
    studentEmail: request.student.email,
    paymentStartedAt: DateTime.now(),
    lastKnownStatus: PaymentStatus.pending,
    provider: request.provider,
    purpose: PaymentDraftPurpose.addChild,
    payloadFingerprint: 'parent_add_child:$fingerprint',
    ownerUserId: SessionManager.instance.userId?.trim() ?? '',
  );

  PaymentDraft? _resumableDraft(String curriculumId) {
    final draft = store?.read();
    if (!_owns(draft) ||
        draft!.curriculumId != curriculumId ||
        draft.paymentId.isEmpty ||
        !draft.lastKnownStatus.isProcessing ||
        draft.purpose != PaymentDraftPurpose.addChild) {
      return null;
    }
    return draft;
  }

  bool _owns(PaymentDraft? draft) =>
      draft != null &&
      draft.ownerUserId == (SessionManager.instance.userId?.trim() ?? '');

  void _log(String message) {
    if (kDebugMode) debugPrint('[ParentAddChildCubit] $message');
  }

  String _safeMessage(String message) {
    final value = message.toLowerCase();
    if (value.contains('email') || value.contains('already')) {
      return S.current.parentChildEmailUsed;
    }
    if (value.contains('receipt')) return S.current.parentReceiptError;
    if (value.contains('curriculum') ||
        value.contains('grade') ||
        value.contains('subject') ||
        value.contains('package')) {
      return S.current.errorValidation;
    }
    return S.current.parentAddChildFailed;
  }

  bool _packageMatchesCurriculum(PackageModel value) {
    final packageCurriculum = value.curriculum?.trim();
    return packageCurriculum == null ||
        packageCurriculum.isEmpty ||
        packageCurriculum == state.curriculum?.id;
  }
}
