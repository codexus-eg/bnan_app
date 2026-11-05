import 'dart:async';

import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/domain/notification_navigation_service.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/notification_icon.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/notification_time.dart';
import 'package:bnan_app/features/lessons_management/domain/schedule_sync_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});
  final AppNotification notification;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () async {
      unawaited(context.read<NotificationsCubit>().markRead(notification));
      if (getIt.isRegistered<ScheduleSyncCoordinator>() &&
          getIt<ScheduleSyncCoordinator>().isScheduleNotification(notification)) {
        getIt<ScheduleSyncCoordinator>().handleNotification(notification);
      }
      final destination = await getIt<NotificationNavigationService>()
          .resolveDestination(notification);
      if (!context.mounted || destination.path == '/notification') return;
      final router = GoRouter.of(context);
      if (router.routeInformationProvider.value.uri.path ==
          Uri.parse(destination.path).path) {
        if (getIt.isRegistered<ScheduleSyncCoordinator>() &&
            getIt<ScheduleSyncCoordinator>().isScheduleNotification(notification)) {
          getIt<ScheduleSyncCoordinator>().triggerSync(
            reason: 'card_tap_same_screen',
          );
        }
        return;
      }
      if (NotificationNavigationService.isHomeDestination(destination.path)) {
        router.go(destination.path, extra: destination.extra);
      } else {
        router.push(destination.path, extra: destination.extra);
      }
    },
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notification.isRead
            ? ColorManager.greyF8F9
            : ColorManager.blueE5,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: notification.isRead
              ? ColorManager.greyE8E9
              : ColorManager.borderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationIcon(notification: notification),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                if (notification.body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: StylesManager.styleRegular14(
                      context,
                    ).copyWith(color: ColorManager.grey6F6F),
                  ),
                ],
                const SizedBox(height: 6),
                NotificationTime(value: notification.createdAt),
              ],
            ),
          ),
          if (!notification.isRead)
            const Padding(
              padding: EdgeInsets.all(5),
              child: CircleAvatar(
                radius: 4,
                backgroundColor: ColorManager.mainColor14,
              ),
            ),
        ],
      ),
    ),
  );
}
