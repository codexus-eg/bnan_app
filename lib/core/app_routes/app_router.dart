import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/send_message_cubit/send_message_cubit.dart';
import 'package:bnan_app/features/chats/presentation/views/groups_view.dart';


import 'routes_export.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => SplashCubit()..checkUserStatus(),
            child: const SplashView(),
          ),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.logIn,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginView(),
          ),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.forgetPassword,
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<ForgotPasswordCubit>()),
              BlocProvider(create: (_) => getIt<ResetPasswordCubit>()),
            ],
            child: const ForgetPasswordView(),
          ),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.register,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<RegisterCubit>(),
            child: const RegisterView(),
          ),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.curriculum,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<GetCurriculumsCubit>()..getAllCurriculums(),
            child: const CurriculaView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.subscription,
        pageBuilder: (context, state) {
          final curriculum = state.extra as CurriculumCardModel;
          return buildTransitionPages(
            child: BlocProvider(
              create: (_) =>
                  getIt<GetPackagesCubit>()
                    ..getCurriculumPackages(curriculumId: curriculum.id),
              child: SubscriptionView(
                curriculumId: curriculum.id,
                curriculumName: curriculum.title,
              ),
            ),
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: Routes.studentRegistration,
        pageBuilder: (context, state) {
          final args = state.extra as RegisterFlowArgsModel;
          return buildTransitionPages(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      getIt<RegisterCubit>()..setRegisterFlowArgs(args),
                ),
                BlocProvider(
                  create: (_) =>
                      getIt<GetGradesCubit>()
                        ..getCurriculumGrades(curriculumId: args.curriculumId),
                ),
                BlocProvider(create: (_) => getIt<GetCurriculmSubjectsCubit>()),
              ],
              child: const StudentRegistrationView(),
            ),
            key: state.pageKey,
          );
        },
      ),

      GoRoute(
        path: Routes.changePassword,
        pageBuilder: (context, state) {
          final email = state.extra as String? ?? '';

          return buildTransitionPages(
            child: BlocProvider(
              create: (_) => getIt<ResetPasswordCubit>(),
              child: ChangePasswordView(email: email),
            ),
            key: state.pageKey,
          );
        },
      ),

      GoRoute(
        path: Routes.onboarding,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<OnboardingCubit>(),
            child: const OnboardingView(),
          ),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.home,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (context) => getIt<StudentProfileCubit>()..getLoggedUser(),
            child: const HomeStudentView(),
          ),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.notification,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const NotificationsView(),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.chat,
        pageBuilder: (context, state) {
          final roomId = state.extra as String;

          return buildTransitionPages(
            key: state.pageKey,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      getIt<GetRoomMessagesCubit>()
                        ..initializeChat(roomId: roomId),
                ),
                BlocProvider(create: (_) => getIt<SendMessageCubit>()),
              ],
              child: ChatView(roomId: roomId),
            ),
          );
        },
      ),

      GoRoute(
        path: Routes.studentGroups,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<GetMyEnrollmentsCubit>()..getMyEnrollments(),
            child: const StudentGroupsView(),
          ),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.requestLesson,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const RequestLessonView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.updatePhone,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (context) => getIt<UpdatePhoneCubit>(),

            child: const EditPhoneView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.updateUserName,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (context) => getIt<UpdateNameCubit>(),
            child: const EditNameView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.updatePassword,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (context) => getIt<UpdatePasswordCubit>(),
            child: const UpdatePasswordView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.teacherHome,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const TeacherHomeView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.adminHome,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const AdminHomeView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.parentHome,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const ParentHomeView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.teacherSections,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const TeacherSectionsView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.certificatesManagement,
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<DeleteMonthlyCertificateCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    getIt<GetMonthlyCertificatesCubit>()
                      ..getMonthlyCertificates(),
              ),
             
              BlocProvider(
                create: (_) => AcademicLookupsCubit(
                  repo: getIt<AcademicLookupsRepo>(),
                  loadClassroomsOnGrade: false,
                  loadSubjectsWithoutClassroom: false,
                )..loadGrades(),
              ),
               BlocProvider(
                create: (context) => getIt<IssueMonthlyCertificatesCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<UpdateMonthlyCertificateCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<CreateMonthlyCertificateCubit>(),
              ),
            ],
            child: const CertificatesManagementView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.teacherRegistrationRequest,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const TeacherRegistrationRequestsView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.groups,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<GetChatRoomsCubit>()..getChatRooms(),
            child: const GroupsView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.teacherRegistration,
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<TeacherRegistrationCubit>()),
              BlocProvider(
                create: (_) =>
                    getIt<GetCurriculumsCubit>()..getAllCurriculums(),
              ),
              BlocProvider(
                create: (context) => GetGradesCubit(getIt<AuthRepo>()),
              ),
              BlocProvider(
                create: (context) =>
                    GetCurriculmSubjectsCubit(getIt<AuthRepo>()),
              ),
            ],
            child: const TeacherRegistrationView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.teacherPerformance,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const TeacherPerformanceView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.weeklyIdealStudents,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const WeeklyIdealStudentView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.weeklyEvaluations,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const WeeklyEvaluationsView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.classSchedules,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const ClassSchedulesView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.parentCertificates,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const ParentCertificationView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.teacherSubjectAssignmentView,
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<TeacherSubjectAssignmentsCubit>()
                      ..getTeacherTeachingAssignments(),
              ),
              BlocProvider(
                create: (_) => getIt<TeacherSubjectAssignmentActionsCubit>(),
              ),
            ],
            child: const TeacherSubjectAssignmentView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.classRoomManagement,
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<ClassroomsCubit>()..getClassrooms(),
              ),
              BlocProvider(create: (_) => getIt<ClassroomActionsCubit>()),
            ],
            child: const ClassroomsManagementView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.curriculumManagement,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const CurriculumManagementView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.tablesManagement,
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<GetEgyptianSchedulesCubit>()..getEgyptianSchedules(),
              ),
              BlocProvider(create: (_) => getIt<CreateEgyptianScheduleCubit>()),
              BlocProvider(create: (_) => getIt<DeleteEgyptianScheduleCubit>()),
              BlocProvider(
                create: (_) => AcademicLookupsCubit(
                  repo: getIt<AcademicLookupsRepo>(),
                  loadClassroomsOnGrade: false,
                  loadSubjectsWithoutClassroom: false,
                )..loadGrades(),
              ),
            ],
            child: const TablesManagementView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.teacherApplication,
        pageBuilder: (context, state) => buildTransitionPages(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<PendingTeacherRequestsCubit>()
                      ..getPendingTeacherRequests(),
              ),
              BlocProvider(create: (_) => getIt<TeacherDetailsCubit>()),
              BlocProvider(create: (_) => getIt<TeacherRequestActionsCubit>()),
            ],
            child: const TeacherApplicationView(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.registrationRequests,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const RegistrationRequestsView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.gradesManagement,
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    getIt<GetGradesmanagementCubit>()..getGrades(),
              ),
              BlocProvider(create: (context) => getIt<GradeActionsCubit>()),
              BlocProvider(create: (context) => getIt<AcademicLookupsCubit>()),
            ],
            child: const GradesManagementView(),
          ),
          key: state.pageKey,
        ),
      ),
    ],
  );
}
