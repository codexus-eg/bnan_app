import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/data/repo/subjects_repo.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetSubjectsCubit extends Cubit<GetSubjectsState> {
  GetSubjectsCubit(this.subjectsRepo) : super(GetSubjectsInitial());

  static const int limit = 10;
  final SubjectsRepo subjectsRepo;
  final List<SubjectModel> _subjects = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  List<SubjectModel> get subjects => List.unmodifiable(_subjects);
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> getSubjects() => refreshSubjects();

  Future<void> refreshSubjects() async {
    if (state is GetSubjectsLoading || _isLoadingMore) return;
    emit(GetSubjectsLoading());
    final result = await subjectsRepo.getSubjects(page: 1, limit: limit);
    result.fold(
      (failure) => emit(GetSubjectsFailure(errorMessage: failure.message)),
      (response) {
        _subjects
          ..clear()
          ..addAll(_unique(response.data));
        _currentPage = 1;
        _hasMore = response.length == limit;
        emit(GetSubjectsSuccess(subjects: subjects));
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || state is GetSubjectsLoading) return;
    _isLoadingMore = true;
    emit(GetSubjectsLoadingMore(subjects: subjects));
    final nextPage = _currentPage + 1;
    final result = await subjectsRepo.getSubjects(page: nextPage, limit: limit);
    result.fold(
      (failure) {
        _isLoadingMore = false;
        emit(
          GetSubjectsLoadMoreFailure(
            subjects: subjects,
            message: failure.message,
          ),
        );
      },
      (response) {
        _isLoadingMore = false;
        _hasMore = response.length == limit;
        if (response.data.isNotEmpty) {
          _subjects.addAll(_unique(response.data, existing: _subjects));
          _currentPage = nextPage;
        }
        emit(GetSubjectsSuccess(subjects: subjects));
      },
    );
  }

  List<SubjectModel> _unique(
    List<SubjectModel> items, {
    List<SubjectModel> existing = const [],
  }) {
    final ids = existing
        .map((item) => item.id)
        .where((id) => id.isNotEmpty)
        .toSet();
    return items.where((item) => item.id.isEmpty || ids.add(item.id)).toList();
  }
}
