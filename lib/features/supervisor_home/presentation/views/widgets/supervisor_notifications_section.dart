import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_state.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/notification_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorNotificationsSection extends StatelessWidget {
  const SupervisorNotificationsSection({
    super.key,
    this.onSeeAllTap,
  });

  final VoidCallback? onSeeAllTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      bloc: getIt<NotificationsCubit>(),
      builder: (context, state) {
        final notifications = state.items.take(2).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).notifications,
                  style: StylesManager.styleBold16(context),
                ),
                if (onSeeAllTap != null)
                  GestureDetector(
                    onTap: onSeeAllTap,
                    child: Text(
                      'عرض الكل',
                      style: StylesManager.styleRegular14(context).copyWith(
                        color: ColorManager.mainColor14,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (state.status == NotificationsStatus.loading && notifications.isEmpty)
              const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (notifications.isEmpty)
              SizedBox(
                height: 180,
                child: NoDataWidget(title: S.of(context).noNotifications),
              )
            else
              for (final notification in notifications)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NotificationCard(notification: notification),
                ),
          ],
        );
      },
    );
  }
}
