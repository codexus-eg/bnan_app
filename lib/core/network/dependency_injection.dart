import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_student_subjects_cubit/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/admin_subject_requests/data/repo/admin_subject_requests_repo.dart';
import 'package:bnan_app/features/admin_subject_requests/data/repo/admin_subject_requests_repo_impl.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_request_actions_cubit.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_requests_cubit.dart';
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
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/push_notifications/data/installation_id_store.dart';
import 'package:bnan_app/features/push_notifications/data/repo/device_token_repo.dart';
import 'package:bnan_app/features/push_notifications/data/repo/device_token_repo_impl.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_messaging.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_notification_service.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_token_registrar.dart';
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
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/payments/data/repo/tamara_payment_repo.dart';
import 'package:bnan_app/features/payments/data/repo/tamara_payment_repo_impl.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo_impl.dart';
import 'package:bnan_app/features/student_subject_requests/data/repo/student_subject_requests_repo.dart';
import 'package:bnan_app/features/student_subject_requests/data/repo/student_subject_requests_repo_impl.dart';
import 'package:bnan_app/features/student_subject_requests/data/store/subject_request_payment_store.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/student_subject_requests_cubit.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/subject_request_payment_cubit.dart';
import 'package:bnan_app/features/student_subscriptions/data/repo/student_subscriptions_repo.dart';
import 'package:bnan_app/features/student_subscriptions/data/repo/student_subscriptions_repo_impl.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/data/store/renewal_payment_store.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/weekly_evaluations_read_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/weekly_evaluations_read_repo_impl.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final getIt = GetIt.instance;

