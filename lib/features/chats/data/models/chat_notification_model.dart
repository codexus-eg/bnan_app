class ChatNotificationModel {
  final String type;
  final String key;
  final ChatNotificationResourceModel resource;
  final ChatNotificationDataModel data;
  final ChatLocalizedTextModel title;
  final ChatLocalizedTextModel body;

  const ChatNotificationModel({
    required this.type,
    required this.key,
    required this.resource,
    required this.data,
    required this.title,
    required this.body,
  });

  factory ChatNotificationModel.fromJson(Map<String, dynamic> json) {
    final rawData = Map<String, dynamic>.from(json['data'] as Map? ?? {});
    for (final key in ['roomId', 'room', 'messageId', 'senderId', 'sender']) {
      rawData.putIfAbsent(key, () => json[key]);
    }
    return ChatNotificationModel(
      type: json['type']?.toString() ?? '',
      key: json['key']?.toString() ?? '',
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

  const ChatNotificationDataModel({
    required this.senderName,
    required this.senderId,
    required this.roomId,
    required this.messageId,
    required this.message,
  });

  factory ChatNotificationDataModel.fromJson(Map<String, dynamic> json) {
    return ChatNotificationDataModel(
      senderName: json['senderName']?.toString() ?? '',
      senderId: _id(json['senderId'] ?? json['sender']),
      roomId: _id(json['roomId'] ?? json['room']),
      messageId: _id(json['messageId']),
      message: json['message']?.toString() ?? '',
    );
  }

  static String _id(dynamic value) {
    if (value is Map) {
      return value['id']?.toString() ?? value['_id']?.toString() ?? '';
    }
    return value?.toString() ?? '';
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
