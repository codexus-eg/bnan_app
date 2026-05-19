import 'package:bnan_app/core/app_routes/custom_navigation_pages.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/features/splash/presentation/views/splash_view.dart';

import 'routes_export.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        pageBuilder: (context, state) =>
            buildTransitionPages(child: const SplashView(), key: state.pageKey),
      ),
    ],
  );
}
