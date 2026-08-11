import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_model.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_status.dart';
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
  bool _loadingMore = false;
  bool hasLoaded = false;
  AdminSubjectRequestStatus currentStatus =
      AdminSubjectRequestStatus.awaitingAdminApproval;

  Future<void> load({
    AdminSubjectRequestStatus? status,
    bool refresh = false,
  }) async {
    final nextStatus = status ?? currentStatus;
    final changed = nextStatus != currentStatus;
    currentStatus = nextStatus;
    if (refresh || changed) {
      _requests.clear();
      _page = 1;
    }
    emit(const AdminSubjectRequestsLoading());
    final result = await _repo.getRequests(
      status: currentStatus.apiValue,
      page: 1,
    );
    if (isClosed) return;
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
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore) return;
    _loadingMore = true;
    emit(
      AdminSubjectRequestsSuccess(
        requests: List.unmodifiable(_requests),
        isLoadingMore: true,
      ),
    );
    final result = await _repo.getRequests(
      status: currentStatus.apiValue,
      page: _page + 1,
    );
    if (isClosed) return;
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
