import 'dart:convert';

class ChatPushIntent {
  const ChatPushIntent({
    required this.roomId,
    required this.messageId,
    required this.senderId,
    required this.notificationId,
    required this.title,
    required this.body,
    this.roomName = '',
  });

  final String roomId, messageId, senderId, notificationId, title, body;
  final String roomName;
  String get dedupKey => notificationId.isNotEmpty ? notificationId : messageId;

  static ChatPushIntent? tryParse(
    Map<String, dynamic> data, {
    String title = '',
    String body = '',
  }) {
    final key = _text(data['key']).toUpperCase();
    final type = _text(data['notificationType']).toLowerCase();
    if (key != 'NEW_MESSAGE' && type != 'chat') return null;
    final fallback = _params(data['params']);
    final roomId = _text(
      data['resourceId'] ??
          fallback['roomId'] ??
          fallback['chatId'] ??
          data['roomId'],
    );
    if (roomId.isEmpty) return null;
    return ChatPushIntent(
      roomId: roomId,
      messageId: _text(data['messageId'] ?? fallback['messageId']),
      senderId: _text(data['senderId'] ?? fallback['senderId']),
      notificationId: _text(data['notificationId']),
      title: title,
      body: body,
      roomName: _roomName(data, fallback),
    );
  }

  static Map<String, dynamic> _params(dynamic value) {
    try {
      final decoded = value is String ? jsonDecode(value) : value;
      return decoded is Map ? Map<String, dynamic>.from(decoded) : {};
    } catch (_) {
      return {};
    }
  }

  static String _text(dynamic value) => value?.toString().trim() ?? '';

  static String _roomName(
    Map<String, dynamic> data,
    Map<String, dynamic> params,
  ) {
    for (final key in const ['roomName', 'chatName', 'name', 'title']) {
      final value = _text(params[key] ?? data[key]);
      if (value.isNotEmpty) return value;
    }
    return '';
  }
}
