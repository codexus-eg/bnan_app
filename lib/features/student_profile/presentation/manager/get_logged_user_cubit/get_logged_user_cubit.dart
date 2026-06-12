import 'package:bnan_app/features/student_profile/data/repo/student_profile_repo.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/get_logged_user_cubit/get_logged_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetLoggedUserCubit extends Cubit<GetLoggedUserState> {
  GetLoggedUserCubit(this.studentProfileRepo) : super(GetLoggedUserInitial());

  final StudentProfileRepo studentProfileRepo;
  static GetLoggedUserCubit get(context) => BlocProvider.of(context);
  
  Future<void> refreshLoggedUserOnly() async {
    final result = await studentProfileRepo.refreshLoggedUser();

    result.fold(
      (failure) {
        emit(GetLoggedUserFailure(errorMessage: failure.message));
      },
      (response) {
        emit(
          GetLoggedUserSuccess(
            loggedUser: response.loggedUser,
            isFromCache: false,
            isRefreshing: false,
          ),
        );
      },
    );
  }

  Future<void> getLoggedUser() async {
    final cachedUser = await studentProfileRepo.getCachedLoggedUser();

    if (cachedUser != null) {
      emit(
        GetLoggedUserSuccess(
          loggedUser: cachedUser.loggedUser,
          isFromCache: true,
          isRefreshing: true,
        ),
      );
    } else {
      emit(GetLoggedUserLoading());
    }

    final result = await studentProfileRepo.refreshLoggedUser();

    result.fold(
      (failure) {
        if (cachedUser == null) {
          emit(GetLoggedUserFailure(errorMessage: failure.message));
        } else {
          emit(
            GetLoggedUserSuccess(
              loggedUser: cachedUser.loggedUser,
              isFromCache: true,
              isRefreshing: false,
            ),
          );
        }
      },
      (response) {
        emit(
          GetLoggedUserSuccess(
            loggedUser: response.loggedUser,
            isFromCache: false,
            isRefreshing: false,
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    await studentProfileRepo.logout();
  }
}
