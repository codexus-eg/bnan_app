import 'package:bnan_app/core/app_routes/custom_navigation_pages.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/auth/presentation/views/change_password_view.dart';
import 'package:bnan_app/features/auth/presentation/views/curricula_view.dart';
import 'package:bnan_app/features/auth/presentation/views/forget_password_view.dart';
import 'package:bnan_app/features/auth/presentation/views/login_view.dart';
import 'package:bnan_app/features/auth/presentation/views/manager/student_registration_cubit/student_registration_cubit.dart';
import 'package:bnan_app/features/auth/presentation/views/register_view.dart';
import 'package:bnan_app/features/auth/presentation/views/student_registration_view.dart';
import 'package:bnan_app/features/auth/presentation/views/subscription_view.dart';
import 'package:bnan_app/features/home_student/features/views/home_student_view.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/manager/splash_cubit/splash_cubit.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/views/onboarding_view.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/views/splash_view.dart';

import 'routes_export.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: Routes.home,
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
        pageBuilder: (context, state) =>
            buildTransitionPages(child: const LoginView(), key: state.pageKey),
      ),
      GoRoute(
        path: Routes.forgetPassword,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const ForgetPasswordView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.register,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const RegisterView(),
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
          child: BlocProvider(
            create: (_) => getIt<StudentRegistrationCubit>(),

            child: const StudentRegistrationView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.changePassword,
        pageBuilder: (context, state) => buildTransitionPages(
          child: const ChangePasswordView(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.onboarding,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (context) => getIt<OnboardingCubit>(),
            child: const OnboardingView(),
          ),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.home,
        pageBuilder: (context, state) => buildTransitionPages(
          child: BlocProvider(
            create: (context) => getIt<OnboardingCubit>(),
            child: const HomeStudentView(),
          ),
          key: state.pageKey,
        ),
      ),
    ],
  );
}
