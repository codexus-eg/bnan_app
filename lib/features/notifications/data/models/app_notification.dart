import 'package:bnan_app/features/notifications/data/models/notification_navigation.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.key,
    required this.title,
    required this.body,
    required this.navigation,
    required this.data,
    required this.isRead,
    required this.createdAt,
    this.resourceId,
    this.resourceModel,
    this.readAt,
  });

  final String id, type, key, title, body;
  final String? resourceId, resourceModel;
  final NotificationNavigation navigation;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime? readAt, createdAt;

  AppNotification copyWith({bool? isRead, DateTime? readAt}) => AppNotification(
    id: id,
    type: type,
    key: key,
    title: title,
    body: body,
    navigation: navigation,
    data: data,
    resourceId: resourceId,
    resourceModel: resourceModel,
    createdAt: createdAt,
    isRead: isRead ?? this.isRead,
    readAt: readAt ?? this.readAt,
  );

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final resource = _map(json['resource']);
    final data = _map(json['data']);
    final navigation = _map(json['navigation']);
    navigation['screen'] ??= json['screen'];
    navigation['target'] ??= json['target'];
    navigation['params'] ??= json['params'];
    final params = NotificationNavigation.decodeParams(navigation['params']);
    final sources = [json, data];
    for (final source in sources) {
      for (final key in const ['roomId', 'roomName', 'chatName', 'name']) {
        if (source[key] != null) params.putIfAbsent(key, () => source[key]);
      }
    }
    navigation['params'] = params;
    return AppNotification(
      id: _string(json['id'] ?? json['notificationId']),
      type: _string(json['type'] ?? json['notificationType']),
      key: _string(json['key']),
      title: _string(json['title'] ?? json['_title']),
      body: _string(json['body'] ?? json['_body']),
      resourceId: _nullable(resource['id'] ?? json['resourceId']),
      resourceModel: _nullable(resource['model'] ?? json['resourceModel']),
      navigation: NotificationNavigation.fromJson(navigation),
      data: data,
      isRead:
          json['isRead'] == true ||
          _string(json['status']).toLowerCase() == 'read',
      readAt: _date(json['readAt']),
      createdAt: _date(json['createdAt']),
    );
  }

  Map<String, dynamic> toPayload() => {
    'notificationId': id,
    'notificationType': type,
    'key': key,
    '_title': title,
    '_body': body,
    'resourceId': resourceId,
    'resourceModel': resourceModel,
    'screen': navigation.screen,
    'target': navigation.target,
    'params': navigation.params,
    ...data,
  };
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : {};
String _string(dynamic value) => value?.toString().trim() ?? '';
String? _nullable(dynamic value) =>
    _string(value).isEmpty ? null : _string(value);
DateTime? _date(dynamic value) => DateTime.tryParse(_string(value));
