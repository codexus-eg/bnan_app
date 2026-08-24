import 'package:bnan_app/features/notifications/data/models/notification_navigation.dart';
import 'package:intl/intl.dart';

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

  bool get isStudentCallAlert =>
      key.trim().toUpperCase() == 'STUDENT_CALL_ALERT';
  String get callAttemptId => _string(
    data['callId'] ??
        data['requestId'] ??
        navigation.params['callId'] ??
        navigation.params['requestId'],
  );

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
    for (final key in const ['callId', 'requestId']) {
      if (json[key] != null) data.putIfAbsent(key, () => json[key]);
    }
    final navigation = _map(json['navigation']);
    navigation['screen'] ??= json['screen'];
    navigation['target'] ??= json['target'];
    navigation['params'] ??= json['params'];
    final params = NotificationNavigation.decodeParams(navigation['params']);
    final sources = [json, data];
    for (final source in sources) {
      for (final key in const [
        'roomId',
        'classroomId',
        'roomName',
        'chatName',
        'name',
        'messageId',
        'targetMessageId',
      ]) {
        if (source[key] != null) params.putIfAbsent(key, () => source[key]);
      }
    }
    navigation['params'] = params;
    return AppNotification(
      id: _string(json['id'] ?? json['notificationId']),
      type: _string(json['type'] ?? json['notificationType']),
      key: _string(json['key']),
      title: _localizedString(json['title'] ?? json['_title']),
      body: _localizedString(json['body'] ?? json['_body']),
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
String _localizedString(dynamic value) {
  if (value is! Map) return _string(value);
  final values = Map<String, dynamic>.from(value);
  final language = Intl.defaultLocale?.split(RegExp('[-_]')).first;
  return _string(values[language] ?? values['ar'] ?? values['en']);
}

String? _nullable(dynamic value) =>
    _string(value).isEmpty ? null : _string(value);
DateTime? _date(dynamic value) => DateTime.tryParse(_string(value));
