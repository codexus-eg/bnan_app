import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetClassroomSubjectsCubit extends Cubit<GetClassroomSubjectsState> {
  GetClassroomSubjectsCubit(this.assignmentsRepo)
    : super(GetClassroomSubjectsInitial());

  final AssignmentsRepo assignmentsRepo;
  String? _activeClassroomId;

  Future<void> getClassroomSubjects({required String classroomId}) async {
    _activeClassroomId = classroomId;
    emit(GetClassroomSubjectsLoading());

    final result = await assignmentsRepo.getClassroomSubjects(
      classroomId: classroomId,
    );

    if (isClosed || _activeClassroomId != classroomId) return;

    result.fold(
      (failure) {
        emit(GetClassroomSubjectsFailure(errorMessage: failure.message));
      },
      (classroomSubjects) {
        emit(GetClassroomSubjectsSuccess(classroomSubjects: classroomSubjects));
      },
    );
  }

  void clear() {
    _activeClassroomId = null;
    if (!isClosed) emit(GetClassroomSubjectsInitial());
  }
}
