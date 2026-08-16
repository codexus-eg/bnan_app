class LoginRouteArgs {
  const LoginRouteArgs({
    this.email,
    this.showEgyptianRegistrationSuccess = false,
  });

  final String? email;
  final bool showEgyptianRegistrationSuccess;
}
