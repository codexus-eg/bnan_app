import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/class_schedules/presentation/views/widgets/class_schedules_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassSchedulesView extends StatelessWidget {
  const ClassSchedulesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).classSchedulesManagement),
      body: const ClassSchedulesBody(),
    );
  }
}
