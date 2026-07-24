import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetClassroomStudentsCubit
    extends Cubit<GetClassroomStudentsState> {
  GetClassroomStudentsCubit(this.certificatesManagementRepo)
      : super(GetClassroomStudentsInitial());

  final CertificatesManagementRepo certificatesManagementRepo;

  Future<void> getClassroomStudents({
    required String classroomId,
  }) async {
    emit(GetClassroomStudentsLoading());

    final result =
        await certificatesManagementRepo.getClassroomStudents(
      classroomId: classroomId,
    );

    result.fold(
      (failure) {
        emit(GetClassroomStudentsFailure(failure.message));
      },
      (response) {
        emit(GetClassroomStudentsSuccess(response));
      },
    );
  }
  void reset() {
  emit(GetClassroomStudentsInitial());
}
}