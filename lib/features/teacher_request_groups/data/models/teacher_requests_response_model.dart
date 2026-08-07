import 'package:bnan_app/features/teacher_request_groups/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/teacher_requests_pagination_model.dart';

class TeacherRequestsResponseModel {
  const TeacherRequestsResponseModel({
    required this.requests,
    required this.pagination,
  });

  final List<RegistrationRequestModel> requests;
  final TeacherRequestsPaginationModel pagination;

  factory TeacherRequestsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return TeacherRequestsResponseModel(
      requests: data is List
          ? data
                .whereType<Map>()
                .map(
                  (item) => RegistrationRequestModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
      pagination: TeacherRequestsPaginationModel.fromJson(json['pagination']),
    );
  }
}
