import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/dio_consumer.dart';
import 'package:bnan_app/features/auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/auth/data/repo/auth_repo_impl.dart';
import 'package:bnan_app/features/auth/presentation/manager/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:bnan_app/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:bnan_app/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/auth/presentation/manager/reset_password_cubit/reset_password_cubit.dart';
import 'package:bnan_app/features/auth/presentation/manager/update_password_cubit/update_password_cubit.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );

  // Cubits

  getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit());

  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<AuthRepo>()));

  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt<AuthRepo>()));

  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(getIt<AuthRepo>()),
  );

  getIt.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(getIt<AuthRepo>()),
  );

  getIt.registerFactory<UpdatePasswordCubit>(
    () => UpdatePasswordCubit(getIt<AuthRepo>()),
  );
}
