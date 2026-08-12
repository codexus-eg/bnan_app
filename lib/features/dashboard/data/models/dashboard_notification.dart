import 'package:bnan_app/features/dashboard/data/models/dashboard_parsing.dart';

class DashboardNotification {
  const DashboardNotification({
    required this.title,
    required this.time,
    required this.isRead,
    required this.type,
    required this.resource,
    required this.data,
  });

  final String title, time, type;
  final bool isRead;
  final Map<String, dynamic> resource, data;

  factory DashboardNotification.fromJson(Map<String, dynamic> json) {
    final title = json['title'];
    final localized = dashboardMap(title);
    return DashboardNotification(
      title: localized.isEmpty
          ? dashboardString(title ?? json['body'] ?? json['message'])
          : dashboardString(localized['ar'] ?? localized['en']),
      time: dashboardString(json['createdAt'] ?? json['time']),
      isRead: dashboardBool(json['isRead']),
      type: dashboardString(json['type'] ?? json['notificationType']),
      resource: dashboardMap(json['resource']),
      data: dashboardMap(json['data']),
    );
  }

  String get roomId =>
      dashboardString(data['roomId'] ?? data['room'] ?? resource['roomId']);
}
