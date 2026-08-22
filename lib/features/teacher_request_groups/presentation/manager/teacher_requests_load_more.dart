part of 'teacher_registration_requests_cubit.dart';

extension TeacherRequestsLoadMoreFlow on TeacherRegistrationRequestsCubit {
  Future<void> loadMore() async {
    if (isClosed ||
        _isLoadingMore ||
        !_pagination.hasNextPage ||
        state is TeacherRequestsLoading ||
        _acceptingRequestId != null) {
      return;
    }
    _isLoadingMore = true;
    _emitState(TeacherRequestsLoadingMore(requests, _pagination));
    final result = await repo.getRequests(
      page: _pagination.currentPage + 1,
      limit: TeacherRegistrationRequestsCubit.limit,
    );
    if (isClosed) {
      _isLoadingMore = false;
      return;
    }
    result.fold(
      (failure) => _emitState(
        TeacherRequestsLoadMoreFailure(requests, _pagination, failure.message),
      ),
      (response) {
        _pagination = response.pagination;
        _requests.addAll(_newItems(response.requests));
        _emitState(TeacherRequestsSuccess(requests, _pagination));
      },
    );
    _isLoadingMore = false;
  }

  List<RegistrationRequestModel> _newItems(
    List<RegistrationRequestModel> items,
  ) {
    final ids = _requests.map((item) => item.requestId).toSet();
    return items.where((item) => ids.add(item.requestId)).toList();
  }
}
