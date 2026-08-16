import 'package:bnan_app/features/notifications/data/models/app_notification.dart';

class NotificationsPage {
  const NotificationsPage({
    required this.items,
    required this.unreadCount,
    required this.page,
    required this.totalPages,
    required this.hasNext,
  });
  final List<AppNotification> items;
  final int unreadCount, page, totalPages;
  final bool hasNext;

  factory NotificationsPage.fromJson(dynamic response) {
    final root = _map(response);
    final data = _map(root['data']);
    final raw = _list(
      data['notifications'] ??
          data['items'] ??
          root['notifications'] ??
          root['items'] ??
          root['data'],
    );
    final meta = {
      ..._map(root['pagination']),
      ..._map(root['meta']),
      ..._map(data['meta']),
      ..._map(data['pagination']),
    };
    final page = _int(
      meta['page'] ?? meta['currentPage'] ?? data['page'] ?? root['page'],
      1,
    );
    final limit = _int(meta['limit'] ?? meta['perPage'], 0);
    final total = _int(meta['total'] ?? meta['totalCount'], 0);
    final calculatedPages = limit > 0 ? (total / limit).ceil() : page;
    final totalPages = _int(
      meta['pages'] ??
          meta['totalPages'] ??
          meta['lastPage'] ??
          data['totalPages'],
      calculatedPages,
    );
    final hasNext =
        _bool(meta['hasNextPage'] ?? meta['hasNext'] ?? data['hasNext']) ??
        page < totalPages;
    return NotificationsPage(
      items: raw
          .whereType<Map>()
          .map(
            (item) => AppNotification.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      unreadCount: _int(
        root['unreadCount'] ?? data['unreadCount'] ?? meta['unreadCount'],
        0,
      ),
      page: page,
      totalPages: totalPages,
      hasNext: hasNext,
    );
  }
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : {};
List<dynamic> _list(dynamic value) => value is List ? value : const [];
int _int(dynamic value, int fallback) => int.tryParse('$value') ?? fallback;
bool? _bool(dynamic value) => switch (value?.toString().toLowerCase()) {
  'true' => true,
  'false' => false,
  _ => null,
};
