import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/tables_management/data/models/class_schedule_model.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/dialogs/add_table_schedule_dialog.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_card_section.dart';
import 'package:bnan_app/features/users_management/data/user_mock_data.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TablesManagementBody extends StatelessWidget {
  const TablesManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
           Padding(
             padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
             child: AddNewTopicButton(
              title: S.of(context).addNewSchedule,
              path: ImageManager.userAdd,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const AddTableScheduleDialog(),
                );
              },
              padding: EdgeInsetsDirectional.symmetric(
                vertical: 6,
                horizontal: 30,
              ),
                       ),
           ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
              itemBuilder: (context, index) {
                return TableCardSection(
                  scheduleModel: classSchedulesMockData[index],
                );
              },
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemCount: usersMock.length,
            ),
          ),
        ],
      ),
    );
  }
}
