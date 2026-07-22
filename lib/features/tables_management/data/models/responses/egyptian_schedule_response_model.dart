import '../egyptian_schedule_model.dart';

class EgyptianScheduleResponseModel {
  const EgyptianScheduleResponseModel({this.success, this.schedule});

  final bool? success;
  final EgyptianScheduleModel? schedule;

  factory EgyptianScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final schedule = data is Map ? data['schedule'] : null;

    return EgyptianScheduleResponseModel(
      success: json['success'] is bool ? json['success'] as bool : null,
      schedule: schedule is Map
          ? EgyptianScheduleModel.fromJson(Map<String, dynamic>.from(schedule))
          : null,
    );
  }
}
