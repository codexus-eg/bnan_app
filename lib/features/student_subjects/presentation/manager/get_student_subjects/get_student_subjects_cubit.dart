import 'package:bnan_app/features/student_subjects/data/repo/student_subjects_repo.dart';
import 'package:bnan_app/features/student_subjects/presentation/manager/get_student_subjects/get_student_subjects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMySubjectsCubit extends Cubit<GetMySubjectsState> {
  GetMySubjectsCubit(this.repo) : super(GetMySubjectsInitial());

  final StudentSubjectsRepo repo;
  bool _loading = false;

  Future<void> loadSubjects() async {
    if (_loading || isClosed) return;
    _loading = true;
    emit(GetMySubjectsLoading());
    final result = await repo.getMySubjects();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        failure.statusCode == 401
            ? GetMySubjectsUnauthorized()
            : GetMySubjectsFailure(failure.message),
      ),
      (subjects) => emit(
        subjects.isEmpty
            ? GetMySubjectsEmpty()
            : GetMySubjectsSuccess(subjects),
      ),
    );
    _loading = false;
  }

  Future<void> retry() => loadSubjects();
}
