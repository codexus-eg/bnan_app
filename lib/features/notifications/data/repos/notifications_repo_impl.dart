import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/notifications/data/models/notification_preferences.dart';
import 'package:bnan_app/features/notifications/data/models/notifications_page.dart';
import 'package:bnan_app/features/notifications/data/repos/notifications_repo.dart';
import 'package:dartz/dartz.dart';

class NotificationsRepoImpl implements NotificationsRepo {
  const NotificationsRepoImpl(this._api);
  final ApiConsumer _api;

  @override
  Future<Either<Failure, NotificationsPage>> getNotifications(
    int page,
    int limit,
  ) => _guard(
    () async => NotificationsPage.fromJson(
      await _api.get(
        EndPoints.notifications,
        queryParameter: {'page': page, 'limit': limit},
        isProtected: true,
      ),
    ),
  );

  @override
  Future<Either<Failure, void>> markRead({
    List<String> ids = const [],
    bool all = false,
  }) => _guard(() async {
    await _api.patch(
      EndPoints.notificationsRead,
      data: all ? {'all': true} : {'notificationIds': ids},
      isProtected: true,
    );
  });

  @override
  Future<Either<Failure, NotificationPreferences>> getPreferences() => _guard(
    () async => NotificationPreferences.fromJson(
      await _api.get(EndPoints.notificationPreferences, isProtected: true),
    ),
  );

  @override
  Future<Either<Failure, NotificationPreferences>> updatePreferences(
    NotificationPreferences value,
  ) => _guard(() async {
    final response = await _api.patch(
      EndPoints.notificationPreferences,
      data: value.toJson(),
      isProtected: true,
    );
    return response is Map ? NotificationPreferences.fromJson(response) : value;
  });
}

Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on AppException catch (error) {
    return Left(Failure(message: error.message));
  } catch (error) {
    return Left(Failure(message: error.toString()));
  }
}
