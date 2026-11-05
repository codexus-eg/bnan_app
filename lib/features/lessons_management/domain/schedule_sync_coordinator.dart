import 'dart:async';

import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/domain/models/schedule_sync_event.dart';
import 'package:bnan_app/features/lessons_management/domain/schedule_notification_matcher.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';

class ScheduleSyncCoordinator {
  ScheduleSyncCoordinator({GulfScheduleRepo? repo}) : _repo = repo;

  final GulfScheduleRepo? _repo;
  final _controller = StreamController<ScheduleSyncEvent>.broadcast();
  DateTime? _lastSyncTime;
  String? _lastSyncReason;

  Stream<ScheduleSyncEvent> get syncStream => _controller.stream;

  bool isScheduleNotification(AppNotification n) =>
      ScheduleNotificationMatcher.isMatch(n);

  void handleNotification(AppNotification n) {
    if (!isScheduleNotification(n)) return;
    triggerSync(
      reason: n.key.isNotEmpty ? n.key : 'notification',
      classroomId: n.navigation.params['classroomId']?.toString(),
      studentId: n.navigation.params['studentId']?.toString(),
    );
  }

  void triggerSync({
    required String reason,
    String? classroomId,
    String? studentId,
  }) {
    final now = DateTime.now();
    if (_lastSyncTime != null &&
        now.difference(_lastSyncTime!) < const Duration(milliseconds: 600) &&
        _lastSyncReason == reason) {
      return;
    }
    _lastSyncTime = now;
    _lastSyncReason = reason;
    _repo?.invalidateScheduleCache();
    _controller.add(
      ScheduleSyncEvent(
        reason: reason,
        classroomId: classroomId,
        studentId: studentId,
        timestamp: now,
      ),
    );
  }

  void dispose() => _controller.close();
}
