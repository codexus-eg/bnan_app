enum OtpFlowMode { passwordReset, accountVerification }

class OtpFlowArgs {
  const OtpFlowArgs({
    this.email = '',
    this.mode = OtpFlowMode.passwordReset,
    this.showEgyptianRegistrationSuccess = false,
    this.resumeStudentRegistration = false,
  });

  const OtpFlowArgs.accountVerification(
    this.email, {
    this.showEgyptianRegistrationSuccess = false,
    this.resumeStudentRegistration = false,
  }) : mode = OtpFlowMode.accountVerification;

  final String email;
  final OtpFlowMode mode;
  final bool showEgyptianRegistrationSuccess;
  final bool resumeStudentRegistration;

  bool get isAccountVerification => mode == OtpFlowMode.accountVerification;
}
