import 'classroom_change_request_model.dart';

class ClassroomChangeRequestsPage {
  const ClassroomChangeRequestsPage({required this.requests});
  final List<ClassroomChangeRequestModel> requests;

  factory ClassroomChangeRequestsPage.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final nested = data is Map ? Map<String, dynamic>.from(data) : null;
    final raw =
        nested?['requests'] ??
        nested?['changeRequests'] ??
        nested?['items'] ??
        data;
    return ClassroomChangeRequestsPage(
      requests: (raw is List ? raw : const [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .map(ClassroomChangeRequestModel.fromJson)
          .toList(growable: false),
    );
  }
}
