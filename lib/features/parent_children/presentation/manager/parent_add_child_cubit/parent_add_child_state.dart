import 'dart:io';

import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';
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
    this.confirmPassword = '',
    this.curriculum,
    this.grade,
    this.package,
    this.selectedSubjectIds = const [],
    this.discountCode = '',
    this.paymentMethod = '',
    this.referenceNumber = '',
    this.receipt,
    this.city = '',
    this.region = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.paymentId,
    this.checkoutUrl,
    this.paymentSummary,
    this.paymentStatus,
    this.shouldOpenCheckout = false,
    this.errorMessage,
  });

  final ParentAddChildPhase phase;
  final int currentStep;
  final String fullName, email, password, confirmPassword;
  final AcademicCurriculumModel? curriculum;
  final AcademicGradeModel? grade;
  final PackageModel? package;
  final List<String> selectedSubjectIds;
  final String discountCode, paymentMethod, referenceNumber;
  final File? receipt;
  final String city, region, addressLine1, addressLine2;
  final String? paymentId, checkoutUrl, errorMessage;
  final PaymentAmountSummary? paymentSummary;
  final PaymentStatus? paymentStatus;
  final bool shouldOpenCheckout;

  bool get isGulf => curriculum?.registrationMode == 'gulf';
  bool get hasSupportedRegistrationMode =>
      curriculum?.registrationMode == 'egyptian' || isGulf;
  bool get isSingleSubject => package?.accessScope == 'single_subject';
  bool get isBusy =>
      phase == ParentAddChildPhase.submitting ||
      phase == ParentAddChildPhase.processingPayment;

  ParentAddChildState copyWith({
    ParentAddChildPhase? phase,
    int? currentStep,
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
    Object? curriculum = _unset,
    Object? grade = _unset,
    Object? package = _unset,
    List<String>? selectedSubjectIds,
    String? discountCode,
    String? paymentMethod,
    String? referenceNumber,
    Object? receipt = _unset,
    String? city,
    String? region,
    String? addressLine1,
    String? addressLine2,
    Object? paymentId = _unset,
    Object? checkoutUrl = _unset,
    Object? paymentSummary = _unset,
    Object? paymentStatus = _unset,
    bool? shouldOpenCheckout,
    Object? errorMessage = _unset,
  }) => ParentAddChildState(
    phase: phase ?? this.phase,
    currentStep: currentStep ?? this.currentStep,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    password: password ?? this.password,
    confirmPassword: confirmPassword ?? this.confirmPassword,
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
    city: city ?? this.city,
    region: region ?? this.region,
    addressLine1: addressLine1 ?? this.addressLine1,
    addressLine2: addressLine2 ?? this.addressLine2,
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
    errorMessage: identical(errorMessage, _unset)
        ? this.errorMessage
        : errorMessage as String?,
  );
}
