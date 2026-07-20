class ChatRoomSummaryModel {
  final String id;
  final String type;
  final String displayName;
  final String subtitle;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  const ChatRoomSummaryModel({
    required this.id,
    required this.type,
    required this.displayName,
    required this.subtitle,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory ChatRoomSummaryModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomSummaryModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      lastMessage: json['lastMessage']?.toString(),
      lastMessageAt: DateTime.tryParse(
        json['lastMessageAt']?.toString() ?? '',
      ),
    );
  }

  static const placeholder = ChatRoomSummaryModel(
    id: 'placeholder-id',
    type: 'support',
    displayName: 'اسم المستخدم',
    subtitle: 'المرحلة الدراسية',
    lastMessage: 'آخر رسالة في المحادثة',
  );

  static const placeholders = [
    placeholder,
    placeholder,
    placeholder,
    placeholder,
    placeholder,
    placeholder,
  ];

  ChatRoomSummaryModel copyWith({
    String? id,
    String? type,
    String? displayName,
    String? subtitle,
    String? lastMessage,
    DateTime? lastMessageAt,
  }) {
    return ChatRoomSummaryModel(
      id: id ?? this.id,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      subtitle: subtitle ?? this.subtitle,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}