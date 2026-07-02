import 'package:bnan_app/features/subjects_management/data/models/subject_management_model.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/edit_subject_dialog.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_card_management.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_management_header.dart';
import 'package:bnan_app/features/users_management/data/user_mock_data.dart';
import 'package:flutter/material.dart';

class SubjectManagementBody extends StatelessWidget {
  const SubjectManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SubjectManagementHeader(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
              itemBuilder: (context, index) {
                return SubjectCardManagement(
                  subjectManagementModel: subjectsMockData[index],
                  onEdit: () {
                    showDialog(
                      context: context,
                      builder: (_) => const EditSubjectDialog(),
                    );
                  },
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
