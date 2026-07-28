import 'registration_json_parsing.dart';
import 'registration_request_model.dart';
import 'registration_requests_pagination_model.dart';

class GetRegistrationRequestsResponseModel {
  const GetRegistrationRequestsResponseModel({
    required this.success,
    required this.results,
    required this.pagination,
    required this.requests,
  });

  final bool success;
  final int results;
  final RegistrationRequestsPaginationModel pagination;
  final List<RegistrationRequestModel> requests;

  factory GetRegistrationRequestsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];
    return GetRegistrationRequestsResponseModel(
      success: json['success'] == true,
      results: registrationInt(json['results']),
      pagination: RegistrationRequestsPaginationModel.fromJson(
        registrationMap(json['pagination']) ?? const {},
      ),
      requests: data is List
          ? data
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .map(RegistrationRequestModel.fromJson)
                .toList()
          : const [],
    );
  }
}
