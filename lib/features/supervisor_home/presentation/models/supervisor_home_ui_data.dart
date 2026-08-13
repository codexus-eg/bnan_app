import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_notification.dart';
import 'package:bnan_app/features/dashboard/data/models/supervisor_dashboard_model.dart';
import 'package:bnan_app/generated/l10n.dart';

class SupervisorHomeUiData {
  const SupervisorHomeUiData({
    required this.summary,
    required this.notifications,
  });
  final List<HomeStateModel> summary;
  final List<DashboardNotification> notifications;

  factory SupervisorHomeUiData.fromDashboard(
    S s,
    SupervisorDashboardModel data,
  ) {
    final ideal = data.idealTeacher;
    return SupervisorHomeUiData(
      summary: [
        HomeStateModel(
          icon: ImageManager.teacherBookTwoIcon,
          value: '${data.classrooms}',
          title: s.classes,
        ),
        HomeStateModel(
          icon: ImageManager.fileCheckIcon,
          value: '${data.evaluations}',
          title: s.evaluations,
        ),
        if (ideal != null)
          HomeStateModel(
            icon: ImageManager.crownSimple,
            value: '${ideal.points}',
            title: ideal.fullName,
            iconColor: ColorManager.mainColor14
          ),
      ],
      notifications: data.notifications,
    );
  }
}
