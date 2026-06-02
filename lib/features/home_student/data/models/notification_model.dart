class NotificationModel {
  const NotificationModel({
    required this.title,
    required this.time,
    this.isUnread = false,
  });

  final String title;
  final String time;
  final bool isUnread;
}