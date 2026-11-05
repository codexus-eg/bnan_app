class ScheduleSyncEvent {
  ScheduleSyncEvent({
    required this.reason,
    this.classroomId,
    this.studentId,
    this.registrationMode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String reason;
  final String? classroomId;
  final String? studentId;
  final String? registrationMode;
  final DateTime timestamp;
}
