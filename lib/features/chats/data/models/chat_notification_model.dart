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
    return ChatNotificationModel(
      type: json['type']?.toString() ?? '',
      key: json['key']?.toString() ?? '',
      resource: ChatNotificationResourceModel.fromJson(
        Map<String, dynamic>.from(
          json['resource'] as Map? ?? {},
        ),
      ),
      data: ChatNotificationDataModel.fromJson(
        Map<String, dynamic>.from(
          json['data'] as Map? ?? {},
        ),
      ),
      title: ChatLocalizedTextModel.fromJson(
        Map<String, dynamic>.from(
          json['title'] as Map? ?? {},
        ),
      ),
      body: ChatLocalizedTextModel.fromJson(
        Map<String, dynamic>.from(
          json['body'] as Map? ?? {},
        ),
      ),
    );
  }
}

class ChatNotificationResourceModel {
  final String id;
  final String model;

  const ChatNotificationResourceModel({
    required this.id,
    required this.model,
  });

  factory ChatNotificationResourceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ChatNotificationResourceModel(
      id: json['id']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
    );
  }
}

class ChatNotificationDataModel {
  final String senderName;
  final String message;

  const ChatNotificationDataModel({
    required this.senderName,
    required this.message,
  });

  factory ChatNotificationDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ChatNotificationDataModel(
      senderName: json['senderName']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}

class ChatLocalizedTextModel {
  final String ar;
  final String en;

  const ChatLocalizedTextModel({
    required this.ar,
    required this.en,
  });

  factory ChatLocalizedTextModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ChatLocalizedTextModel(
      ar: json['ar']?.toString() ?? '',
      en: json['en']?.toString() ?? '',
    );
  }
}