import 'admin_subject_request_model.dart';

class AdminSubjectRequestsPage {
  const AdminSubjectRequestsPage({
    required this.requests,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<AdminSubjectRequestModel> requests;
  final int total;
  final int page;
  final int limit;

  bool get hasMore => page * limit < total;

  factory AdminSubjectRequestsPage.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final nested = rawData is Map ? Map<String, dynamic>.from(rawData) : null;
    final rawItems = nested?['requests'] ?? nested?['data'] ?? rawData;
    final items = rawItems is List ? rawItems : const [];
    return AdminSubjectRequestsPage(
      requests: items
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .map(AdminSubjectRequestModel.fromJson)
          .toList(),
      total: _int(nested?['total'] ?? json['total'] ?? json['results']),
      page: _int(nested?['page'] ?? json['page'], fallback: 1),
      limit: _int(nested?['limit'] ?? json['limit'], fallback: 20),
    );
  }
}

int _int(dynamic value, {int fallback = 0}) => value is num
    ? value.toInt()
    : int.tryParse(value?.toString() ?? '') ?? fallback;
