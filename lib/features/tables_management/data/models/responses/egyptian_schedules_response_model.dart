import '../egyptian_schedule_model.dart';

class EgyptianSchedulesResponseModel {
  const EgyptianSchedulesResponseModel({
    this.success,
    this.results,
    this.schedules = const [],
  });

  final bool? success;
  final int? results;
  final List<EgyptianScheduleModel> schedules;

  factory EgyptianSchedulesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final schedules = data is Map ? data['schedules'] : null;

    return EgyptianSchedulesResponseModel(
      success: json['success'] is bool ? json['success'] as bool : null,
      results: int.tryParse(json['results']?.toString() ?? ''),
      schedules: schedules is List
          ? schedules
                .whereType<Map>()
                .map(
                  (item) => EgyptianScheduleModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
}
