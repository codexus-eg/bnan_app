class ChatRouteArgs {
  const ChatRouteArgs({
    this.roomType,
    this.classroomId,
    this.classroomName,
    this.currentUserRole,
    this.studentId,
  });

  final String? roomType;
  final String? classroomId;
  final String? classroomName;
  final String? currentUserRole;
  final String? studentId;
}

