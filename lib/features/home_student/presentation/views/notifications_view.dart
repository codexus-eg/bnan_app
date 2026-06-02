import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/notification/notifications_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppbar(headerText:  S.of(context).notifications),
      body: NotificationsBody(),
    );
  }
}