import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/renewal_status_response.dart';
import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';

enum ParentRenewalPhase {
  editing,
  submitting,
  pending,
  processing,
  paymentStatusUnknown,
  completed,
  failure,
}

const _unset = Object();

class ParentSubscriptionRenewalState {
  const ParentSubscriptionRenewalState({
    required this.args,
    this.phase = ParentRenewalPhase.editing,
    this.currentStep = 0,
    this.package,
    this.subjectId,
    this.discountCode = '',
    this.paymentId,
    this.checkoutUrl,
    this.status,
    this.paymentSummary,
    this.shouldOpenCheckout = false,
    this.errorMessage,
  });
  final ParentSubscriptionRenewalArgs args;
  final ParentRenewalPhase phase;
  final int currentStep;
  final PackageModel? package;
  final String? subjectId, paymentId, checkoutUrl, errorMessage;
  final String discountCode;
  final RenewalPaymentStatus? status;
  final PaymentAmountSummary? paymentSummary;
  final bool shouldOpenCheckout;
  bool get isGulf => args.registrationMode == 'gulf';
  bool get isEgyptianPrivate =>
      args.registrationMode == 'egyptian' &&
      args.subscription.accessScope == 'single_subject' &&
      args.subscription.packageType == 'hours';
  bool get isEgyptianMonthly =>
      args.registrationMode == 'egyptian' &&
      args.subscription.packageType == 'monthly';
  bool get hasSupportedRegistrationMode =>
      args.registrationMode == 'egyptian' || isGulf;
  bool get isSingleSubject => package?.accessScope == 'single_subject';
  int get lastStep => isEgyptianMonthly
      ? 0
      : isEgyptianPrivate
      ? 1
      : isGulf
      ? 1
      : isSingleSubject
      ? 2
      : 1;
  bool get isBusy =>
      phase == ParentRenewalPhase.submitting ||
      phase == ParentRenewalPhase.processing;

  ParentSubscriptionRenewalState copyWith({
    ParentRenewalPhase? phase,
    int? currentStep,
    Object? package = _unset,
    Object? subjectId = _unset,
    String? discountCode,
    Object? paymentId = _unset,
    Object? checkoutUrl = _unset,
    Object? status = _unset,
    Object? paymentSummary = _unset,
    bool? shouldOpenCheckout,
    Object? errorMessage = _unset,
  }) => ParentSubscriptionRenewalState(
    args: args,
    phase: phase ?? this.phase,
    currentStep: currentStep ?? this.currentStep,
    package: identical(package, _unset)
        ? this.package
        : package as PackageModel?,
    subjectId: identical(subjectId, _unset)
        ? this.subjectId
        : subjectId as String?,
    discountCode: discountCode ?? this.discountCode,
    paymentId: identical(paymentId, _unset)
        ? this.paymentId
        : paymentId as String?,
    checkoutUrl: identical(checkoutUrl, _unset)
        ? this.checkoutUrl
        : checkoutUrl as String?,
    status: identical(status, _unset)
        ? this.status
        : status as RenewalPaymentStatus?,
    paymentSummary: identical(paymentSummary, _unset)
        ? this.paymentSummary
        : paymentSummary as PaymentAmountSummary?,
    shouldOpenCheckout: shouldOpenCheckout ?? this.shouldOpenCheckout,
    errorMessage: identical(errorMessage, _unset)
        ? this.errorMessage
        : errorMessage as String?,
  );
}
