import 'admin_subscription_renewal_model.dart';

class AdminSubscriptionRenewalsPage {
  const AdminSubscriptionRenewalsPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  final List<AdminSubscriptionRenewalModel> items;
  final int currentPage, lastPage, perPage, total;
  bool get hasMore => currentPage < lastPage;

  factory AdminSubscriptionRenewalsPage.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final nested = data is Map ? Map<String, dynamic>.from(data) : const {};
    final rawItems = data is List
        ? data
        : nested['items'] ?? nested['requests'] ?? nested['data'];
    final pagination = _map(json['pagination']).isNotEmpty
        ? _map(json['pagination'])
        : _map(nested['pagination']);
    return AdminSubscriptionRenewalsPage(
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .map(AdminSubscriptionRenewalModel.fromJson)
                .toList()
          : const [],
      currentPage: _int(
        pagination['current_page'] ?? pagination['currentPage'],
        1,
      ),
      lastPage: _int(pagination['last_page'] ?? pagination['lastPage'], 1),
      perPage: _int(pagination['per_page'] ?? pagination['perPage'], 20),
      total: _int(pagination['total'], 0),
    );
  }
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};
int _int(Object? value, int fallback) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? fallback;
