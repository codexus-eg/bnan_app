class ChatRoomSummaryModel {
  final String id;
  final String type;
  final String displayName;
  final String subtitle;
  final String? classroomId;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  const ChatRoomSummaryModel({
    required this.id,
    required this.type,
    required this.displayName,
    required this.subtitle,
    this.classroomId,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory ChatRoomSummaryModel.fromJson(Map<String, dynamic> json) {
    String? id(Object? value) {
      if (value is! String || value.trim().isEmpty) return null;
      return value.trim();
    }

    final classroom = json['classroom'];
    final directId = id(json['classroomId']);
    final legacyId = classroom is Map
        ? id(classroom['id']) ?? id(classroom['_id'])
        : id(classroom);
    final participants = (json['participants'] as List? ?? const [])
        .whereType<Map>();
    Map participantData(Map item) =>
        item['user'] is Map ? item['user'] as Map : item;
    final participant = participants.cast<Map>().firstWhere(
      (item) =>
          (participantData(item)['role'] ?? item['role'])
              ?.toString()
              .toLowerCase() !=
          'admin',
      orElse: () => const {},
    );
    final visibleParticipant = participantData(participant);
    final displayName = json['displayName']?.toString().trim();
    final subtitle = json['subtitle']?.toString().trim();
    final type = json['type']?.toString() ?? '';
    final participantRole =
        (visibleParticipant['role'] ?? participant['role'] ?? '').toString();
    return ChatRoomSummaryModel(
      id: json['id']?.toString() ?? '',
      type: type,
      displayName: displayName?.isNotEmpty == true
          ? displayName!
          : (visibleParticipant['fullName'] ?? visibleParticipant['name'] ?? '')
                .toString(),
      subtitle: type == 'support' && participantRole.trim().isNotEmpty
          ? participantRole
          : subtitle?.isNotEmpty == true
          ? subtitle!
          : participantRole,
      classroomId: directId ?? legacyId,
      lastMessage: json['lastMessage']?.toString(),
      lastMessageAt: DateTime.tryParse(json['lastMessageAt']?.toString() ?? ''),
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
    String? classroomId,
    String? lastMessage,
    DateTime? lastMessageAt,
  }) {
    return ChatRoomSummaryModel(
      id: id ?? this.id,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      subtitle: subtitle ?? this.subtitle,
      classroomId: classroomId ?? this.classroomId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}
