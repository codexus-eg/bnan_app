enum UserRole {
  student,
  teacher,
  parent,
  supervisor,
  admin;

  static UserRole? fromValue(String? value) {
    final normalized = value?.trim().toLowerCase();
    for (final role in UserRole.values) {
      if (role.name == normalized) return role;
    }
    return null;
  }
}
