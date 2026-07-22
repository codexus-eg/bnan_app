import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo_impl.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/send_message_cubit/send_message_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: getIt<Dio>()),
  );

  // Repositories

  getIt.registerLazySingleton<AssignmentsRepo>(
    () => AssignmentsRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<StudentProfileRepo>(
    () => StudentProfileRepoImpl(apiConsumer: getIt()),
  );
  getIt.registerLazySingleton<TeacherProfileRepo>(
    () => TeacherProfileRepoImpl(apiConsumer: getIt()),
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
  getIt.registerLazySingleton<UsersManagementRepo>(
    () => UsersManagementRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<TeacherSubjectAssignmentRepo>(
    () => TeacherSubjectAssignmentRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<AcademicLookupsRepo>(
    () => AcademicLookupsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<ClassroomsRepo>(
    () => ClassroomsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<SubjectsRepo>(
    () => SubjectsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<ChatRepo>(
    () => ChatRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<CertificatesManagementRepo>(
    () => CertificatesManagementRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<TableManagementRepo>(
    () => TableManagementRepoImpl(getIt<ApiConsumer>()),
  );

  getIt.registerLazySingleton<GradesRepo>(() => GradesRepoImpl(getIt()));

  getIt.registerLazySingleton<TeacherRequestsRepo>(
    () => TeacherRequestsRepoImpl(getIt()),
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
  getIt.registerFactory<StudentProfileCubit>(
    () => StudentProfileCubit(getIt<StudentProfileRepo>()),
  );
  getIt.registerFactory<TeacherProfileCubit>(
    () => TeacherProfileCubit(getIt<TeacherProfileRepo>()),
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

  getIt.registerFactory<GetCurriculmSubjectsCubit>(
    () => GetCurriculmSubjectsCubit(getIt<AuthRepo>()),
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
  getIt.registerFactory<UsersManagementCubit>(
    () => UsersManagementCubit(getIt<UsersManagementRepo>()),
  );
  getIt.registerFactory<GetTeacherAssignmentsCubit>(
    () => GetTeacherAssignmentsCubit(getIt<AssignmentsRepo>()),
  );

  getIt.registerFactory<CreateAssignmentCubit>(
    () => CreateAssignmentCubit(getIt<AssignmentsRepo>()),
  );

  getIt.registerFactory<UpdateAssignmentCubit>(
    () => UpdateAssignmentCubit(getIt<AssignmentsRepo>()),
  );

  getIt.registerFactory<DeleteAssignmentCubit>(
    () => DeleteAssignmentCubit(getIt<AssignmentsRepo>()),
  );

  getIt.registerFactory<GetTeacherClassroomsCubit>(
    () => GetTeacherClassroomsCubit(getIt<AssignmentsRepo>()),
  );

  getIt.registerFactory<GetTeacherCurriculumsCubit>(
    () => GetTeacherCurriculumsCubit(getIt<AssignmentsRepo>()),
  );

  getIt.registerFactory<GetTeacherGradesCubit>(
    () => GetTeacherGradesCubit(getIt<AssignmentsRepo>()),
  );
  getIt.registerFactory<GetClassroomSubjectsCubit>(
    () => GetClassroomSubjectsCubit(getIt<AssignmentsRepo>()),
  );
  getIt.registerFactory<GetSubjectDetailsCubit>(
    () => GetSubjectDetailsCubit(getIt<AssignmentsRepo>()),
  );
  getIt.registerFactory<TeacherSubjectAssignmentsCubit>(
    () => TeacherSubjectAssignmentsCubit(getIt<TeacherSubjectAssignmentRepo>()),
  );
  getIt.registerFactory<TeacherSubjectAssignmentActionsCubit>(
    () => TeacherSubjectAssignmentActionsCubit(
      getIt<TeacherSubjectAssignmentRepo>(),
    ),
  );
  getIt.registerFactory<ClassroomsCubit>(
    () => ClassroomsCubit(getIt<ClassroomsRepo>()),
  );
  getIt.registerFactory<ClassroomActionsCubit>(
    () => ClassroomActionsCubit(getIt<ClassroomsRepo>()),
  );
  getIt.registerFactory<ClassroomDetailsCubit>(
    () => ClassroomDetailsCubit(getIt<ClassroomsRepo>()),
  );
  getIt.registerFactory<GetSubjectsCubit>(
    () => GetSubjectsCubit(getIt<SubjectsRepo>()),
  );
  getIt.registerFactory<SubjectActionsCubit>(
    () => SubjectActionsCubit(getIt<SubjectsRepo>()),
  );
  getIt.registerFactory<AcademicLookupsCubit>(
    () => AcademicLookupsCubit(repo: getIt<AcademicLookupsRepo>()),
  );
  getIt.registerFactory<GetGradesmanagementCubit>(
    () => GetGradesmanagementCubit(getIt()),
  );
  getIt.registerFactory<GradeActionsCubit>(() => GradeActionsCubit(getIt()));
  getIt.registerFactory<GetMonthlyCertificatesCubit>(
    () => GetMonthlyCertificatesCubit(getIt<CertificatesManagementRepo>()),
  );
  getIt.registerFactory<GetCertificateDetailsCubit>(
    () => GetCertificateDetailsCubit(getIt<CertificatesManagementRepo>()),
  );
  getIt.registerFactory<CreateMonthlyCertificateCubit>(
    () => CreateMonthlyCertificateCubit(getIt<CertificatesManagementRepo>()),
  );
  getIt.registerFactory<UpdateMonthlyCertificateCubit>(
    () => UpdateMonthlyCertificateCubit(getIt<CertificatesManagementRepo>()),
  );
  getIt.registerFactory<IssueMonthlyCertificatesCubit>(
    () => IssueMonthlyCertificatesCubit(getIt<CertificatesManagementRepo>()),
  );
  getIt.registerFactory<DeleteMonthlyCertificateCubit>(
    () => DeleteMonthlyCertificateCubit(getIt<CertificatesManagementRepo>()),
  );
  getIt.registerFactory<GetEgyptianSchedulesCubit>(
    () => GetEgyptianSchedulesCubit(getIt<TableManagementRepo>()),
  );
  getIt.registerFactory<CreateEgyptianScheduleCubit>(
    () => CreateEgyptianScheduleCubit(getIt<TableManagementRepo>()),
  );
  getIt.registerFactory<DeleteEgyptianScheduleCubit>(
    () => DeleteEgyptianScheduleCubit(getIt<TableManagementRepo>()),
  );
  getIt.registerFactory<GetEgyptianScheduleByClassroomCubit>(
    () => GetEgyptianScheduleByClassroomCubit(getIt<TableManagementRepo>()),
  );

  getIt.registerFactory<PendingTeacherRequestsCubit>(
    () => PendingTeacherRequestsCubit(getIt()),
  );

  getIt.registerFactory<TeacherDetailsCubit>(
    () => TeacherDetailsCubit(getIt()),
  );

  getIt.registerFactory<TeacherRequestActionsCubit>(
    () => TeacherRequestActionsCubit(getIt()),
  );
  getIt.registerFactory<GetChatRoomsCubit>(
    () => GetChatRoomsCubit(getIt<ChatRepo>()),
  );
  getIt.registerFactory<GetRoomMessagesCubit>(
    () => GetRoomMessagesCubit(getIt<ChatRepo>(), getIt<SocketService>()),
  );
  getIt.registerLazySingleton<SocketService>(() => SocketService());
  getIt.registerFactory<SendMessageCubit>(
    () => SendMessageCubit(getIt<ChatRepo>()),
  );
}
