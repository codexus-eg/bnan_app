import 'dart:convert';

class ChatNotificationModel {
  final String notificationId;
  final String type;
  final String key;
  final String notificationType;
  final ChatNotificationResourceModel resource;
  final ChatNotificationDataModel data;
  final ChatLocalizedTextModel title;
  final ChatLocalizedTextModel body;

  const ChatNotificationModel({
    required this.notificationId,
    required this.type,
    required this.key,
    required this.notificationType,
    required this.resource,
    required this.data,
    required this.title,
    required this.body,
  });

  factory ChatNotificationModel.fromJson(Map<String, dynamic> json) {
    final rawData = Map<String, dynamic>.from(json['data'] as Map? ?? {});
    final params = _params(rawData['params']);
    for (final key in [
      'roomId',
      'roomName',
      'chatName',
      'name',
      'messageId',
      'senderId',
    ]) {
      rawData.putIfAbsent(key, () => params[key]);
    }
    for (final key in [
      'roomId',
      'room',
      'roomName',
      'chatName',
      'name',
      'messageId',
      'senderId',
      'sender',
    ]) {
      rawData.putIfAbsent(key, () => json[key]);
    }
    return ChatNotificationModel(
      notificationId:
          (json['notificationId'] ?? json['id'] ?? rawData['notificationId'])
              ?.toString()
              .trim() ??
          '',
      type: json['type']?.toString() ?? '',
      key: (json['key'] ?? rawData['key'])?.toString() ?? '',
      notificationType:
          (json['notificationType'] ?? rawData['notificationType'])
              ?.toString() ??
          '',
      resource: ChatNotificationResourceModel.fromJson(
        Map<String, dynamic>.from(json['resource'] as Map? ?? {}),
      ),
      data: ChatNotificationDataModel.fromJson(rawData),
      title: ChatLocalizedTextModel.fromJson(
        Map<String, dynamic>.from(json['title'] as Map? ?? {}),
      ),
      body: ChatLocalizedTextModel.fromJson(
        Map<String, dynamic>.from(json['body'] as Map? ?? {}),
      ),
    );
  }

  bool get isChatMessage =>
      key.trim().toUpperCase() == 'NEW_MESSAGE' ||
      notificationType.trim().toLowerCase() == 'chat';

  static Map<String, dynamic> _params(dynamic value) {
    try {
      final decoded = value is String ? jsonDecode(value) : value;
      return decoded is Map ? Map<String, dynamic>.from(decoded) : {};
    } catch (_) {
      return {};
    }
  }
}

class ChatNotificationResourceModel {
  final String id;
  final String model;

  const ChatNotificationResourceModel({required this.id, required this.model});

  factory ChatNotificationResourceModel.fromJson(Map<String, dynamic> json) {
    return ChatNotificationResourceModel(
      id: json['id']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
    );
  }
}

class ChatNotificationDataModel {
  final String senderName;
  final String senderId;
  final String roomId;
  final String messageId;
  final String message;
  final String roomName;

  const ChatNotificationDataModel({
    required this.senderName,
    required this.senderId,
    required this.roomId,
    required this.messageId,
    required this.message,
    this.roomName = '',
  });

  factory ChatNotificationDataModel.fromJson(Map<String, dynamic> json) {
    return ChatNotificationDataModel(
      senderName: json['senderName']?.toString() ?? '',
      senderId: _id(json['senderId'] ?? json['sender']),
      roomId: _id(json['roomId'] ?? json['room']),
      messageId: _id(json['messageId']),
      message: json['message']?.toString() ?? '',
      roomName: _name(json),
    );
  }

  static String _id(dynamic value) {
    if (value is Map) {
      return value['id']?.toString() ?? value['_id']?.toString() ?? '';
    }
    return value?.toString() ?? '';
  }

  static String _name(Map<String, dynamic> json) {
    for (final key in const ['roomName', 'chatName', 'name']) {
      final value = json[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return '';
  }
}

class ChatLocalizedTextModel {
  final String ar;
  final String en;

  const ChatLocalizedTextModel({required this.ar, required this.en});

  factory ChatLocalizedTextModel.fromJson(Map<String, dynamic> json) {
    return ChatLocalizedTextModel(
      ar: json['ar']?.toString() ?? '',
      en: json['en']?.toString() ?? '',
    );
  }
}
