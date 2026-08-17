import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/core/app_routes/home_route_resolver.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/send_message_cubit/send_message_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_recordings_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_summaries_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/message_documents_cubit.dart';
import 'package:bnan_app/features/chats/presentation/models/chat_route_args.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_route_args.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_members_route_args.dart';
import 'package:bnan_app/features/chats/presentation/views/classroom_documents_view.dart';
import 'package:bnan_app/features/chats/presentation/views/classroom_members_view.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_cubit.dart';
import 'package:bnan_app/features/chats/presentation/policies/classroom_documents_access.dart';
import 'package:bnan_app/features/chats/presentation/views/groups_view.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/curriculum_actions_cubit/curriculum_actions_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/views/term_plans_view.dart';
import 'package:bnan_app/features/ideal_student/presentation/policies/ideal_student_access_policy.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/policies/ideal_teacher_access_policy.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/policies/ideal_supervisor_access_policy.dart';
import 'package:bnan_app/features/student_auth/data/models/login_route_args.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/policies/parent_renewal_route_policy.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/certificates_view.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/assign_student_cubit/assign_student_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_available_classrooms_cubit/get_available_classrooms_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_unassigned_students_cubit/get_unassigned_students_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/views/student_classroom_assignment_view.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart'
    as curriculum_management;
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/supervisor_classroom_assignment_view.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';
import 'package:flutter/widgets.dart';
import 'routes_export.dart';

