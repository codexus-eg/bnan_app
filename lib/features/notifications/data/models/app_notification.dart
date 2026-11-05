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
    this.image,
    this.broadcastId,
    this.readAt,
  });

  final String id, type, key, title, body;
  final String? resourceId, resourceModel, image, broadcastId;
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
    image: image,
    broadcastId: broadcastId,
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
    navigation['screen'] ??=
        json['screen'] ?? data['screen'] ?? json['target'] ?? data['target'];
    navigation['target'] ??=
        json['target'] ?? data['target'] ?? json['screen'] ?? data['screen'];
    navigation['params'] ??= json['params'] ?? data['params'];
    final params = NotificationNavigation.decodeParams(navigation['params']);
    final resourceModel = _nullable(resource['model'] ?? json['resourceModel']);
    final broadcastId = _nullable(
      data['broadcastId'] ??
          json['broadcastId'] ??
          params['broadcastId'] ??
          (resourceModel == 'GlobalNotification' ? resource['id'] : null),
    );
    final sources = [json, data];
    for (final source in sources) {
      for (final key in const [
        'roomId',
        'chatRoomId',
        'room_id',
        'chat_room_id',
        'classroomId',
        'classroom_id',
        'classroomSubjectId',
        'subjectId',
        'sessionId',
        'session_id',
        'requestId',
        'subjectRequestId',
        'subject_request_id',
        'teacherId',
        'classroomName',
        'subjectName',
        'roomName',
        'chatName',
        'name',
        'messageId',
        'targetMessageId',
      ]) {
        if (source[key] != null) params.putIfAbsent(key, () => source[key]);
      }
      final classroom = source['classroom'];
      if (classroom is Map) {
        if (classroom['id'] != null) {
          params.putIfAbsent('classroomId', () => classroom['id']);
        }
        if (classroom['name'] != null) {
          params.putIfAbsent('roomName', () => classroom['name']);
        }
      }
      final room = source['room'] ?? source['chatRoom'];
      if (room is Map) {
        if (room['id'] != null) {
          params.putIfAbsent('roomId', () => room['id']);
        }
        if (room['name'] != null) {
          params.putIfAbsent('roomName', () => room['name']);
        }
      }
    }
    navigation['params'] = params;
    return AppNotification(
      id: _string(json['id'] ?? json['notificationId']),
      type: _string(json['type'] ?? json['notificationType']),
      key: _string(
        json['key'] ?? data['key'] ?? json['type'] ?? data['type'],
      ),
      title: _localizedString(json['title'] ?? json['_title'] ?? data['title']),
      body: _localizedString(json['body'] ?? json['_body'] ?? data['content']),
      resourceId: _nullable(resource['id'] ?? json['resourceId']),
      resourceModel: resourceModel,
      image: _nullable(json['image'] ?? data['image']),
      broadcastId: broadcastId,
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
    'image': image,
    'broadcastId': broadcastId,
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
