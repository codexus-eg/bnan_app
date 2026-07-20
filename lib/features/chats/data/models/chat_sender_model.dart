class ChatSenderModel {
  final String id;
  final String fullName;
  final String role;

  const ChatSenderModel({
    required this.id,
    required this.fullName,
    required this.role,
  });

  factory ChatSenderModel.fromJson(Map<String, dynamic> json) {
    return ChatSenderModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}
