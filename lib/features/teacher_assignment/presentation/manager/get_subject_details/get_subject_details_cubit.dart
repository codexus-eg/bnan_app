import 'package:bnan_app/features/teacher_assignment/data/model/subject_details_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_subject_details/get_subject_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetSubjectDetailsCubit extends Cubit<GetSubjectDetailsState> {
  GetSubjectDetailsCubit(this.assignmentsRepo)
    : super(GetSubjectDetailsInitial());

  final AssignmentsRepo assignmentsRepo;

  List<String> _lastSubjectIds = [];
  int _requestVersion = 0;

  Future<void> getSubjectsDetails({required List<String> subjectIds}) async {
    if (isClosed) return;

    if (subjectIds.isEmpty) {
      _lastSubjectIds = [];
      _requestVersion++;
      emit(GetSubjectDetailsSuccess(subjects: const []));
      return;
    }

    if (_isSameSubjects(subjectIds)) return;

    _lastSubjectIds = List.from(subjectIds);
    final requestVersion = ++_requestVersion;

    emit(GetSubjectDetailsLoading());

    final subjects = <SubjectDetailsModel>[];

    for (final subjectId in subjectIds) {
      if (isClosed || requestVersion != _requestVersion) return;

      final result = await assignmentsRepo.getSubjectDetails(
        subjectId: subjectId,
      );

      if (isClosed || requestVersion != _requestVersion) return;

      final hasFailure = result.fold(
        (failure) {
          emit(GetSubjectDetailsFailure(errorMessage: failure.message));
          return true;
        },
        (subject) {
          subjects.add(subject);
          return false;
        },
      );

      if (hasFailure) return;
    }

    if (isClosed || requestVersion != _requestVersion) return;

    emit(GetSubjectDetailsSuccess(subjects: subjects));
  }

  bool _isSameSubjects(List<String> subjectIds) {
    if (_lastSubjectIds.length != subjectIds.length) return false;

    for (var i = 0; i < subjectIds.length; i++) {
      if (_lastSubjectIds[i] != subjectIds[i]) return false;
    }

    return true;
  }

  void clear() {
    _requestVersion++;
    _lastSubjectIds = [];

    if (!isClosed) {
      emit(GetSubjectDetailsInitial());
    }
  }
}
