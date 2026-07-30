sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class SplashNavigateToOnboarding extends SplashState {}

final class SplashNavigateToHome extends SplashState {
  SplashNavigateToHome(this.route);

  final String route;
}

final class SplashNavigateToParentHome extends SplashState {}
