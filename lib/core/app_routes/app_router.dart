import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/core/app_routes/home_route_resolver.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/send_message_cubit/send_message_cubit.dart';
import 'package:bnan_app/features/chats/presentation/views/groups_view.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/curriculum_actions_cubit/curriculum_actions_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/views/term_plans_view.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/assign_student_cubit/assign_student_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_available_classrooms_cubit/get_available_classrooms_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_unassigned_students_cubit/get_unassigned_students_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/views/student_classroom_assignment_view.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart'
    as curriculum_management;
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/supervisor_classroom_assignment_view.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';
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
        path: Routes.parentRegistration,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<ParentRegisterCubit>(),
            child: const ParentRegisterView(),
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
                    ..getPackagesByCurriculum(curriculum.id),
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
        path: Routes.supervisorHome,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const SupervisorHomeView(),
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
              BlocProvider(create: (_) => getIt<GetCertificateDetailsCubit>()),
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
        pageBuilder: (context, state) {
          final role = SessionManager.instance.role;
          if (role == UserRole.student || role == UserRole.parent) {
            return buildTransitionPages(
              child: BlocProvider(
                create: (_) => role == UserRole.student
                    ? (getIt<ReadOnlyWeeklyEvaluationsCubit>()
                        ..loadForStudent())
                    : (getIt<ReadOnlyWeeklyEvaluationsCubit>()
                        ..loadForParent()),
                child: const WeeklyEvaluationsView(),
              ),
              key: state.pageKey,
            );
          }
          return buildTransitionPages(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      getIt<WeeklyEvaluationsCubit>()
                        ..initialize(SessionManager.instance.userRole),
                ),
                if (role == UserRole.teacher)
                  BlocProvider(
                    create: (_) =>
                        getIt<GetTeacherClassroomsCubit>()..getMyClassrooms(),
                  ),
                if (role == UserRole.supervisor)
                  BlocProvider(
                    create: (_) =>
                        getIt<GetSupervisorClassroomsCubit>()
                          ..getMyClassrooms(),
                  ),
              ],
              child: const WeeklyEvaluationsView(),
            ),
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: Routes.attendance,
        redirect: (context, state) {
          final role = SessionManager.instance.role;
          if (role == UserRole.teacher || role == UserRole.supervisor) {
            return null;
          }
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) =>
                getIt<AttendanceCubit>()
                  ..initialize(SessionManager.instance.role),
            child: const AttendanceView(),
          ),
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
        path: Routes.plans,
        pageBuilder: (context, state) {
          final role = SessionManager.instance.role;
          final policy = PlansAccessPolicy.fromRole(
            SessionManager.instance.userRole,
          );
          return buildTransitionPages(
            child: MultiBlocProvider(
              providers: [
                if (role != UserRole.parent) ...[
                  BlocProvider(create: (_) => getIt<GetWeeklyPlansCubit>()),
                  BlocProvider(create: (_) => getIt<GetElapsedWeeksCubit>()),
                ],
                if (policy.showManagementActions) ...[
                  BlocProvider(create: (_) => getIt<GetTermPlansCubit>()),
                  BlocProvider(create: (_) => getIt<PlansActionsCubit>()),
                  BlocProvider(
                    create: (_) => getIt<GetClassroomSubjectsCubit>(),
                  ),
                  BlocProvider(
                    create: (_) => getIt<GetTeacherAssignedSubjectsCubit>(),
                  ),
                  BlocProvider(create: (_) => getIt<ClassroomDetailsCubit>()),
                ],
                if (role == UserRole.teacher)
                  BlocProvider(
                    create: (_) =>
                        getIt<GetTeacherClassroomsCubit>()..getMyClassrooms(),
                  ),
                if (role == UserRole.student)
                  BlocProvider(
                    create: (_) =>
                        getIt<GetMyEnrollmentsCubit>()..getMyEnrollments(),
                  ),
                if (role == UserRole.supervisor)
                  BlocProvider(
                    create: (_) =>
                        getIt<GetSupervisorClassroomsCubit>()
                          ..getMyClassrooms(),
                  ),
                if (role == UserRole.admin)
                  BlocProvider(
                    create: (_) => getIt<ClassroomsCubit>()..getClassrooms(),
                  ),
                if (role == UserRole.parent)
                  BlocProvider(
                    create: (_) =>
                        getIt<GetParentPlansCubit>()..loadParentPlans(),
                  ),
              ],
              child: const PlansView(),
            ),
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: Routes.termPlans,
        redirect: (context, state) {
          if (SessionManager.instance.role == UserRole.admin) return null;
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<GetTermPlansCubit>()..getAllTermPlans(),
              ),
              BlocProvider(
                create: (_) => getIt<ClassroomsCubit>()..getClassrooms(),
              ),
            ],
            child: const TermPlansView(),
          ),
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
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<CurriculumActionsCubit>()),
              BlocProvider(
                create: (_) =>
                    getIt<curriculum_management.GetCurriculumsCubit>()
                      ..getCurriculums(),
              ),
            ],
            child: const CurriculumManagementView(),
          ),
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
        path: Routes.lessonsManagement,
        redirect: (context, state) {
          final role = SessionManager.instance.role;
          if (role == UserRole.teacher ||
              role == UserRole.supervisor ||
              role == UserRole.admin) {
            return null;
          }
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: const LessonsManagementView(),
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
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<GetRegistrationRequestsCubit>()
                      ..getRegistrationRequests(refresh: true),
              ),
              BlocProvider(
                create: (_) => getIt<RegistrationRequestActionsCubit>(),
              ),
            ],
            child: const RegistrationRequestsView(),
          ),
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
      GoRoute(
        path: Routes.studentClassroomAssignment,
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => GetUnassignedStudentsCubit(
                  getIt<StudentClassroomAssignmentRepo>(),
                )..getUnassignedStudents(),
              ),
              BlocProvider(
                create: (_) => GetAvailableClassroomsCubit(
                  getIt<StudentClassroomAssignmentRepo>(),
                ),
              ),
              BlocProvider(
                create: (_) =>
                    AssignStudentCubit(getIt<StudentClassroomAssignmentRepo>()),
              ),
            ],
            child: const StudentClassroomAssignmentView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.supervisorClassRoomAssignment,
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<GetSupervisorsCubit>()..getSupervisors(),
              ),
              BlocProvider(
                create: (_) => getIt<SupervisorAssignmentActionsCubit>(),
              ),
            ],
            child: const SupervisorClassroomAssignmentView(),
          ),
          key: state.pageKey,
        ),
      ),
    ],
  );
}
