import 'dart:io';

import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';

enum ParentAddChildPhase {
  initial,
  loadingLookups,
  editing,
  submitting,
  pendingReview,
  processingPayment,
  paymentStatusUnknown,
  completed,
  failure,
}

const _unset = Object();

class ParentAddChildState {
  const ParentAddChildState({
    this.phase = ParentAddChildPhase.initial,
    this.currentStep = 0,
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.parentHasChildren = false,
    this.curriculum,
    this.grade,
    this.package,
    this.selectedSubjectIds = const [],
    this.discountCode = '',
    this.paymentMethod = '',
    this.referenceNumber = '',
    this.receipt,
    this.paymentId,
    this.checkoutUrl,
    this.paymentSummary,
    this.paymentStatus,
    this.shouldOpenCheckout = false,
    this.selectedProvider = GulfPaymentProvider.tamara,
    this.errorMessage,
  });

  final ParentAddChildPhase phase;
  final int currentStep;
  final String fullName, email, password;
  final bool parentHasChildren;
  final AcademicCurriculumModel? curriculum;
  final AcademicGradeModel? grade;
  final PackageModel? package;
  final List<String> selectedSubjectIds;
  final String discountCode, paymentMethod, referenceNumber;
  final File? receipt;
  final String? paymentId, checkoutUrl, errorMessage;
  final PaymentAmountSummary? paymentSummary;
  final PaymentStatus? paymentStatus;
  final bool shouldOpenCheckout;
  final GulfPaymentProvider selectedProvider;

  bool get isGulf => _value(curriculum?.registrationMode) == 'gulf';
  bool get hasSupportedRegistrationMode =>
      _value(curriculum?.registrationMode) == 'egyptian' || isGulf;
  bool get isSingleSubject => _value(package?.accessScope) == 'single_subject';
  bool get isAllSubjects => _value(package?.accessScope) == 'all_subjects';
  bool get isEgyptianPrivate =>
      _value(curriculum?.registrationMode) == 'egyptian' &&
      isSingleSubject &&
      _value(package?.type) == 'hours';
  bool get requiresSubjectSelection => isGulf || isSingleSubject;
  int get lastStep => isGulf ? 5 : 4;
  bool get isBusy =>
      phase == ParentAddChildPhase.submitting ||
      phase == ParentAddChildPhase.processingPayment;

  static String _value(String? value) => value?.trim().toLowerCase() ?? '';

  ParentAddChildState copyWith({
    ParentAddChildPhase? phase,
    int? currentStep,
    String? fullName,
    String? email,
    String? password,
    bool? parentHasChildren,
    Object? curriculum = _unset,
    Object? grade = _unset,
    Object? package = _unset,
    List<String>? selectedSubjectIds,
    String? discountCode,
    String? paymentMethod,
    String? referenceNumber,
    Object? receipt = _unset,
    Object? paymentId = _unset,
    Object? checkoutUrl = _unset,
    Object? paymentSummary = _unset,
    Object? paymentStatus = _unset,
    bool? shouldOpenCheckout,
    GulfPaymentProvider? selectedProvider,
    Object? errorMessage = _unset,
  }) => ParentAddChildState(
    phase: phase ?? this.phase,
    currentStep: currentStep ?? this.currentStep,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    password: password ?? this.password,
    parentHasChildren: parentHasChildren ?? this.parentHasChildren,
    curriculum: identical(curriculum, _unset)
        ? this.curriculum
        : curriculum as AcademicCurriculumModel?,
    grade: identical(grade, _unset) ? this.grade : grade as AcademicGradeModel?,
    package: identical(package, _unset)
        ? this.package
        : package as PackageModel?,
    selectedSubjectIds: selectedSubjectIds ?? this.selectedSubjectIds,
    discountCode: discountCode ?? this.discountCode,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    referenceNumber: referenceNumber ?? this.referenceNumber,
    receipt: identical(receipt, _unset) ? this.receipt : receipt as File?,
    paymentId: identical(paymentId, _unset)
        ? this.paymentId
        : paymentId as String?,
    checkoutUrl: identical(checkoutUrl, _unset)
        ? this.checkoutUrl
        : checkoutUrl as String?,
    paymentSummary: identical(paymentSummary, _unset)
        ? this.paymentSummary
        : paymentSummary as PaymentAmountSummary?,
    paymentStatus: identical(paymentStatus, _unset)
        ? this.paymentStatus
        : paymentStatus as PaymentStatus?,
    shouldOpenCheckout: shouldOpenCheckout ?? this.shouldOpenCheckout,
    selectedProvider: selectedProvider ?? this.selectedProvider,
    errorMessage: identical(errorMessage, _unset)
        ? this.errorMessage
        : errorMessage as String?,
  );
}
