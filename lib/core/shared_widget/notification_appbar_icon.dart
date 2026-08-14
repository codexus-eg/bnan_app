import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/home_appbar_icon.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationAppBarIcon extends StatelessWidget {
  const NotificationAppBarIcon({
    super.key,
    required this.onTap,
    this.size = 24,
  });
  final VoidCallback onTap;
  final double size;
  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<NotificationsCubit>()) {
      return HomeAppBarIcon(
        icon: ImageManager.bellIcon,
        onTap: onTap,
        size: size,
      );
    }
    return BlocSelector<NotificationsCubit, NotificationsState, int>(
      bloc: getIt<NotificationsCubit>(),
      selector: (state) => state.unreadCount,
      builder: (_, count) => HomeAppBarIcon(
        icon: ImageManager.bellIcon,
        onTap: onTap,
        size: size,
        badgeCount: count,
      ),
    );
  }
}
