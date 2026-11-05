import 'package:bnan_app/features/lessons_management/data/models/course_schedule_slot.dart';

class CourseScheduleResponse {
  const CourseScheduleResponse({
    required this.success,
    this.timezone = 'Africa/Cairo',
    this.slots = const [],
  });

  final bool success;
  final String timezone;
  final List<CourseScheduleSlot> slots;

  factory CourseScheduleResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? json['data'] as Map : json;
    final rawSlots = data['slots'] is List ? data['slots'] as List : const [];
    return CourseScheduleResponse(
      success: json['success'] == true || data['success'] == true,
      timezone: data['timezone']?.toString().trim().isNotEmpty == true
          ? data['timezone'].toString().trim()
          : 'Africa/Cairo',
      slots: rawSlots
          .whereType<Map>()
          .map((m) => CourseScheduleSlot.fromJson(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }
}

class CourseScheduleUpdateRequest {
  const CourseScheduleUpdateRequest({
    this.timezone = 'Africa/Cairo',
    required this.slots,
  });

  final String timezone;
  final List<CourseScheduleSlot> slots;

  Map<String, dynamic> toJson() => {
    'timezone': timezone.isNotEmpty ? timezone : 'Africa/Cairo',
    'slots': slots.map((s) => s.toJson()).toList(),
  };
}
