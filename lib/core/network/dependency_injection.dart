import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/features/teacher_registration/data/repo/teacher_registration_repo.dart';
import 'package:bnan_app/features/teacher_registration/data/repo/teacher_registration_repo_impl.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';

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
  getIt.registerLazySingleton<StudentProfileRepo>(
    () => StudentProfileRepoImpl(
      apiConsumer: getIt<ApiConsumer>(),
      localDataSource: getIt<StudentProfileLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<StudentProfileLocalDataSource>(
    () => StudentProfileLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<StudentAssignmentsRepo>(
    () => StudentAssignmentsRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<HomeStudentRepo>(
    () => HomeStudentRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<StudentGroupsRepo>(
    () => StudentGroupsRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
   getIt.registerLazySingleton<TeacherRegistrationRepo>(
    () => TeacherRegistrationRepoImpl(apiConsumer: getIt<ApiConsumer>()),
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
    () => UpdatePasswordCubit(getIt<StudentProfileRepo>()),
  );
  getIt.registerFactory<GetLoggedUserCubit>(
    () => GetLoggedUserCubit(getIt<StudentProfileRepo>()),
  );
  getIt.registerFactory<UpdateNameCubit>(
    () => UpdateNameCubit(getIt<StudentProfileRepo>()),
  );
  getIt.registerFactory<UpdatePhoneCubit>(
    () => UpdatePhoneCubit(getIt<StudentProfileRepo>()),
  );
  getIt.registerFactory<GetCurriculumsCubit>(
    () => GetCurriculumsCubit(getIt<AuthRepo>()),
  );
  getIt.registerFactory<GetPackagesCubit>(
    () => GetPackagesCubit(getIt<AuthRepo>()),
  );
  getIt.registerFactory<GetGradesCubit>(
    () => GetGradesCubit(getIt<AuthRepo>()),
  );

  getIt.registerFactory<GetSubjectsCubit>(
    () => GetSubjectsCubit(getIt<AuthRepo>()),
  );
  getIt.registerFactory<GetAssignmentsCubit>(
    () => GetAssignmentsCubit(getIt<StudentAssignmentsRepo>()),
  );
  getIt.registerFactory<SubmitAssignmentCubit>(
    () => SubmitAssignmentCubit(getIt<StudentAssignmentsRepo>()),
  );
  getIt.registerFactory<GetStudentSubscriptionCubit>(
    () => GetStudentSubscriptionCubit(getIt<HomeStudentRepo>()),
  );
  getIt.registerFactory<GetMyEnrollmentsCubit>(
    () => GetMyEnrollmentsCubit(getIt<StudentGroupsRepo>()),
  );
   getIt.registerFactory<TeacherRegistrationCubit>(
    () => TeacherRegistrationCubit(getIt<TeacherRegistrationRepo>()),
  );
}
