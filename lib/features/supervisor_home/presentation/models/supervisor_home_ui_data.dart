import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/home_student/data/models/notification_model.dart';
import 'package:bnan_app/generated/l10n.dart';

class SupervisorHomeUiData {
  const SupervisorHomeUiData({
    required this.summary,
    required this.notifications,
  });

  final List<HomeStateModel> summary;
  final List<NotificationModel> notifications;

  factory SupervisorHomeUiData.mock(S s) {
    // TODO: Replace these values with the supervisor dashboard response.
    return SupervisorHomeUiData(
      summary: [
        HomeStateModel(
          icon: ImageManager.teacherBookTwoIcon,
          value: '4',
          title: s.classes,
        ),
        HomeStateModel(
          icon: ImageManager.fileCheckIcon,
          value: '20',
          title: s.evaluations,
        ),
        if (SessionManager.instance.isEgyptianSupervisor)
          HomeStateModel(
            icon: ImageManager.crownSimple,
            value: '--',
            title: s.weeklyIdealStudent,
          ),
      ],
      notifications: [
        NotificationModel(
          title: s.supervisorAssignedNotification,
          time: s.today,
          isUnread: true,
        ),
        NotificationModel(
          title: s.weeklyEvaluationAddedNotification,
          time: s.today,
          isUnread: true,
        ),
        NotificationModel(
          title: s.newClassMessageNotification,
          time: s.yesterday,
        ),
      ],
    );
  }
}
