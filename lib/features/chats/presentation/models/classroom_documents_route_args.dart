class ClassroomDocumentsRouteArgs {
  const ClassroomDocumentsRouteArgs({
    required this.roomId,
    required this.roomType,
    required this.currentUserRole,
    this.classroomId,
    this.classroomName,
  });

  final String roomId;
  final String? classroomId;
  final String? roomType;
  final String? currentUserRole;
  final String? classroomName;
}
