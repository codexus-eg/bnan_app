import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/data/models/notification_preferences.dart';
import 'package:bnan_app/features/notifications/data/models/notifications_page.dart';
import 'package:bnan_app/features/notifications/data/repos/notifications_repo.dart';
import 'package:bnan_app/features/notifications/domain/recent_notification_ids.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('incoming and optimistic read keep unread badge in sync', () async {
    final repo = _Repo();
    final cubit = NotificationsCubit(
      repo,
      SocketService(),
      RecentNotificationIds(),
    );
    final item = AppNotification.fromJson({'id': 'n1', 'title': 'Hello'});
    expect(cubit.ingest(item), isTrue);
    expect(cubit.ingest(item), isFalse);
    expect(cubit.state.unreadCount, 1);
    await cubit.markRead(item);
    expect(cubit.state.unreadCount, 0);
    expect(repo.readIds, ['n1']);
    await cubit.close();
  });
}

class _Repo implements NotificationsRepo {
  List<String> readIds = [];
  @override
  Future<Either<Failure, void>> markRead({
    List<String> ids = const [],
    bool all = false,
  }) async {
    readIds = ids;
    return const Right(null);
  }

  @override
  Future<Either<Failure, NotificationsPage>> getNotifications(
    int page,
    int limit,
  ) => throw UnimplementedError();
  @override
  Future<Either<Failure, NotificationPreferences>> getPreferences() =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, NotificationPreferences>> updatePreferences(
    NotificationPreferences value,
  ) => throw UnimplementedError();
}
