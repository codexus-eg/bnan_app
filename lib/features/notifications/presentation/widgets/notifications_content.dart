import 'package:bnan_app/core/shared_widget/custom_empty_state.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_state.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/notifications_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsContent extends StatelessWidget {
  const NotificationsContent({super.key});
  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<NotificationsCubit, NotificationsState>(
    builder: (context, state) {
      if (state.status == NotificationsStatus.loading && state.items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state.status == NotificationsStatus.failure && state.items.isEmpty) {
        return Center(
          child: TextButton(
            onPressed: () =>
                context.read<NotificationsCubit>().load(refresh: true),
            child: Text(S.of(context).retry),
          ),
        );
      }
      if (state.items.isEmpty) {
        return CustomEmptyState(
          title: S.of(context).noNotificationsYet,
          subtitle: S.of(context).notificationsEmptySubtitle,
          icon: Icons.notifications_none_outlined,
        );
      }
      return NotificationsList(state: state);
    },
  );
}
