class ChatRouteArgs {
  const ChatRouteArgs({
    this.roomType,
    this.classroomId,
    this.accessScope,
    this.classroomSubjectId,
    this.canRequestTeacherWithdrawal = false,
    this.classroomSubjectAmbiguous = false,
    this.classroomName,
    this.currentUserRole,
    this.studentId,
    this.targetMessageId,
  });

  final String? roomType;
  final String? classroomId;
  final String? accessScope;
  final String? classroomSubjectId;
  final bool canRequestTeacherWithdrawal;
  final bool classroomSubjectAmbiguous;
  final String? classroomName;
  final String? currentUserRole;
  final String? studentId;
  final String? targetMessageId;
}
