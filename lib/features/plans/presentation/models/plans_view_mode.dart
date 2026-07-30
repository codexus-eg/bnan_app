enum PlansViewMode {
  supervisor,
  teacher,
  student;

  factory PlansViewMode.fromRole(String? role) {
    return switch (role?.trim().toLowerCase()) {
      'supervisor' => PlansViewMode.supervisor,
      'teacher' => PlansViewMode.teacher,
      _ => PlansViewMode.student,
    };
  }
}
