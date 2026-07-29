import 'package:bnan_app/features/registration_requests/data/models/registration_request_filter.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_requests_pagination_model.dart';
import 'package:bnan_app/features/registration_requests/data/repo/registration_requests_repo.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/get_registration_requests_cubit/get_registration_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetRegistrationRequestsCubit extends Cubit<GetRegistrationRequestsState> {
  GetRegistrationRequestsCubit(this.registrationRequestsRepo)
    : super(GetRegistrationRequestsInitial());

  final RegistrationRequestsRepo registrationRequestsRepo;
  final List<RegistrationRequestModel> _requests = [];

  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoadingMore = false;
  int _requestId = 0;
  RegistrationRequestFilter currentFilter = RegistrationRequestFilter.pending;
  RegistrationRequestsPaginationModel _pagination =
      const RegistrationRequestsPaginationModel(
        currentPage: 1,
        perPage: 0,
        total: 0,
        lastPage: 1,
      );

  List<RegistrationRequestModel> get requests => List.unmodifiable(_requests);
  bool get canLoadMore => !_isLoadingMore && _currentPage < _lastPage;

  Future<void> getRegistrationRequests({
    RegistrationRequestFilter? filter,
    bool refresh = false,
  }) async {
    final nextFilter = filter ?? currentFilter;
    final filterChanged = nextFilter != currentFilter;
    currentFilter = nextFilter;
    final requestId = ++_requestId;
    _isLoadingMore = false;
    if (refresh || filterChanged) _reset();
    emit(GetRegistrationRequestsLoading());

    final result = await registrationRequestsRepo
        .getEgyptianRegistrationRequests(status: currentFilter.apiValue);
    if (isClosed || requestId != _requestId) return;

    result.fold(
      (failure) =>
          emit(GetRegistrationRequestsFailure(errorMessage: failure.message)),
      (response) {
        _requests
          ..clear()
          ..addAll(response.requests);
        _setPagination(response.pagination);
        emit(_success());
      },
    );
  }

  Future<void> loadMore() async {
    if (!canLoadMore) return;
    _isLoadingMore = true;
    final requestId = _requestId;
    final nextPage = _currentPage + 1;
    emit(
      GetRegistrationRequestsLoadingMore(
        requests: requests,
        pagination: _pagination,
      ),
    );

    try {
      final result = await registrationRequestsRepo
          .getEgyptianRegistrationRequests(
            status: currentFilter.apiValue,
            page: nextPage,
          );
      if (isClosed || requestId != _requestId) return;
      _isLoadingMore = false;

      result.fold(
        (failure) => emit(
          GetRegistrationRequestsLoadMoreFailure(
            requests: requests,
            pagination: _pagination,
            errorMessage: failure.message,
          ),
        ),
        (response) {
          _appendUnique(response.requests);
          _setPagination(response.pagination);
          emit(_success());
        },
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  void _appendUnique(List<RegistrationRequestModel> newRequests) {
    _requests.addAll(
      newRequests.where(
        (item) => !_requests.any((old) => old.studentId == item.studentId),
      ),
    );
  }

  void _setPagination(RegistrationRequestsPaginationModel pagination) {
    _pagination = pagination;
    _currentPage = pagination.currentPage;
    _lastPage = pagination.lastPage;
  }

  GetRegistrationRequestsSuccess _success() {
    return GetRegistrationRequestsSuccess(
      requests: requests,
      pagination: _pagination,
    );
  }

  void _reset() {
    _requests.clear();
    _currentPage = 1;
    _lastPage = 1;
    _pagination = const RegistrationRequestsPaginationModel(
      currentPage: 1,
      perPage: 0,
      total: 0,
      lastPage: 1,
    );
  }
}
