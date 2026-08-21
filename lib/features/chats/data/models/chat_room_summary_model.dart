class ChatRoomSummaryModel {
  final String id;
  final String type;
  final String displayName;
  final String subtitle;
  final String? classroomId;
  final String? accessScope;
  final String? classroomSubjectId;
  final bool? canRequestTeacherWithdrawal;
  final bool? classroomSubjectAmbiguous;
  final String? studentId;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ChatRoomSummaryModel({
    required this.id,
    required this.type,
    required this.displayName,
    required this.subtitle,
    this.classroomId,
    this.accessScope,
    this.classroomSubjectId,
    this.canRequestTeacherWithdrawal,
    this.classroomSubjectAmbiguous,
    this.studentId,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  factory ChatRoomSummaryModel.fromJson(Map<String, dynamic> json) {
    String? id(Object? value) {
      if (value is! String || value.trim().isEmpty) return null;
      return value.trim();
    }

    int parseUnreadCount(Object? value) {
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    String roleLabel(String role) {
      switch (role.trim().toLowerCase()) {
        case 'teacher':
          return 'معلم';
        case 'student':
          return 'طالب';
        case 'parent':
          return 'ولي أمر';
        case 'supervisor':
          return 'مشرف';
        case 'admin':
          return 'إدارة';
        default:
          return '';
      }
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
    final backendSubtitle = json['subtitle']?.toString().trim();

    final type = json['type']?.toString().trim().toLowerCase() ?? '';

    final student = participants.cast<Map>().firstWhere(
      (item) =>
          (participantData(item)['role'] ?? item['role'])
              ?.toString()
              .toLowerCase() ==
          'student',
      orElse: () => const {},
    );

    final studentData = participantData(student);

    final participantRole =
        (visibleParticipant['role'] ?? participant['role'] ?? '')
            .toString()
            .trim();

    String resolvedSubtitle;

    if (type == 'supervisor_student') {
      resolvedSubtitle = backendSubtitle ?? '';
    } else if (type == 'support') {
      final role = roleLabel(participantRole);
      resolvedSubtitle = role.isNotEmpty ? role : 'محادثة';
    } else if (type == 'classroom' ||
        type == 'classroom_group' ||
        directId != null ||
        legacyId != null) {
      resolvedSubtitle = 'فصل دراسي';
    } else {
      final role = roleLabel(participantRole);

      if (role.isNotEmpty) {
        resolvedSubtitle = role;
      } else if (backendSubtitle?.isNotEmpty == true) {
        resolvedSubtitle = backendSubtitle!;
      } else {
        resolvedSubtitle = 'محادثة';
      }
    }

    return ChatRoomSummaryModel(
      id: json['id']?.toString() ?? '',
      type: type,
      displayName: displayName?.isNotEmpty == true
          ? displayName!
          : (visibleParticipant['fullName'] ?? visibleParticipant['name'] ?? '')
                .toString(),
      subtitle: resolvedSubtitle,
      classroomId: directId ?? legacyId,
      accessScope: id(json['accessScope'])?.toLowerCase(),
      classroomSubjectId: id(json['classroomSubjectId']),
      canRequestTeacherWithdrawal: json['canRequestTeacherWithdrawal'] is bool
          ? json['canRequestTeacherWithdrawal'] as bool
          : null,
      classroomSubjectAmbiguous: json['classroomSubjectAmbiguous'] is bool
          ? json['classroomSubjectAmbiguous'] as bool
          : null,
      studentId: type == 'supervisor_student'
          ? id(studentData['id'] ?? studentData['_id'] ?? student['id'])
          : null,
      lastMessage: json['lastMessage']?.toString(),
      lastMessageAt: DateTime.tryParse(json['lastMessageAt']?.toString() ?? ''),
      unreadCount:
          (json['unreadCount'] as num?)?.toInt() ??
          parseUnreadCount(json['unreadMessagesCount'] ?? json['unread']),
    );
  }

  static const placeholder = ChatRoomSummaryModel(
    id: 'placeholder-id',
    type: 'support',
    displayName: 'اسم المستخدم',
    subtitle: 'نوع المحادثة',
    lastMessage: 'آخر رسالة في المحادثة',
    unreadCount: 0,
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
    String? accessScope,
    String? classroomSubjectId,
    bool? canRequestTeacherWithdrawal,
    bool? classroomSubjectAmbiguous,
    String? studentId,
    String? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return ChatRoomSummaryModel(
      id: id ?? this.id,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      subtitle: subtitle ?? this.subtitle,
      classroomId: classroomId ?? this.classroomId,
      accessScope: accessScope ?? this.accessScope,
      classroomSubjectId: classroomSubjectId ?? this.classroomSubjectId,
      canRequestTeacherWithdrawal:
          canRequestTeacherWithdrawal ?? this.canRequestTeacherWithdrawal,
      classroomSubjectAmbiguous:
          classroomSubjectAmbiguous ?? this.classroomSubjectAmbiguous,
      studentId: studentId ?? this.studentId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
