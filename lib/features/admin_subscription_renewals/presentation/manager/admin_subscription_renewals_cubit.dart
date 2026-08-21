import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_renewal_status.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_subscription_renewals_page.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/repo/admin_subscription_renewals_repo.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/manager/admin_subscription_renewals_state.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/policies/admin_renewal_error_mapper.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSubscriptionRenewalsCubit
    extends Cubit<AdminSubscriptionRenewalsState> {
  AdminSubscriptionRenewalsCubit(this._repo)
    : super(const AdminSubscriptionRenewalsState());
  final AdminSubscriptionRenewalsRepo _repo;
  int _revision = 0;

  Future<void> load({bool refresh = false}) =>
      _fetch(state.status, page: 1, replace: true);

  Future<void> selectStatus(AdminRenewalStatus status) async {
    if (status == state.status && !state.loading) return;
    emit(AdminSubscriptionRenewalsState(status: status, loading: true));
    await _fetch(status, page: 1, replace: true, loadingEmitted: true);
  }

  Future<void> loadMore() async {
    if (!state.canLoadMore || state.loading) return;
    await _fetch(state.status, page: state.currentPage + 1, replace: false);
  }

  Future<void> confirm(String paymentId) =>
      _action(paymentId, () => _repo.confirm(paymentId));
  Future<void> approve(String paymentId) =>
      _action(paymentId, () => _repo.approve(paymentId));
  Future<void> reject(String paymentId, {String? reason}) => _action(
    paymentId,
    () => _repo.reject(paymentId, rejectionReason: reason),
  );

  Future<void> _fetch(
    AdminRenewalStatus status, {
    required int page,
    required bool replace,
    bool loadingEmitted = false,
  }) async {
    final revision = replace ? ++_revision : _revision;
    if (!loadingEmitted) {
      emit(
        state.copyWith(
          loading: replace,
          loadingMore: !replace,
          clearErrors: true,
        ),
      );
    }
    final result = await _repo.getRenewals(status: status, page: page);
    if (isClosed || revision != _revision || status != state.status) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          loading: false,
          loadingMore: false,
          error: replace ? mapAdminRenewalFailure(failure) : null,
          loadMoreError: replace ? null : mapAdminRenewalFailure(failure),
        ),
      ),
      (value) => _applyPage(value, replace),
    );
  }

  void _applyPage(AdminSubscriptionRenewalsPage page, bool replace) {
    final items = replace ? [...page.items] : [...state.items];
    if (!replace) {
      for (final item in page.items) {
        if (items.every((old) => old.id != item.id)) items.add(item);
      }
    }
    emit(
      state.copyWith(
        items: items,
        currentPage: page.currentPage,
        lastPage: page.lastPage,
        loading: false,
        loadingMore: false,
        clearErrors: true,
      ),
    );
  }

  Future<void> _action(
    String paymentId,
    Future<Either<Failure, void>> Function() call,
  ) async {
    if (state.processingPaymentId != null) return;
    emit(state.copyWith(processingPaymentId: paymentId, clearErrors: true));
    final result = await call();
    if (isClosed) return;
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          actionError: mapAdminRenewalFailure(failure),
          clearProcessing: true,
        ),
      ),
      (_) async {
        await load(refresh: true);
        if (!isClosed) emit(state.copyWith(clearProcessing: true));
      },
    );
  }
}
