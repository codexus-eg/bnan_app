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
    final nested = json['user'];
    final sender = nested is Map ? Map<String, dynamic>.from(nested) : json;
    return ChatSenderModel(
      id: (sender['id'] ?? sender['_id'])?.toString() ?? '',
      fullName: (sender['fullName'] ?? sender['name'])?.toString() ?? '',
      role: (sender['role'] ?? json['role'])?.toString() ?? '',
    );
  }
}
