import 'package:bnan_app/features/auth/data/models/curriculum_card_model.dart';
import 'package:bnan_app/features/auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/auth/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart';
import 'package:bnan_app/features/auth/presentation/manager/get_grades_cubit/get_grades_cubit.dart';
import 'package:bnan_app/features/auth/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/auth/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:bnan_app/features/student_groups/presentation/manager/get_my_enrollments/get_my_enrollments_cubit.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/get_logged_user_cubit/get_logged_user_cubit.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/update_name_cubit/update_name_cubit.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/update_phone_cubit/update_phone_cubit.dart';
import 'package:bnan_app/features/student_profile/presentation/views/edit_name_view.dart';
import 'package:bnan_app/features/student_profile/presentation/views/edit_phone_view.dart';
import 'package:bnan_app/features/student_profile/presentation/views/update_password_view.dart';

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
            create: (context) => getIt<GetLoggedUserCubit>()..getLoggedUser(),
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
    ],
  );
}
