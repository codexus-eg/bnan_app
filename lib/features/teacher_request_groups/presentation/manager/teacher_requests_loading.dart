part of 'teacher_registration_requests_cubit.dart';

extension TeacherRequestsLoadingFlow on TeacherRegistrationRequestsCubit {
  Future<void> refresh() async {
    if (state is TeacherRequestsLoading ||
        _isLoadingMore ||
        _acceptingRequestId != null) {
      return;
    }
    _emitState(TeacherRequestsLoading());
    final result = await repo.getRequests(
      page: 1,
      limit: TeacherRegistrationRequestsCubit.limit,
    );
    result.fold(
      (failure) => _emitState(TeacherRequestsFailure(failure.message)),
      (response) {
        _pagination = response.pagination;
        _requests
          ..clear()
          ..addAll(_uniqueFirstPage(response.requests));
        _emitState(
          _requests.isEmpty
              ? TeacherRequestsEmpty()
              : TeacherRequestsSuccess(requests, _pagination),
        );
      },
    );
  }

  List<RegistrationRequestModel> _uniqueFirstPage(
    List<RegistrationRequestModel> items,
  ) {
    final ids = <String>{};
    return items.where((item) => ids.add(item.requestId)).toList();
  }
}
