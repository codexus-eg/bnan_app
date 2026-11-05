import 'package:bnan_app/features/notifications/data/models/app_notification.dart';

class ScheduleNotificationMatcher {
  static const _scheduleKeys = {
    'CLASSROOM_SCHEDULE_SET',
    'CLASSROOM_SCHEDULE_CREATED',
    'SCHEDULE_SET',
    'SCHEDULE_UPDATED',
    'CLASSROOM_SCHEDULE_UPDATED',
    'CLASS_SCHEDULE_UPDATED',
    'GULF_SCHEDULE_SET',
    'EGYPTIAN_SCHEDULE_SET',
    'STUDENT_SCHEDULE_SET',
    'STUDENT_SCHEDULE_ASSIGNED',
    'STUDENT_SCHEDULE_UPDATED',
    'CLASS_CANCELLED',
    'CLASS_RESCHEDULED',
    'CLASS_REMINDER',
    'CLASS_STARTED',
    'CLASS_ENDED',
  };

  static bool isMatch(AppNotification notification) {
    final keyUpper = notification.key.trim().toUpperCase();
    final typeUpper = notification.type.trim().toUpperCase();
    if (_scheduleKeys.contains(keyUpper) || _scheduleKeys.contains(typeUpper)) {
      return true;
    }
    if (keyUpper.contains('SCHEDULE') || typeUpper.contains('SCHEDULE')) {
      return true;
    }
    final screen = notification.navigation.screen?.trim().toLowerCase() ?? '';
    final target = notification.navigation.target?.trim().toLowerCase() ?? '';
    if (screen == 'schedule' ||
        screen == 'classroom_schedule' ||
        screen == 'classroom_schedules' ||
        target == 'schedule' ||
        target == 'classroom_schedule' ||
        target == 'classroom_schedules') {
      return true;
    }
    final dedupeKey =
        notification.data['dedupeKey']?.toString().toLowerCase() ?? '';
    if (dedupeKey.contains('schedule')) return true;
    final text = '${notification.title} ${notification.body}';
    return text.contains('جدول الفصل') ||
        text.contains('تحديد جدول') ||
        text.contains('تحديث جدول') ||
        text.contains('الجدول الدراسي');
  }
}
