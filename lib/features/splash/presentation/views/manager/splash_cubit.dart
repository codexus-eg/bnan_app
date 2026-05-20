import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  static SplashCubit get(context) =>BlocProvider.of(context);

  Future<void> checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 5));

    final token = CacheHelper.getData(key: 'token');

    if (token != null && token.toString().isNotEmpty) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}