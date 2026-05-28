import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/manager/splash_cubit/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (isClosed) return;

    final token = CacheHelper.getData(key: 'token');

    if (isClosed) return;

    if (token != null && token.toString().isNotEmpty) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToOnboarding());
    }
  }
}