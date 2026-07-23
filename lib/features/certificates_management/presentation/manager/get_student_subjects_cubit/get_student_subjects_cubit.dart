import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_student_subjects_cubit/get_student_subjects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetStudentSubjectsCubit
    extends Cubit<GetStudentSubjectsState> {
  GetStudentSubjectsCubit(this.certificatesManagementRepo)
      : super(GetStudentSubjectsInitial());

  final CertificatesManagementRepo certificatesManagementRepo;

  Future<void> getStudentSubjects({
    required String classroomId,
    required String studentId,
  }) async {
    emit(GetStudentSubjectsLoading());

    final result =
        await certificatesManagementRepo.getStudentSubjects(
      classroomId: classroomId,
      studentId: studentId,
    );

    result.fold(
      (failure) {
        emit(GetStudentSubjectsFailure(failure.message));
      },
      (response) {
        emit(GetStudentSubjectsSuccess(response));
      },
    );
  }
  void reset() {
  emit(GetStudentSubjectsInitial());
}
}