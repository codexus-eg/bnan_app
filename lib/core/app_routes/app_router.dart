import 'package:bnan_app/features/class_schedules/presentation/views/class_schedules_view.dart';
import 'package:bnan_app/features/parent_certificates/presentation/views/parent_certification_view.dart';
import 'package:bnan_app/features/parent_home/presentation/views/parent_home_view.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/teacher_certificates_view.dart';
import 'package:bnan_app/features/teacher_chats/presentation/views/teacher_chats_view.dart';
import 'package:bnan_app/features/teacher_groups/presentation/views/teacher_sections_view.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/teacher_home_view.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/teacher_performance_view.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/weekly_ideal_student_view.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/teacher_registration_view.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/teacher_registration_requests_view.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/weekly_evaluations_view.dart';
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
                BlocProvider(create: (_) => getIt<GetSubjectsCubit>()),
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
        pageBuilder: (context, state) =>
            buildTransitionPages(child: const ChatView(), key: state.pageKey),
      ),

      GoRoute(
        path: Routes.groups,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<GetMyEnrollmentsCubit>()..getMyEnrollments(),
            child: const GroupsView(),
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
        path: Routes.teacherCertificates,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const TeacherCertificatesView(),
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
        path: Routes.teacherChats,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const TeacherChatsView(),
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
                create: (context) => GetSubjectsCubit(getIt<AuthRepo>()),
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
    ],
  );
}
