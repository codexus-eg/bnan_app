import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_model.dart';
import 'package:bnan_app/features/admin_subject_requests/data/repo/admin_subject_requests_repo.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSubjectRequestsCubit extends Cubit<AdminSubjectRequestsState> {
  AdminSubjectRequestsCubit(this._repo)
    : super(const AdminSubjectRequestsInitial());
  final AdminSubjectRequestsRepo _repo;
  final List<AdminSubjectRequestModel> _requests = [];
  int _page = 1;
  bool _hasMore = false;
  bool _loading = false;
  bool _loadingMore = false;
  int _requestVersion = 0;
  bool hasLoaded = false;
  Future<void> load({bool refresh = false}) async {
    if (isClosed || (_loading && !refresh)) return;
    final version = ++_requestVersion;
    _loading = true;
    if (refresh) {
      _requests.clear();
      _page = 1;
    }
    emit(const AdminSubjectRequestsLoading());
    try {
      final result = await _repo.getRequests(page: 1);
      if (isClosed || version != _requestVersion) return;
      result.fold(
        (failure) => emit(AdminSubjectRequestsFailure(failure.message)),
        (page) {
          _requests
            ..clear()
            ..addAll(page.requests);
          _page = page.page;
          _hasMore = page.hasMore;
          hasLoaded = true;
          emit(
            AdminSubjectRequestsSuccess(requests: List.unmodifiable(_requests)),
          );
        },
      );
    } finally {
      if (version == _requestVersion) _loading = false;
    }
  }

  Future<void> loadMore() async {
    if (isClosed || _loadingMore || !_hasMore) return;
    _loadingMore = true;
    final version = _requestVersion;
    emit(
      AdminSubjectRequestsSuccess(
        requests: List.unmodifiable(_requests),
        isLoadingMore: true,
      ),
    );
    final result = await _repo.getRequests(page: _page + 1);
    if (isClosed || version != _requestVersion) {
      _loadingMore = false;
      return;
    }
    _loadingMore = false;
    result.fold(
      (failure) => emit(
        AdminSubjectRequestsSuccess(
          requests: List.unmodifiable(_requests),
          loadMoreError: failure.message,
        ),
      ),
      (page) {
        for (final request in page.requests) {
          if (_requests.every((old) => old.id != request.id)) {
            _requests.add(request);
          }
        }
        _page = page.page;
        _hasMore = page.hasMore;
        emit(
          AdminSubjectRequestsSuccess(requests: List.unmodifiable(_requests)),
        );
      },
    );
  }
}
