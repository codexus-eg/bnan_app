class ChatParticipantModel {
  final String id;
  final String fullName;
  final String role;

  const ChatParticipantModel({
    required this.id,
    required this.fullName,
    required this.role,
  });

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) {
    return ChatParticipantModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}