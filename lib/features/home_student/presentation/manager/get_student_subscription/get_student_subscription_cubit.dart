import 'package:bnan_app/features/home_student/data/repo/home_student_repo/home_student_repo.dart';
import 'package:bnan_app/features/home_student/presentation/manager/get_student_subscription/get_student_subscription_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetStudentSubscriptionCubit extends Cubit<GetStudentSubscriptionState> {
  GetStudentSubscriptionCubit(this.homeStudentRepo)
    : super(GetStudentSubscriptionInitial());

  final HomeStudentRepo homeStudentRepo;

  Future<void> getStudentSubscription() async {
    emit(GetStudentSubscriptionLoading());

    final result = await homeStudentRepo.getStudentSubscription();

    result.fold(
      (failure) {
        emit(
          GetStudentSubscriptionFailure(
            errorMessage: failure.message,
          ),
        );
      },
      (subscription) {
        emit(
          GetStudentSubscriptionSuccess(
            subscription: subscription,
          ),
        );
      },
    );
  }
}