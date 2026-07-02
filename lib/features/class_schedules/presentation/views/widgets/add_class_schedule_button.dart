import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/dialogs/add_table_schedule_dialog.dart';
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
          builder: (_) => const AddTableScheduleDialog(),
        ),
        path: ImageManager.plus,
      ),
    );
  }
}
