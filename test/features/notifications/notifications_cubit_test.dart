import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/data/models/notification_preferences.dart';
import 'package:bnan_app/features/notifications/data/models/notifications_page.dart';
import 'package:bnan_app/features/notifications/data/repos/notifications_repo.dart';
import 'package:bnan_app/features/notifications/domain/recent_notification_ids.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:dartz/dartz.dart';
import 'dart:async';
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

  test(
    'student calls deduplicate by callId instead of notificationId',
    () async {
      final cubit = NotificationsCubit(
        _Repo(),
        SocketService(),
        RecentNotificationIds(),
      );
      final first = AppNotification.fromJson({
        'notificationId': 'shared-notification',
        'key': 'STUDENT_CALL_ALERT',
        'callId': 'call-1',
      });
      final second = AppNotification.fromJson({
        'notificationId': 'shared-notification',
        'key': 'STUDENT_CALL_ALERT',
        'callId': 'call-2',
      });

      expect(cubit.ingest(first), isTrue);
      expect(cubit.ingest(first), isFalse);
      expect(cubit.ingest(second), isTrue);
      await cubit.close();
    },
  );

  test(
    'loads pages once, appends unique items, and refresh resets to page 1',
    () async {
      final repo = _Repo()
        ..pages = {
          1: _page(1, 3, ['n1', 'n2']),
          2: _page(2, 3, ['n2', 'n3']),
          3: _page(3, 3, ['n4']),
        };
      final cubit = NotificationsCubit(
        repo,
        SocketService(),
        RecentNotificationIds(),
      );

      await cubit.load(refresh: true);
      await cubit.load();
      await cubit.load();
      await cubit.load();

      expect(repo.requestedPages, [1, 2, 3]);
      expect(cubit.state.items.map((item) => item.id), [
        'n1',
        'n2',
        'n3',
        'n4',
      ]);
      expect(cubit.state.hasNext, isFalse);

      await cubit.load(refresh: true);
      expect(repo.requestedPages, [1, 2, 3, 1]);
      expect(cubit.state.items.map((item) => item.id), ['n1', 'n2']);
      await cubit.close();
    },
  );

  test(
    'blocks duplicate refresh and load-more while refresh is pending',
    () async {
      final pending = Completer<Either<Failure, NotificationsPage>>();
      final repo = _Repo()..pending = pending;
      final cubit = NotificationsCubit(
        repo,
        SocketService(),
        RecentNotificationIds(),
      );

      final first = cubit.load(refresh: true);
      await cubit.load(refresh: true);
      await cubit.load();

      expect(repo.requestedPages, [1]);
      pending.complete(Right(_page(1, 1, ['n1'])));
      await first;
      await cubit.close();
    },
  );

  test('global details marks the individual notification id read', () async {
    final repo = _Repo()
      ..globalDetails = AppNotification.fromJson({
        'id': 'individual-id',
        'key': 'GLOBAL_NOTIFICATION',
        'data': {'broadcastId': 'broadcast-id'},
      });
    final cubit = NotificationsCubit(
      repo,
      SocketService(),
      RecentNotificationIds(),
    );

    await cubit.loadGlobalDetails('broadcast-id');

    expect(repo.requestedBroadcastId, 'broadcast-id');
    expect(repo.readIds, ['individual-id']);
    expect(cubit.state.globalDetails?.id, 'individual-id');
    await cubit.close();
  });
}

NotificationsPage _page(int page, int totalPages, List<String> ids) =>
    NotificationsPage(
      items: ids.map((id) => AppNotification.fromJson({'id': id})).toList(),
      unreadCount: ids.length,
      page: page,
      totalPages: totalPages,
      hasNext: page < totalPages,
    );

class _Repo implements NotificationsRepo {
  List<String> readIds = [];
  Map<int, NotificationsPage> pages = {};
  final List<int> requestedPages = [];
  Completer<Either<Failure, NotificationsPage>>? pending;
  AppNotification? globalDetails;
  String? requestedBroadcastId;

  @override
  Future<Either<Failure, AppNotification>> getGlobalNotificationDetails(
    String broadcastId,
  ) async {
    requestedBroadcastId = broadcastId;
    return Right(globalDetails!);
  }

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
  ) async {
    requestedPages.add(page);
    if (pending case final value?) return value.future;
    return Right(pages[page]!);
  }

  @override
  Future<Either<Failure, NotificationPreferences>> getPreferences() =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, NotificationPreferences>> updatePreferences(
    NotificationPreferences value,
  ) => throw UnimplementedError();
}
