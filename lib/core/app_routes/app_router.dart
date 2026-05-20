import 'package:bnan_app/core/app_routes/custom_navigation_pages.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/login_view.dart';
import 'package:bnan_app/features/splash/presentation/views/manager/splash_cubit.dart';
import 'package:bnan_app/features/splash/presentation/views/splash_view.dart';

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
        pageBuilder: (context, state) =>
            buildTransitionPages(child: const LoginView(), key: state.pageKey),
      ),
    ],
  );
}
