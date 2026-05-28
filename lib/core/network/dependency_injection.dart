import 'package:bnan_app/features/auth/presentation/views/manager/student_registration_cubit/student_registration_cubit.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerFactory<StudentRegistrationCubit>(
    () => StudentRegistrationCubit(),
  );
   getIt.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(),
  );
}
