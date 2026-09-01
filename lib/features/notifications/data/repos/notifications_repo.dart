import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/notifications/data/models/notification_preferences.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/data/models/notifications_page.dart';
import 'package:dartz/dartz.dart';

abstract interface class NotificationsRepo {
  Future<Either<Failure, NotificationsPage>> getNotifications(
    int page,
    int limit,
  );
  Future<Either<Failure, void>> markRead({
    List<String> ids = const [],
    bool all = false,
  });
  Future<Either<Failure, AppNotification>> getGlobalNotificationDetails(
    String broadcastId,
  );
  Future<Either<Failure, NotificationPreferences>> getPreferences();
  Future<Either<Failure, NotificationPreferences>> updatePreferences(
    NotificationPreferences value,
  );
}
