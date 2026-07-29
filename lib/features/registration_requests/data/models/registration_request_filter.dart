enum RegistrationRequestFilter { approved, pending }

extension RegistrationRequestFilterX on RegistrationRequestFilter {
  String get apiValue => switch (this) {
    RegistrationRequestFilter.approved => 'approved',
    RegistrationRequestFilter.pending => 'pending',
  };
}
