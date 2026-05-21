import 'package:bnan_app/features/auth/presentation/views/manager/student_registration_cubit/student_registration_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerFactory<StudentRegistrationCubit>(
    () => StudentRegistrationCubit(),
  );
}
