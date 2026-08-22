import 'package:bnan_app/features/classroom_change_requests/data/repo/classroom_change_requests_repo.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminChangeRequestsCubit extends Cubit<AdminChangeRequestsState> {
  AdminChangeRequestsCubit(this._repo)
    : super(const AdminChangeRequestsInitial());
  final ClassroomChangeRequestsRepo _repo;
  bool hasLoaded = false;

  Future<void> load() async {
    emit(const AdminChangeRequestsLoading());
    final result = await _repo.getAdminRequests();
    if (isClosed) return;
    result.fold(
      (failure) => emit(AdminChangeRequestsFailure(failure.message)),
      (page) {
        hasLoaded = true;
        emit(AdminChangeRequestsSuccess(page.requests));
      },
    );
  }

  getDetails(String id) => _repo.getAdminRequest(id);
}
