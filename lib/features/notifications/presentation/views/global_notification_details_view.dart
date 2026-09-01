import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/global_notification_details_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalNotificationDetailsView extends StatefulWidget {
  const GlobalNotificationDetailsView({
    super.key,
    required this.broadcastId,
    this.initialNotification,
  });
  final String broadcastId;
  final AppNotification? initialNotification;

  @override
  State<GlobalNotificationDetailsView> createState() =>
      _GlobalNotificationDetailsViewState();
}

class _GlobalNotificationDetailsViewState
    extends State<GlobalNotificationDetailsView> {
  late final NotificationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<NotificationsCubit>();
    _cubit.loadGlobalDetails(
      widget.broadcastId,
      initial: widget.initialNotification,
    );
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _cubit,
    child: Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).globalNotificationDetails),
      body: GlobalNotificationDetailsBody(broadcastId: widget.broadcastId),
    ),
  );
}
