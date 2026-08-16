import 'package:bnan_app/features/student_groups/data/repo/student_groups_repo/student_groups_repo.dart';
import 'package:bnan_app/features/student_groups/presentation/manager/get_my_enrollments/get_my_enrollments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMyEnrollmentsCubit extends Cubit<GetMyEnrollmentsState> {
  GetMyEnrollmentsCubit(this.studentGroupsRepo)
    : super(GetMyEnrollmentsInitial());

  final StudentGroupsRepo studentGroupsRepo;
  int _requestId = 0;

  Future<void> getMyEnrollments() async {
    if (isClosed) return;
    final requestId = ++_requestId;
    emit(GetMyEnrollmentsLoading());

    final result = await studentGroupsRepo.getMyEnrollments();
    if (isClosed || requestId != _requestId) return;

    result.fold(
      (failure) {
        emit(GetMyEnrollmentsFailure(errorMessage: failure.message));
      },
      (response) {
        emit(GetMyEnrollmentsSuccess(enrollments: response.enrollments));
      },
    );
  }
}
