import 'package:bnan_app/features/notifications/data/models/app_notification.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.items = const [],
    this.unreadCount = 0,
    this.page = 1,
    this.hasNext = true,
    this.loadingMore = false,
    this.error,
  });
  final NotificationsStatus status;
  final List<AppNotification> items;
  final int unreadCount, page;
  final bool hasNext, loadingMore;
  final String? error;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? items,
    int? unreadCount,
    int? page,
    bool? hasNext,
    bool? loadingMore,
    String? error,
    bool clearError = false,
  }) => NotificationsState(
    status: status ?? this.status,
    items: items ?? this.items,
    unreadCount: unreadCount ?? this.unreadCount,
    page: page ?? this.page,
    hasNext: hasNext ?? this.hasNext,
    loadingMore: loadingMore ?? this.loadingMore,
    error: clearError ? null : error ?? this.error,
  );
}
