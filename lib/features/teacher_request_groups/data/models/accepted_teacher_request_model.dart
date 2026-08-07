class AcceptedTeacherRequestModel {
  const AcceptedTeacherRequestModel({
    required this.requestId,
    required this.classroomId,
    required this.chatRoomId,
  });

  final String requestId;
  final String classroomId;
  final String chatRoomId;

  factory AcceptedTeacherRequestModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? json['data'] as Map : const {};
    final classroom = data['classroom'] is Map
        ? data['classroom'] as Map
        : const {};
    final chatRoom = data['chatRoom'] is Map
        ? data['chatRoom'] as Map
        : const {};
    return AcceptedTeacherRequestModel(
      requestId: data['requestId']?.toString().trim() ?? '',
      classroomId: classroom['id']?.toString().trim() ?? '',
      chatRoomId: chatRoom['id']?.toString().trim() ?? '',
    );
  }
}
