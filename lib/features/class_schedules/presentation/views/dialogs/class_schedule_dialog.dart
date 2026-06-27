import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/class_schedules/presentation/views/widgets/class_schedule_form.dart';
import 'package:flutter/material.dart';

class ClassScheduleDialog extends StatelessWidget {
  const ClassScheduleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomAppDialog(
      child: Padding(
        padding: EdgeInsetsDirectional.all(16),
        child: ClassScheduleForm(),
      ),
    );
  }
}
