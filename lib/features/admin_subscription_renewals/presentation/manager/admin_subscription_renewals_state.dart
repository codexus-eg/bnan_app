import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_renewal_status.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_subscription_renewal_model.dart';

class AdminSubscriptionRenewalsState {
  const AdminSubscriptionRenewalsState({
    this.status = AdminRenewalStatus.pending,
    this.items = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.loading = false,
    this.loadingMore = false,
    this.processingPaymentId,
    this.error,
    this.loadMoreError,
    this.actionError,
  });

  final AdminRenewalStatus status;
  final List<AdminSubscriptionRenewalModel> items;
  final int currentPage, lastPage;
  final bool loading, loadingMore;
  final String? processingPaymentId, error, loadMoreError, actionError;
  bool get canLoadMore => !loadingMore && currentPage < lastPage;

  AdminSubscriptionRenewalsState copyWith({
    AdminRenewalStatus? status,
    List<AdminSubscriptionRenewalModel>? items,
    int? currentPage,
    int? lastPage,
    bool? loading,
    bool? loadingMore,
    String? processingPaymentId,
    String? error,
    String? loadMoreError,
    String? actionError,
    bool clearProcessing = false,
    bool clearErrors = false,
  }) => AdminSubscriptionRenewalsState(
    status: status ?? this.status,
    items: items ?? this.items,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    processingPaymentId: clearProcessing
        ? null
        : processingPaymentId ?? this.processingPaymentId,
    error: clearErrors ? null : error ?? this.error,
    loadMoreError: clearErrors ? null : loadMoreError ?? this.loadMoreError,
    actionError: clearErrors ? null : actionError ?? this.actionError,
  );
}
