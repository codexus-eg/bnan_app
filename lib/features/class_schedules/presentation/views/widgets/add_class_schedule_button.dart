import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/features/class_schedules/presentation/views/dialogs/class_schedule_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddClassScheduleButton extends StatelessWidget {
  const AddClassScheduleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: AddNewTopicButton(
        title: S.of(context).addNewSchedule,
        onTap: () => showDialog(
          context: context,
          builder: (_) => const ClassScheduleDialog(),
        ),
      ),
    );
  }
}
