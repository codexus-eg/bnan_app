import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/manager/splash_cubit/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (isClosed) return;

    final token = await SessionManager.instance.getAccessToken();

    if (isClosed) return;

    if (token != null && token.isNotEmpty) {
      final role = await SessionManager.instance.getUserRole();
      if (role == 'student') {
        emit(SplashNavigateToStudentHome());
      } else if (role == 'teacher') {
        emit(SplashNavigateToTeacherHome());
      } else if (role == 'parent') {
        emit(SplashNavigateToParentHome());
      } else {
        emit(SplashNavigateToOnboarding());
      }
    } else {
      emit(SplashNavigateToOnboarding());
    }
  }
}
