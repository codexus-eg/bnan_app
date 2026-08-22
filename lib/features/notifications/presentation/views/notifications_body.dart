import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_state.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/notifications_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bnan_app/core/app_routes/routes.dart';

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              _Action(
                label: S.of(context).notificationSettings,
                onTap: () => context.push(Routes.notificationSettings),
              ),
              const Spacer(),
              BlocSelector<NotificationsCubit, NotificationsState, int>(
                selector: (state) => state.unreadCount,
                builder: (_, count) => count == 0
                    ? const SizedBox.shrink()
                    : _Action(
                        label: S.of(context).markAllNotificationsRead,
                        onTap: context.read<NotificationsCubit>().markAllRead,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Expanded(child: NotificationsContent()),
        ],
      ),
    ),
  );
}

class _Action extends StatelessWidget {
  const _Action({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        label,
        style: StylesManager.styleBold14(
          context,
        ).copyWith(color: ColorManager.mainColor14),
      ),
    ),
  );
}
