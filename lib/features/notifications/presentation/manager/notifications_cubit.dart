import 'dart:async';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/data/repos/notifications_repo.dart';
import 'package:bnan_app/features/notifications/domain/recent_notification_ids.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/generated/l10n.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repo, this._socket, this._recent)
    : super(const NotificationsState());
  final NotificationsRepo _repo;
  final SocketService _socket;
  final RecentNotificationIds _recent;
  final _incoming = StreamController<AppNotification>.broadcast();
  final List<VoidCallback> _removeSocketListeners = [];
  bool _initialized = false;
  int _loadRevision = 0;
  Set<String> _refreshBaselineIds = {};
  static const _limit = 20;
  Stream<AppNotification> get incoming => _incoming.stream;

  void ingestSocketNotification(Map<String, dynamic> json) {
    final payload = Map<String, dynamic>.from(json);
    if (_key(payload) == 'STUDENT_CALL_ALERT') {
      payload['_title'] ??= S.current.studentCallAlertTitle;
      payload['_body'] ??= S.current.studentCallAlertBody;
      payload['screen'] = 'student_home';
    }
    ingest(AppNotification.fromJson(payload));
  }

  String _key(Map<String, dynamic> json) =>
      (json['key'] ?? (json['data'] is Map ? json['data']['key'] : null))
          ?.toString()
          .trim()
          .toUpperCase() ??
      '';

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    SessionManager.instance.addSessionChangeListener(_sessionChanged);
    if (SessionManager.instance.userId?.isNotEmpty == true) {
      await _start();
    }
  }

  Future<void> _start() async {
    try {
      await _socket.connect();
      if (_removeSocketListeners.isEmpty) {
        void handleNudge(Map<String, dynamic> json) =>
            ingestSocketNotification(json);
        _removeSocketListeners.addAll([_socket.listenToChatNudge(handleNudge)]);
      }
      await load(refresh: true);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Notifications start failed: ${error.runtimeType}');
      }
    }
  }

  Future<void> load({bool refresh = false}) async {
    if (refresh) {
      if (state.refreshing) return;
      _refreshBaselineIds = state.items.map(_notificationKey).toSet();
    } else if (state.refreshing || state.loadingMore || !state.hasNext) {
      return;
    }
    final revision = refresh ? ++_loadRevision : _loadRevision;
    final page = refresh ? 1 : state.page + 1;
    emit(
      state.copyWith(
        status: refresh ? NotificationsStatus.loading : state.status,
        loadingMore: !refresh,
        refreshing: refresh,
        clearError: true,
      ),
    );
    final result = await _repo.getNotifications(page, _limit);
    if (isClosed || revision != _loadRevision) return;
    result.fold(
      (failure) => emit(_failureState(failure.message)),
      (value) => _mergePage(
        value.items,
        value.unreadCount,
        value.page,
        value.totalPages,
        value.hasNext,
        refresh,
      ),
    );
  }

  void _mergePage(
    List<AppNotification> values,
    int unread,
    int page,
    int totalPages,
    bool hasNext,
    bool refresh,
  ) {
    final merged = <String, AppNotification>{};
    final arrivedDuringRefresh = refresh
        ? state.items.where(
            (item) => !_refreshBaselineIds.contains(_notificationKey(item)),
          )
        : const Iterable<AppNotification>.empty();
    for (final item in [
      ...refresh ? arrivedDuringRefresh : state.items,
      ...values,
    ]) {
      merged[_notificationKey(item)] = item;
    }
    _refreshBaselineIds = {};
    emit(
      state.copyWith(
        status: NotificationsStatus.success,
        items: merged.values.toList(),
        unreadCount: unread,
        page: page,
        totalPages: totalPages,
        hasNext: hasNext,
        loadingMore: false,
        refreshing: false,
        clearError: true,
      ),
    );
  }

  NotificationsState _failureState(String message) {
    _refreshBaselineIds = {};
    return state.copyWith(
      status: state.items.isEmpty ? NotificationsStatus.failure : state.status,
      loadingMore: false,
      refreshing: false,
      error: message,
    );
  }

  String _notificationKey(AppNotification item) =>
      item.id.isEmpty ? '${item.key}|${item.createdAt}' : item.id;

  bool ingest(AppNotification value, {bool emitIncoming = true}) {
    if (!_recent.claim(value.id)) return false;
    if (value.id.isNotEmpty && state.items.any((item) => item.id == value.id)) {
      return false;
    }
    final items = [value, ...state.items.where((item) => item.id != value.id)];
    emit(
      state.copyWith(
        status: NotificationsStatus.success,
        items: items,
        unreadCount: state.unreadCount + (value.isRead ? 0 : 1),
      ),
    );
    if (emitIncoming) _incoming.add(value);
    return true;
  }

  Future<void> markRead(AppNotification value) async {
    if (value.isRead) return;
    emit(
      state.copyWith(
        items: state.items
            .map(
              (item) => item.id == value.id
                  ? item.copyWith(isRead: true, readAt: DateTime.now())
                  : item,
            )
            .toList(),
        unreadCount: (state.unreadCount - 1).clamp(0, 1 << 30),
      ),
    );
    await _repo.markRead(ids: [value.id]);
  }

  Future<void> markAllRead() async {
    if (state.unreadCount == 0) return;
    emit(
      state.copyWith(
        items: state.items
            .map((item) => item.copyWith(isRead: true, readAt: DateTime.now()))
            .toList(),
        unreadCount: 0,
      ),
    );
    await _repo.markRead(all: true);
  }

  Future<void> markSelected(Iterable<String> notificationIds) async {
    final ids = notificationIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet();
    if (ids.isEmpty) return;
    final unread = state.items
        .where((item) => ids.contains(item.id) && !item.isRead)
        .length;
    emit(
      state.copyWith(
        items: state.items
            .map(
              (item) => ids.contains(item.id)
                  ? item.copyWith(isRead: true, readAt: DateTime.now())
                  : item,
            )
            .toList(),
        unreadCount: (state.unreadCount - unread).clamp(0, 1 << 30),
      ),
    );
    await _repo.markRead(ids: ids.toList());
  }

  Future<void> _sessionChanged(String? previous, String? next) async {
    _loadRevision++;
    _refreshBaselineIds = {};
    for (final remove in _removeSocketListeners) {
      remove();
    }
    _removeSocketListeners.clear();
    _recent.clear();
    emit(const NotificationsState());
    if (next?.isNotEmpty == true) await _start();
  }

  @override
  Future<void> close() async {
    _loadRevision++;
    for (final remove in _removeSocketListeners) {
      remove();
    }
    SessionManager.instance.removeSessionChangeListener(_sessionChanged);
    await _incoming.close();
    return super.close();
  }
}
