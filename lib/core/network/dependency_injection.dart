import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_student_subjects_cubit/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo_impl.dart';
import 'package:bnan_app/features/chats/data/repo/classroom_documents_repo.dart';
import 'package:bnan_app/features/chats/data/repo/classroom_documents_repo_impl.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_recordings_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_summaries_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/message_documents_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/send_message_cubit/send_message_cubit.dart';
import 'package:bnan_app/features/curriculum_management/data/repo/curriculum_management_repo.dart';
import 'package:bnan_app/features/curriculum_management/data/repo/curriculum_management_repo_impl.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/curriculum_actions_cubit/curriculum_actions_cubit.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart'
    as curriculum_management;
import 'package:bnan_app/features/packages_management/data/repo/package_actions_repo/package_actions_repo.dart';
import 'package:bnan_app/features/packages_management/data/repo/package_actions_repo/package_actions_repo_impl.dart';
import 'package:bnan_app/features/packages_management/data/repo/packages_repo/packages_repo.dart';
import 'package:bnan_app/features/packages_management/data/repo/packages_repo/packages_repo_impl.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_form_cubit/package_form_cubit.dart';
import 'package:bnan_app/features/payments/data/payment_draft_store.dart';
import 'package:bnan_app/features/payments/data/repo/tamara_payment_repo.dart';
import 'package:bnan_app/features/payments/data/repo/tamara_payment_repo_impl.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo_impl.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/weekly_evaluations_read_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/weekly_evaluations_read_repo_impl.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: getIt<Dio>()),
  );

  // Repositories

  getIt.registerLazySingleton<PackagesRepo>(
    () => PackagesRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<TamaraPaymentRepo>(
    () => TamaraPaymentRepoImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<GulfParentAuthRepo>(
    () => GulfParentAuthRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<PaymentDraftStore>(PaymentDraftStore.new);

  getIt.registerLazySingleton<PackageActionsRepo>(
    () => PackageActionsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<CurriculumManagementRepo>(
    () => CurriculumManagementRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<RegistrationRequestsRepo>(
    () => RegistrationRequestsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<AssignmentsRepo>(
    () => AssignmentsRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<ParentAuthRepo>(
    () => ParentAuthRepoImpl(apiConsumer: getIt<ApiConsumer>()),
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
  getIt.registerLazySingleton<StudentCertificatesRepo>(
    () => StudentCertificatesRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<StudentSubjectsRepo>(
    () => StudentSubjectsRepoImpl(getIt<ApiConsumer>()),
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
  getIt.registerLazySingleton<ClassroomDocumentsRepo>(
    () => ClassroomDocumentsRepoImpl(getIt<ApiConsumer>()),
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
  getIt.registerLazySingleton<StudentClassroomAssignmentRepo>(
    () => StudentClassroomAssignmentRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<PlansRepo>(
    () => PlansRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<ParentHomeRepo>(
    () => ParentHomeRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<SupervisorManagementRepo>(
    () => SupervisorManagementRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<WeeklyEvaluationsRepo>(
    () => WeeklyEvaluationsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<WeeklyEvaluationsReadRepo>(
    () => WeeklyEvaluationsReadRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<SupervisorAssignmentRepo>(
    () => SupervisorAssignmentRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<AttendanceRepo>(
    () => AttendanceRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<GulfScheduleRepo>(
    () => GulfScheduleRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<StartSessionRepo>(
    () => StartSessionRepoImpl(getIt<ApiConsumer>()),
  );
  // Cubits
  getIt.registerFactory<GetPackagesCubit>(
    () => GetPackagesCubit(getIt<PackagesRepo>()),
  );
  getIt.registerFactory<PackageFormCubit>(() => PackageFormCubit());
  getIt.registerFactory<AttendanceCubit>(
    () => AttendanceCubit(getIt<AttendanceRepo>()),
  );
  getIt.registerFactory<GulfScheduleCubit>(
    () => GulfScheduleCubit(getIt<GulfScheduleRepo>()),
  );
  getIt.registerFactory<StartSessionCubit>(
    () => StartSessionCubit(getIt<StartSessionRepo>()),
  );
  getIt.registerFactory<curriculum_management.GetCurriculumsCubit>(
    () => curriculum_management.GetCurriculumsCubit(
      getIt<CurriculumManagementRepo>(),
    ),
  );
  getIt.registerFactory<CurriculumActionsCubit>(
    () => CurriculumActionsCubit(getIt<CurriculumManagementRepo>()),
  );

  getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit());

  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<AuthRepo>()));

  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(getIt<AuthRepo>(), getIt<GulfParentAuthRepo>()),
  );
  getIt.registerLazySingleton<TamaraPaymentCubit>(
    () => TamaraPaymentCubit(
      repo: getIt<TamaraPaymentRepo>(),
      authRepo: getIt<AuthRepo>(),
      store: getIt<PaymentDraftStore>(),
    ),
  );

  getIt.registerFactory<ParentRegisterCubit>(
    () => ParentRegisterCubit(getIt<ParentAuthRepo>()),
  );

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
  getIt.registerFactory<GetCertificatesCubit>(
    () => GetCertificatesCubit(getIt<StudentCertificatesRepo>()),
  );
  getIt.registerFactory<GetMySubjectsCubit>(
    () => GetMySubjectsCubit(getIt<StudentSubjectsRepo>()),
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

  getIt.registerFactory<GetRegistrationRequestsCubit>(
    () => GetRegistrationRequestsCubit(getIt<RegistrationRequestsRepo>()),
  );

  getIt.registerFactory<RegistrationRequestActionsCubit>(
    () => RegistrationRequestActionsCubit(getIt<RegistrationRequestsRepo>()),
  );

  getIt.registerFactory<GetAssignmentSubmissionsCubit>(
    () => GetAssignmentSubmissionsCubit(getIt<AssignmentsRepo>()),
  );

  getIt.registerFactory<ReviewAssignmentSubmissionCubit>(
    () => ReviewAssignmentSubmissionCubit(getIt<AssignmentsRepo>()),
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

  getIt.registerFactory<GetTeacherAssignedSubjectsCubit>(
    () => GetTeacherAssignedSubjectsCubit(getIt<AssignmentsRepo>()),
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
  getIt.registerFactory<GetSupervisorsCubit>(
    () => GetSupervisorsCubit(getIt<SupervisorAssignmentRepo>()),
  );
  getIt.registerFactory<SupervisorAssignmentActionsCubit>(
    () => SupervisorAssignmentActionsCubit(getIt<SupervisorAssignmentRepo>()),
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
  getIt.registerFactory<ClassroomRecordingsCubit>(
    () => ClassroomRecordingsCubit(getIt<ClassroomDocumentsRepo>()),
  );
  getIt.registerFactory<ClassroomSummariesCubit>(
    () => ClassroomSummariesCubit(getIt<ClassroomDocumentsRepo>()),
  );
  getIt.registerFactory<MessageDocumentsCubit>(
    () => MessageDocumentsCubit(getIt<ChatRepo>()),
  );
  getIt.registerFactory<GetClassroomStudentsCubit>(
    () => GetClassroomStudentsCubit(getIt()),
  );

  getIt.registerFactory<GetStudentSubjectsCubit>(
    () => GetStudentSubjectsCubit(getIt()),
  );

  getIt.registerFactory<PackageActionsCubit>(
    () => PackageActionsCubit(getIt<PackageActionsRepo>()),
  );
  getIt.registerFactory<GetWeeklyPlansCubit>(
    () => GetWeeklyPlansCubit(getIt<PlansRepo>()),
  );
  getIt.registerFactory<GetParentPlansCubit>(
    () => GetParentPlansCubit(getIt<PlansRepo>()),
  );
  getIt.registerFactory<GetTermPlansCubit>(
    () => GetTermPlansCubit(getIt<PlansRepo>()),
  );
  getIt.registerFactory<GetElapsedWeeksCubit>(
    () => GetElapsedWeeksCubit(getIt<PlansRepo>()),
  );
  getIt.registerFactory<PlansActionsCubit>(
    () => PlansActionsCubit(getIt<PlansRepo>()),
  );
  getIt.registerFactory<GetParentChildrenCubit>(
    () => GetParentChildrenCubit(getIt<ParentHomeRepo>()),
  );
  getIt.registerFactory<GetSupervisorClassroomsCubit>(
    () => GetSupervisorClassroomsCubit(getIt<SupervisorManagementRepo>()),
  );
  getIt.registerFactory<WeeklyEvaluationsCubit>(
    () => WeeklyEvaluationsCubit(
      getIt<WeeklyEvaluationsRepo>(),
      getIt<AssignmentsRepo>(),
    ),
  );
  getIt.registerFactory<ReadOnlyWeeklyEvaluationsCubit>(
    () => ReadOnlyWeeklyEvaluationsCubit(getIt<WeeklyEvaluationsReadRepo>()),
  );
}