void setupServiceLocator({bool firebaseAvailable = false}) {
  // Core
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<DioConsumer>(
    () => DioConsumer(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<ApiConsumer>(() => getIt<DioConsumer>());
  getIt.registerLazySingleton<DeviceTokenRepo>(
    () => DeviceTokenRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<InstallationIdStore>(InstallationIdStore.new);

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
  getIt.registerLazySingleton<SubjectRequestPaymentStore>(
    SubjectRequestPaymentStore.new,
  );
  getIt.registerLazySingleton<RenewalPaymentStore>(RenewalPaymentStore.new);

  getIt.registerLazySingleton<PackageActionsRepo>(
    () => PackageActionsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<CurriculumManagementRepo>(
    () => CurriculumManagementRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<RegistrationRequestsRepo>(
    () => RegistrationRequestsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<AdminSubjectRequestsRepo>(
    () => AdminSubjectRequestsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<DashboardRepo>(
    () => DashboardRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<IdealStudentRepo>(
    () => IdealStudentRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<SupervisorIdealTeacherRepo>(
    () => SupervisorIdealTeacherRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<AdminIdealSupervisorRepo>(
    () => AdminIdealSupervisorRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<DiscountCodesRepo>(
    () => DiscountCodesRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<TeacherPayrollRepo>(
    () => TeacherPayrollRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<TeacherRegistrationRequestsRepo>(
    () => TeacherRegistrationRequestsRepoImpl(getIt<ApiConsumer>()),
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
  getIt.registerLazySingleton<StudentGroupsRepo>(
    () => StudentGroupsRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<StudentSubjectRequestsRepo>(
    () => StudentSubjectRequestsRepoImpl(getIt<DioConsumer>()),
  );
  getIt.registerLazySingleton<StudentSubscriptionsRepo>(
    () => StudentSubscriptionsRepoImpl(getIt<ApiConsumer>()),
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
  getIt.registerLazySingleton<ParentAddChildRepo>(
    () => ParentAddChildRepoImpl(getIt<DioConsumer>()),
  );
  getIt.registerLazySingleton<ParentSubscriptionsRepo>(
    () => ParentSubscriptionsRepoImpl(getIt<DioConsumer>()),
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
  getIt.registerFactory<GetMyEnrollmentsCubit>(
    () => GetMyEnrollmentsCubit(getIt<StudentGroupsRepo>()),
  );
  getIt.registerFactory<StudentSubjectRequestsCubit>(
    () => StudentSubjectRequestsCubit(getIt<StudentSubjectRequestsRepo>()),
  );
  getIt.registerFactory<StudentSubscriptionsCubit>(
    () => StudentSubscriptionsCubit(getIt<StudentSubscriptionsRepo>()),
  );
  getIt.registerFactory<SubjectRequestPaymentCubit>(
    () => SubjectRequestPaymentCubit(
      repo: getIt<StudentSubjectRequestsRepo>(),
      keyGenerator: IdempotencyKeyGenerator(),
      store: getIt<SubjectRequestPaymentStore>(),
    ),
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
  getIt.registerFactory<AdminSubjectRequestsCubit>(
    () => AdminSubjectRequestsCubit(getIt<AdminSubjectRequestsRepo>()),
  );
  getIt.registerFactory<AdminSubjectRequestActionsCubit>(
    () => AdminSubjectRequestActionsCubit(getIt<AdminSubjectRequestsRepo>()),
  );
  getIt.registerFactoryParam<DashboardCubit, DashboardRole, void>(
    (role, _) => DashboardCubit(getIt<DashboardRepo>(), role),
  );
  getIt.registerFactory<IdealStudentCubit>(
    () => IdealStudentCubit(getIt<IdealStudentRepo>()),
  );
  getIt.registerFactory<SupervisorIdealTeacherCubit>(
    () => SupervisorIdealTeacherCubit(getIt<SupervisorIdealTeacherRepo>()),
  );
  getIt.registerFactory<AdminIdealSupervisorCubit>(
    () => AdminIdealSupervisorCubit(
      getIt<SupervisorAssignmentRepo>(),
      getIt<AdminIdealSupervisorRepo>(),
    ),
  );
  getIt.registerFactory<DiscountCodesCubit>(
    () => DiscountCodesCubit(getIt<DiscountCodesRepo>()),
  );
  getIt.registerFactory<DiscountCodeActionsCubit>(
    () => DiscountCodeActionsCubit(getIt<DiscountCodesRepo>()),
  );
  getIt.registerFactory<TeacherPayrollsCubit>(
    () => TeacherPayrollsCubit(getIt<TeacherPayrollRepo>()),
  );
  getIt.registerFactory<TeacherPayrollDetailsCubit>(
    () => TeacherPayrollDetailsCubit(getIt<TeacherPayrollRepo>()),
  );
  getIt.registerFactory<TeacherPayoutProfileCubit>(
    () => TeacherPayoutProfileCubit(getIt<TeacherPayrollRepo>()),
  );
  getIt.registerFactory<PayrollPaymentCubit>(
    () => PayrollPaymentCubit(getIt<TeacherPayrollRepo>()),
  );
  getIt.registerFactory<PayrollSessionsCubit>(
    () => PayrollSessionsCubit(getIt<TeacherPayrollRepo>()),
  );
  getIt.registerFactory<TeacherMyPayrollsCubit>(
    () => TeacherMyPayrollsCubit(getIt<TeacherPayrollRepo>()),
  );
  getIt.registerFactory<TeacherPayrollReportCubit>(
    () => TeacherPayrollReportCubit(getIt<TeacherPayrollRepo>()),
  );
  getIt.registerFactory<TeacherRegistrationRequestsCubit>(
    () => TeacherRegistrationRequestsCubit(
      getIt<TeacherRegistrationRequestsRepo>(),
    ),
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
    () => GetChatRoomsCubit(
      getIt<ChatRepo>(),
      getIt<ChatNotificationCoordinator>(),
    ),
  );
  getIt.registerFactory<GetRoomMessagesCubit>(
    () => GetRoomMessagesCubit(
      getIt<ChatRepo>(),
      getIt<SocketService>(),
      getIt<ChatNotificationCoordinator>(),
    ),
  );
  getIt.registerLazySingleton<SocketService>(() => SocketService());
  getIt.registerLazySingleton<ChatNotificationCoordinator>(
    () => ChatNotificationCoordinator(getIt<SocketService>()),
  );
  if (firebaseAvailable) {
    getIt.registerLazySingleton<PushMessaging>(
      () => FirebasePushMessaging(FirebaseMessaging.instance),
    );
    getIt.registerLazySingleton<PushTokenRegistrar>(
      () => PushTokenRegistrar(
        getIt<PushMessaging>(),
        getIt<DeviceTokenRepo>(),
        getIt<InstallationIdStore>(),
      ),
    );
    getIt.registerLazySingleton<PushNotificationService>(
      () => PushNotificationService(
        firebaseAvailable: true,
        messaging: getIt<PushMessaging>(),
        registrar: getIt<PushTokenRegistrar>(),
        chat: getIt<ChatNotificationCoordinator>(),
      ),
    );
  }
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
  getIt.registerFactory<ParentAddChildCubit>(
    () => ParentAddChildCubit(
      repo: getIt<ParentAddChildRepo>(),
      keyGenerator: IdempotencyKeyGenerator(),
      store: getIt<PaymentDraftStore>(),
    ),
  );
  getIt.registerFactory<GetParentSubscriptionsCubit>(
    () => GetParentSubscriptionsCubit(getIt<ParentSubscriptionsRepo>()),
  );
  getIt.registerFactoryParam<
    ParentSubscriptionRenewalCubit,
    ParentSubscriptionRenewalArgs,
    void
  >(
    (args, _) => ParentSubscriptionRenewalCubit(
      repo: getIt<ParentSubscriptionsRepo>(),
      keyGenerator: IdempotencyKeyGenerator(),
      args: args,
      store: getIt<RenewalPaymentStore>(),
    ),
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
