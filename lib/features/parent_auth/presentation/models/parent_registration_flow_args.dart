class ParentRegistrationFlowArgs {
  const ParentRegistrationFlowArgs({
    this.initialEmail = '',
    this.initialPassword = '',
    this.returnToStudentRegistration = false,
  });

  final String initialEmail;
  final String initialPassword;
  final bool returnToStudentRegistration;
}

class ParentRegistrationResult {
  const ParentRegistrationResult({required this.email, required this.password});

  final String email;
  final String password;
}