GoRouter buildRouter({GlobalKey<NavigatorState>? navigatorKey}) {
  return GoRouter(
    navigatorKey: navigatorKey,
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
        pageBuilder: (context, state) {
          final args = state.extra is LoginRouteArgs
              ? state.extra as LoginRouteArgs
              : null;
          final email =
              args?.email ??
              (state.extra is String ? state.extra as String : null);
          return buildTransitionPages(
            child: BlocProvider(
              create: (_) => getIt<LoginCubit>()..prefillEmail(email),
              child: LoginView(
                showEgyptianRegistrationSuccess:
                    args?.showEgyptianRegistrationSuccess ?? false,
              ),
            ),
            key: state.pageKey,
          );
        },
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
        redirect: (_, state) =>
            state.extra is CurriculumCardModel ? null : Routes.curriculum,
        pageBuilder: (context, state) {
          final curriculum = state.extra;
          if (curriculum is! CurriculumCardModel) {
            return buildTransitionPages(
              child: const SizedBox.shrink(),
              key: state.pageKey,
            );
          }
          return buildTransitionPages(
            child: BlocProvider(
              create: (_) =>
                  getIt<GetPackagesCubit>()
                    ..getPackagesByCurriculum(curriculum.id),
              child: SubscriptionView(
                curriculumId: curriculum.id,
                curriculumName: curriculum.title,
                registrationMode: curriculum.registrationMode,
              ),
            ),
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: Routes.studentRegistration,
        redirect: (_, state) =>
            state.extra is RegisterFlowArgsModel ? null : Routes.curriculum,
        pageBuilder: (context, state) {
          final args = state.extra;
          if (args is! RegisterFlowArgsModel) {
            return buildTransitionPages(
              child: const SizedBox.shrink(),
              key: state.pageKey,
            );
          }
          return buildTransitionPages(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      getIt<RegisterCubit>()..setRegisterFlowArgs(args),
                ),
                BlocProvider(
                  create: (_) => getIt<GetGradesCubit>()
                    ..getCurriculumGrades(
                      curriculumId: args.curriculumId,
                      isGulf: args.isGulf,
                    ),
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
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<StudentProfileCubit>()..getLoggedUser(),
              ),
              BlocProvider(
                create: (_) =>
                    getIt<DashboardCubit>(param1: DashboardRole.student)
                      ..load(),
              ),
            ],
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
        path: Routes.notificationSettings,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const NotificationPreferencesView(),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.chat,
        pageBuilder: (context, state) {
          final args = switch (state.extra) {
            ChatRouteArgs value => value,
            _ => null,
          };
          final roomId = state.pathParameters['roomId'];
          if (roomId == null || roomId.isEmpty) {
            throw StateError('Missing required chat roomId path parameter');
          }

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
                BlocProvider(create: (_) => getIt<StartSessionCubit>()),
                BlocProvider(
                  create: (_) => getIt<GetTeacherAssignedSubjectsCubit>(),
                ),
              ],
              child: ChatView(
                roomId: roomId,
                roomType: args?.roomType,
                classroomId: args?.classroomId,
                classroomName: args?.classroomName,
                currentUserRole:
                    args?.currentUserRole ?? SessionManager.instance.userRole,
                studentId: args?.studentId,
              ),
            ),
          );
        },
      ),

      GoRoute(
        path: Routes.legacyChat,
        redirect: (context, state) => Routes.groups,
      ),

      GoRoute(
        path: Routes.classroomDocuments,
        pageBuilder: (context, state) {
          final args = state.extra as ClassroomDocumentsRouteArgs;
          final canPrivileged =
              ClassroomDocumentsAccess.canRecordingsAndReports(
                roomType: args.roomType,
                classroomId: args.classroomId,
                role: args.currentUserRole,
              );
          final messageDocuments = BlocProvider(
            create: (_) => getIt<MessageDocumentsCubit>(),
            child: ClassroomDocumentsView(
              roomId: args.roomId,
              roomType: args.roomType,
              currentUserRole: args.currentUserRole,
              classroomId: args.classroomId,
              classroomName: args.classroomName,
            ),
          );
          return buildTransitionPages(
            key: state.pageKey,
            child: canPrivileged
                ? MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => getIt<ClassroomRecordingsCubit>(),
                      ),
                      BlocProvider(
                        create: (_) => getIt<ClassroomSummariesCubit>(),
                      ),
                    ],
                    child: messageDocuments,
                  )
                : messageDocuments,
          );
        },
      ),

      GoRoute(
        path: Routes.classroomMembers,
        redirect: (_, _) => SessionManager.instance.role == UserRole.supervisor
            ? null
            : Routes.groups,
        pageBuilder: (context, state) {
          final args = state.extra as ClassroomMembersRouteArgs;
          return buildTransitionPages(
            key: state.pageKey,
            child: BlocProvider(
              create: (_) =>
                  getIt<GetClassroomStudentsCubit>()
                    ..getClassroomStudents(classroomId: args.classroomId),
              child: const ClassroomMembersView(),
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
        redirect: (context, state) {
          if (SessionManager.instance.role == UserRole.student) return null;
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<StudentSubjectRequestsCubit>()..load(),
              ),
              BlocProvider(create: (_) => getIt<SubjectRequestPaymentCubit>()),
            ],
            child: const StudentSubjectRequestsView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.studentSubscriptions,
        redirect: (context, state) =>
            SessionManager.instance.role == UserRole.student
            ? null
            : HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
                  Routes.splash,
        pageBuilder: (context, state) => buildTransitionPages(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => getIt<StudentSubscriptionsCubit>()..load(),
            child: const StudentSubscriptionsView(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.studentSubscriptionRenewal,
        redirect: (context, state) {
          if (SessionManager.instance.role != UserRole.student) {
            return HomeRouteResolver.forRole(
                  SessionManager.instance.userRole,
                ) ??
                Routes.splash;
          }
          final extra = state.extra;
          return extra is ParentSubscriptionRenewalArgs && !extra.isParent
              ? null
              : Routes.studentSubscriptions;
        },
        pageBuilder: (context, state) {
          final args = state.extra! as ParentSubscriptionRenewalArgs;
          return buildTransitionPages(
            key: state.pageKey,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      getIt<ParentSubscriptionRenewalCubit>(param1: args)
                        ..restore(),
                ),
                BlocProvider(
                  create: (_) =>
                      getIt<GetPackagesCubit>()
                        ..getPackagesByCurriculum(args.curriculumId),
                ),
              ],
              child: const ParentSubscriptionRenewalView(),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.studentSubjects,
        redirect: (context, state) {
          if (SessionManager.instance.role == UserRole.student) return null;
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: const StudentSubjectsView(),
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
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<TeacherMyPayrollsCubit>()),
              BlocProvider(
                create: (_) =>
                    getIt<DashboardCubit>(param1: DashboardRole.teacher),
              ),
            ],
            child: TeacherHomeView(
              initialIndex: state.uri.queryParameters['tab'] == 'payrolls'
                  ? teacherPayrollTabIndex
                  : 0,
            ),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.adminHome,
        redirect: (context, state) {
          if (SessionManager.instance.role == UserRole.admin) return null;
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) =>
                getIt<DashboardCubit>(param1: DashboardRole.admin)..load(),
            child: const AdminHomeView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.discountCodes,
        redirect: (context, state) {
          if (SessionManager.instance.role == UserRole.admin) return null;
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<DiscountCodesCubit>()..load()),
              BlocProvider(create: (_) => getIt<DiscountCodeActionsCubit>()),
            ],
            child: const DiscountCodesView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.teacherPayrolls,
        redirect: _adminOnly,
        pageBuilder: (context, state) => buildTransitionPages(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => getIt<TeacherPayrollsCubit>(),
            child: const TeacherPayrollsView(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.teacherPayrollSessions,
        redirect: _adminOnly,
        pageBuilder: (context, state) => buildTransitionPages(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => getIt<PayrollSessionsCubit>(),
            child: PayrollSessionsView(
              teacherId: state.pathParameters['teacherId'] ?? '',
              curriculumId: state.pathParameters['curriculumId'] ?? '',
              from: state.uri.queryParameters['from'] ?? '',
              to: state.uri.queryParameters['to'] ?? '',
              system: state.uri.queryParameters['system'] ?? '',
            ),
          ),
        ),
      ),
      GoRoute(
        path: Routes.teacherPayrollCreate,
        redirect: _adminOnly,
        pageBuilder: (context, state) => buildTransitionPages(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<TeacherPayrollDetailsCubit>()),
              BlocProvider(create: (_) => getIt<TeacherPayoutProfileCubit>()),
            ],
            child: TeacherPayrollDetailsView(
              teacherId: state.pathParameters['teacherId'],
              from: state.uri.queryParameters['from'],
              to: state.uri.queryParameters['to'],
            ),
          ),
        ),
      ),
      GoRoute(
        path: Routes.teacherPayrollPayment,
        redirect: _adminOnly,
        pageBuilder: (context, state) => buildTransitionPages(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<TeacherPayrollDetailsCubit>()),
              BlocProvider(create: (_) => getIt<TeacherPayoutProfileCubit>()),
              BlocProvider(create: (_) => getIt<PayrollPaymentCubit>()),
            ],
            child: PayrollPaymentView(
              payrollId: state.pathParameters['payrollId'] ?? '',
            ),
          ),
        ),
      ),
      GoRoute(
        path: Routes.teacherPayrollDetails,
        redirect: _adminOnly,
        pageBuilder: (context, state) => buildTransitionPages(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<TeacherPayrollDetailsCubit>()),
              BlocProvider(create: (_) => getIt<TeacherPayoutProfileCubit>()),
            ],
            child: TeacherPayrollDetailsView(
              payrollId: state.pathParameters['payrollId'],
            ),
          ),
        ),
      ),
      GoRoute(
        path: Routes.teacherMyPayrollReport,
        redirect: _teacherOnly,
        pageBuilder: (context, state) => buildTransitionPages(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => getIt<TeacherPayrollReportCubit>(),
            child: TeacherPayrollReportView(
              payrollId: state.pathParameters['payrollId'] ?? '',
            ),
          ),
        ),
      ),
      GoRoute(
        path: Routes.supervisorHome,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) =>
                getIt<DashboardCubit>(param1: DashboardRole.supervisor)..load(),
            child: const SupervisorHomeView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.parentHome,
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<DashboardCubit>(param1: DashboardRole.parent)..load(),
              ),
              BlocProvider(
                create: (_) => getIt<StudentProfileCubit>()..getLoggedUser(),
              ),
            ],
            child: const ParentHomeView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.parentAddChild,
        redirect: _parentOnly,
        pageBuilder: (context, state) {
          final initialArgs = state.extra is ParentAddChildArgs
              ? state.extra as ParentAddChildArgs
              : null;
          return buildTransitionPages(
            key: state.pageKey,
            child: BlocProvider(
              create: (_) {
                final cubit = getIt<GetParentChildrenCubit>();
                if (initialArgs == null) cubit.getParentChildren();
                return cubit;
              },
              child: ParentAddChildRouteGate(
                initialArgs: initialArgs,
                builder: _buildParentAddChildFlow,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.parentSubscriptions,
        redirect: _parentOnly,
        pageBuilder: (context, state) => buildTransitionPages(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => getIt<GetParentSubscriptionsCubit>()..load(),
            child: const ParentSubscriptionsView(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.parentSubscriptionRenewal,
        redirect: (context, state) {
          final parentRedirect = _parentOnly(context, state);
          if (parentRedirect != null) return parentRedirect;
          final args = state.extra;
          final studentId = state.pathParameters['studentId'];
          if (!isValidParentRenewalRoute(studentId: studentId, extra: args)) {
            return Routes.parentSubscriptions;
          }
          return null;
        },
        pageBuilder: (context, state) {
          final args = state.extra! as ParentSubscriptionRenewalArgs;
          return buildTransitionPages(
            key: state.pageKey,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      getIt<ParentSubscriptionRenewalCubit>(param1: args)
                        ..restore(),
                ),
                BlocProvider(
                  create: (_) =>
                      getIt<GetPackagesCubit>()
                        ..getPackagesByCurriculum(args.curriculumId),
                ),
              ],
              child: const ParentSubscriptionRenewalView(),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.parentSchedule,
        redirect: (context, state) {
          if (SessionManager.instance.role == UserRole.parent) return null;
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: const ParentScheduleView(),
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
        redirect: (context, state) {
          if (SessionManager.instance.role == UserRole.supervisor) return null;
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
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
                create: (_) =>
                    getIt<GetSupervisorClassroomsCubit>()..getMyClassrooms(),
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
        redirect: (context, state) {
          final session = SessionManager.instance;
          final allowed = session.canAccessTeacherSubjectRequests;
          if (allowed) return null;
          return HomeRouteResolver.forRole(session.userRole) ?? Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<TeacherRegistrationRequestsCubit>()..refresh(),
              ),
              BlocProvider(create: (_) => getIt<GetTeacherClassroomsCubit>()),
            ],
            child: const TeacherRegistrationRequestsView(),
          ),
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
        redirect: (context, state) {
          if (IdealStudentAccessPolicy.canAccessCurrent) return null;
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<IdealStudentCubit>()),
              if (SessionManager.instance.role == UserRole.teacher)
                BlocProvider(
                  create: (_) =>
                      getIt<GetTeacherClassroomsCubit>()..getMyClassrooms(),
                ),
              if (SessionManager.instance.role == UserRole.supervisor)
                BlocProvider(
                  create: (_) =>
                      getIt<GetSupervisorClassroomsCubit>()..getMyClassrooms(),
                ),
            ],
            child: const WeeklyIdealStudentView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.idealTeacher,
        redirect: (context, state) {
          if (IdealTeacherAccessPolicy.canAccessCurrent) return null;
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<SupervisorIdealTeacherCubit>(),
            child: const IdealTeacherView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.idealSupervisor,
        redirect: (context, state) {
          if (IdealSupervisorAccessPolicy.canAccessCurrent) return null;
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<AdminIdealSupervisorCubit>(),
            child: const IdealSupervisorView(),
          ),
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
          final isGulfStudent = role == UserRole.student && state.extra == true;
          final policy = PlansAccessPolicy.fromRole(
            SessionManager.instance.userRole,
            isGulfStudent: isGulfStudent,
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
                if (role == UserRole.student && !isGulfStudent)
                  BlocProvider(
                    create: (_) =>
                        getIt<GetMyEnrollmentsCubit>()..getMyEnrollments(),
                  ),
                if (isGulfStudent)
                  BlocProvider(
                    create: (_) => getIt<GulfScheduleCubit>()..load(),
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
              child: PlansView(isGulfStudent: isGulfStudent),
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
          child: const CertificatesView(),
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
        path: Routes.addClassroomSubject,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<AddClassroomSubjectCubit>()..load(),
            child: const AddClassroomSubjectView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.tablesManagement,
        redirect: (context, state) {
          final session = SessionManager.instance;
          if (session.role == UserRole.admin || session.isEgyptianSupervisor) {
            return null;
          }
          return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
              Routes.splash;
        },
        pageBuilder: (context, state) {
          final isSupervisor = SessionManager.instance.isEgyptianSupervisor;
          return buildTransitionPages(
            child: isSupervisor
                ? BlocProvider(
                    create: (_) =>
                        getIt<GetSupervisorClassroomsCubit>()
                          ..getMyClassrooms(),
                    child: const TablesManagementView(
                      useSupervisorClassrooms: true,
                    ),
                  )
                : BlocProvider(
                    create: (_) => getIt<ClassroomsCubit>()..getClassrooms(),
                    child: const TablesManagementView(),
                  ),
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: Routes.egyptianSchedulesReadOnly,
        redirect: (context, state) {
          final session = SessionManager.instance;
          final isAllowed =
              session.isEgyptianStudent ||
              (session.role == UserRole.teacher &&
                  session.hasEgyptianRegistration);
          if (isAllowed) return null;
          return HomeRouteResolver.forRole(session.userRole) ?? Routes.splash;
        },
        pageBuilder: (context, state) {
          final session = SessionManager.instance;
          final child = session.role == UserRole.teacher
              ? const TeacherEgyptianScheduleView()
              : const StudentEgyptianScheduleView();
          return buildTransitionPages(child: child, key: state.pageKey);
        },
      ),
      GoRoute(
        path: Routes.gulfStudentScheduleReadOnly,
        redirect: (context, state) {
          final session = SessionManager.instance;
          if (session.isGulfStudent) return null;
          return HomeRouteResolver.forRole(session.userRole) ?? Routes.splash;
        },
        pageBuilder: (context, state) => buildTransitionPages(
          child: const GulfStudentScheduleReadOnlyView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.lessonsManagement,
        redirect: (context, state) {
          final session = SessionManager.instance;
          final isAllowed =
              session.isGulfSupervisor ||
              (session.role == UserRole.teacher && session.hasGulfRegistration);
          if (isAllowed) {
            return null;
          }
          return HomeRouteResolver.forRole(session.userRole) ?? Routes.splash;
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
              BlocProvider(create: (_) => getIt<AdminSubjectRequestsCubit>()),
              BlocProvider(
                create: (context) => getIt<AdminSubjectRequestActionsCubit>()
                  ..onRefresh = () => context
                      .read<AdminSubjectRequestsCubit>()
                      .load(refresh: true),
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

Widget _buildParentAddChildFlow(BuildContext context, ParentAddChildArgs args) {
  final curriculum = args.curriculum;
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) =>
            getIt<ParentAddChildCubit>()
              ..start(curriculum, parentHasChildren: args.parentHasChildren),
      ),
      BlocProvider(
        create: (_) {
          final cubit = AcademicLookupsCubit(
            repo: getIt<AcademicLookupsRepo>(),
            loadClassroomsOnGrade: false,
            loadSubjectsWithoutClassroom: true,
          );
          curriculum == null
              ? cubit.loadCurriculums()
              : cubit.selectCurriculum(curriculum);
          return cubit;
        },
      ),
      BlocProvider(
        create: (_) {
          final cubit = getIt<GetPackagesCubit>();
          if (curriculum != null) {
            cubit.getPackagesByCurriculum(curriculum.id);
          }
          return cubit;
        },
      ),
    ],
    child: const ParentAddChildView(),
  );
}

String? _adminOnly(BuildContext context, GoRouterState state) {
  if (SessionManager.instance.role == UserRole.admin) return null;
  return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
      Routes.splash;
}

String? _teacherOnly(BuildContext context, GoRouterState state) {
  if (SessionManager.instance.role == UserRole.teacher) return null;
  return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
      Routes.splash;
}

String? _parentOnly(BuildContext context, GoRouterState state) {
  if (SessionManager.instance.role == UserRole.parent) return null;
  return HomeRouteResolver.forRole(SessionManager.instance.userRole) ??
      Routes.splash;
}
