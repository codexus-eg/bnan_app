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
              BlocProvider(
                create: (_) => getIt<ForgotPasswordCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<ResetPasswordCubit>(),
              ),
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
          child: const CurriculaView(),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.subscription,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const SubscriptionView(),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.studentRegistration,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const StudentRegistrationView(),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.changePassword,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (_) => getIt<UpdatePasswordCubit>(),
            child: const ChangePasswordView(),
          ),
          key: state.pageKey,
        ),
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
          child: const HomeStudentView(),
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
        pageBuilder: (context, state) => buildTransitionPages(
          child: const ChatView(),
          key: state.pageKey,
        ),
      ),

      GoRoute(
        path: Routes.groups,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const GroupsView(),
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
    ],
  );
}