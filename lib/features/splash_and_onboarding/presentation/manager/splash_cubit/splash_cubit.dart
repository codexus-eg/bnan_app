import 'package:bnan_app/core/cache/secure_cache_helper.dart';
import 'package:bnan_app/core/cache/secure_cache_keys.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/manager/splash_cubit/splash_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkUserStatus() async {
    debugPrint('Splash session loading started');
    await SessionManager.instance.loadSession();

    debugPrint(
      'Splash cached token exists: '
      '${SessionManager.instance.accessToken?.isNotEmpty == true}',
    );
    debugPrint('Splash cached role: ${SessionManager.instance.userRole}');

    final directStoredToken = await SecureCacheHelper.getData(
      key: SecureCacheKeys.accessToken,
    );
    debugPrint(
      'Splash direct stored token exists: '
      '${directStoredToken != null && directStoredToken.isNotEmpty}',
    );

    await Future.delayed(const Duration(seconds: 2));

    if (isClosed) return;

    final token = SessionManager.instance.accessToken;

    if (isClosed) return;

    if (token != null && token.isNotEmpty) {
      final role = await SessionManager.instance.getUserRole();
      if (role == 'student') {
        emit(SplashNavigateToStudentHome());
      } else if (role == 'teacher') {
        emit(SplashNavigateToTeacherHome());
      } else if (role == 'parent') {
        emit(SplashNavigateToParentHome());
      } else if (role == 'admin') {
        emit(SplashNavigateToAdminHome());
      } else {
        emit(SplashNavigateToOnboarding());
      }
    } else {
      emit(SplashNavigateToOnboarding());
    }
  }
}
