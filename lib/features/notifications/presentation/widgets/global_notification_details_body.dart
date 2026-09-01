import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_state.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/global_notification_details_content.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/global_notification_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalNotificationDetailsBody extends StatelessWidget {
  const GlobalNotificationDetailsBody({super.key, required this.broadcastId});
  final String broadcastId;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final details = state.globalDetails;
          if (state.globalStatus == GlobalNotificationStatus.loading &&
              details == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (details == null) {
            return GlobalNotificationFeedback(
              onRetry: () => context
                  .read<NotificationsCubit>()
                  .loadGlobalDetails(broadcastId),
            );
          }
          return GlobalNotificationDetailsContent(
            notification: details,
            showRetry: state.globalError != null,
            onRetry: () => context.read<NotificationsCubit>().loadGlobalDetails(
              broadcastId,
              initial: details,
            ),
          );
        },
      );
}
