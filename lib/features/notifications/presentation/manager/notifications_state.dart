import 'package:bnan_app/features/notifications/data/models/app_notification.dart';

enum NotificationsStatus { initial, loading, success, failure }

enum GlobalNotificationStatus { initial, loading, success, failure }

class NotificationsState {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.items = const [],
    this.unreadCount = 0,
    this.page = 1,
    this.totalPages = 1,
    this.hasNext = true,
    this.loadingMore = false,
    this.refreshing = false,
    this.error,
    this.globalStatus = GlobalNotificationStatus.initial,
    this.globalDetails,
    this.globalError,
  });
  final NotificationsStatus status;
  final List<AppNotification> items;
  final int unreadCount, page, totalPages;
  final bool hasNext, loadingMore, refreshing;
  final String? error;
  final GlobalNotificationStatus globalStatus;
  final AppNotification? globalDetails;
  final String? globalError;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? items,
    int? unreadCount,
    int? page,
    int? totalPages,
    bool? hasNext,
    bool? loadingMore,
    bool? refreshing,
    String? error,
    bool clearError = false,
    GlobalNotificationStatus? globalStatus,
    AppNotification? globalDetails,
    String? globalError,
    bool clearGlobalError = false,
    bool clearGlobalDetails = false,
  }) => NotificationsState(
    status: status ?? this.status,
    items: items ?? this.items,
    unreadCount: unreadCount ?? this.unreadCount,
    page: page ?? this.page,
    totalPages: totalPages ?? this.totalPages,
    hasNext: hasNext ?? this.hasNext,
    loadingMore: loadingMore ?? this.loadingMore,
    refreshing: refreshing ?? this.refreshing,
    error: clearError ? null : error ?? this.error,
    globalStatus: globalStatus ?? this.globalStatus,
    globalDetails: clearGlobalDetails
        ? null
        : globalDetails ?? this.globalDetails,
    globalError: clearGlobalError ? null : globalError ?? this.globalError,
  );
}
