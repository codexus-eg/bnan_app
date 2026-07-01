import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/classes_management/data/models/class_management_model.dart';
import 'package:bnan_app/features/classes_management/presentation/views/widgets/dialogs/add_class_dialog.dart';
import 'package:bnan_app/features/classes_management/presentation/views/widgets/dialogs/class_details_dialog.dart';
import 'package:bnan_app/features/classes_management/presentation/views/widgets/dialogs/edit_class_dialog.dart';
import 'package:bnan_app/features/classes_management/presentation/views/widgets/class_management_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassesManagementBody extends StatelessWidget {
  const ClassesManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AddNewTopicButton(
            title: S.of(context).addNewChapter,
            path: ImageManager.plus,
            onTap: () => showDialog(
              context: context,
              builder: (_) => const AddClassDialog(),
            ),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
            itemBuilder: (context, index) {
              final classItem = classManagementMockData[index];
              return ClassManagementCard(
                classItem: classItem,
                onView: () => showDialog(
                  context: context,
                  builder: (_) => ClassDetailsDialog(classItem: classItem),
                ),
                onEdit: () => showDialog(
                  context: context,
                  builder: (_) => EditClassDialog(classItem: classItem),
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemCount: classManagementMockData.length,
          ),
        ),
      ],
    );
  }
}
