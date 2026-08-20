enum OtpFlowMode { passwordReset, accountVerification }

class OtpFlowArgs {
  const OtpFlowArgs({
    this.email = '',
    this.mode = OtpFlowMode.passwordReset,
    this.showEgyptianRegistrationSuccess = false,
  });

  const OtpFlowArgs.accountVerification(
    this.email, {
    this.showEgyptianRegistrationSuccess = false,
  }) : mode = OtpFlowMode.accountVerification;

  final String email;
  final OtpFlowMode mode;
  final bool showEgyptianRegistrationSuccess;

  bool get isAccountVerification => mode == OtpFlowMode.accountVerification;
}
