import 'package:bnan_app/features/student_groups/data/repo/student_groups_repo/student_groups_repo.dart';
import 'package:bnan_app/features/student_groups/presentation/manager/get_my_enrollments/get_my_enrollments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMyEnrollmentsCubit extends Cubit<GetMyEnrollmentsState> {
  GetMyEnrollmentsCubit(this.studentGroupsRepo)
      : super(GetMyEnrollmentsInitial());

  final StudentGroupsRepo studentGroupsRepo;

  Future<void> getMyEnrollments() async {
    emit(GetMyEnrollmentsLoading());

    final result = await studentGroupsRepo.getMyEnrollments();

    result.fold(
      (failure) {
        emit(
          GetMyEnrollmentsFailure(
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          GetMyEnrollmentsSuccess(
            enrollments: response.enrollments,
          ),
        );
      },
    );
  }
}