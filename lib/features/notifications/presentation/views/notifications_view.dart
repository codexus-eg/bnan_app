import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/notifications/presentation/views/notifications_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: getIt<NotificationsCubit>()..load(refresh: true),
    child: Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).notifications),
      body: const NotificationsBody(),
    ),
  );
}
