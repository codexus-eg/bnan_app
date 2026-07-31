import 'package:bnan_app/features/supervisor_management/data/models/supervisor_classroom_model.dart';

class GetSupervisorClassroomsResponseModel {
  const GetSupervisorClassroomsResponseModel({
    this.success = false,
    this.results = 0,
    this.data = const [],
  });

  final bool success;
  final int results;
  final List<SupervisorClassroomModel> data;

  factory GetSupervisorClassroomsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];
    return GetSupervisorClassroomsResponseModel(
      success: json['success'] == true,
      results: int.tryParse(json['results']?.toString() ?? '') ?? 0,
      data: rawData is List
          ? rawData
                .whereType<Map>()
                .map(
                  (item) => SupervisorClassroomModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
}
