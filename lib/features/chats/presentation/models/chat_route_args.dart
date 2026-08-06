class ChatRouteArgs {
  const ChatRouteArgs({
    required this.roomId,
    this.roomType,
    this.classroomId,
    this.classroomName,
    this.currentUserRole,
  });

  final String roomId;
  final String? roomType;
  final String? classroomId;
  final String? classroomName;
  final String? currentUserRole;
}
