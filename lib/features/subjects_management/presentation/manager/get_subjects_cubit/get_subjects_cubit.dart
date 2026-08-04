import 'package:bnan_app/features/subjects_management/data/repo/subjects_repo.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetSubjectsCubit extends Cubit<GetSubjectsState> {
  GetSubjectsCubit(this.subjectsRepo, {this.initialPerPage = 10})
    : _perPage = initialPerPage,
      super(GetSubjectsInitial());

  final SubjectsRepo subjectsRepo;
  final int initialPerPage;
  int _currentPage = 1;
  int _perPage;
  int _lastPage = 1;
  SubjectsResponseModel? _subjects;

  int get currentPage => _currentPage;
  int get perPage => _perPage;
  int get lastPage => _lastPage;
  SubjectsResponseModel? get subjects => _subjects;
  bool get isLoading => state is GetSubjectsLoading;

  Future<void> getSubjects({int? page}) async {
    if (isLoading) return;
    final requestedPage = page ?? _currentPage;
    emit(GetSubjectsLoading());
    final result = await subjectsRepo.getSubjects(
      page: requestedPage,
      perPage: _perPage,
    );

    result.fold(
      (failure) => emit(GetSubjectsFailure(errorMessage: failure.message)),
      (subjects) {
        _subjects = subjects;
        final pagination = subjects.pagination;
        _currentPage = pagination.currentPage > 0
            ? pagination.currentPage
            : requestedPage;
        if (pagination.perPage > 0) _perPage = pagination.perPage;
        _lastPage = pagination.lastPage > 0 ? pagination.lastPage : 1;
        emit(GetSubjectsSuccess(subjects: subjects));
      },
    );
  }

  Future<void> nextPage() {
    if (_currentPage >= _lastPage) return Future.value();
    return getSubjects(page: _currentPage + 1);
  }

  Future<void> previousPage() {
    if (_currentPage <= 1) return Future.value();
    return getSubjects(page: _currentPage - 1);
  }

  Future<void> reloadCurrentPage() => getSubjects(page: _currentPage);

  Future<void> reloadAfterDelete({required int deletedPageItemCount}) {
    final target = _currentPage > 1 && deletedPageItemCount <= 1
        ? _currentPage - 1
        : _currentPage;
    return getSubjects(page: target);
  }
}
