import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectManagementHeader extends StatelessWidget {
  const SubjectManagementHeader({super.key, required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomAppbar(
            headerText: S.of(context).subjectsManagement,
            iconNeeded: false,
          ),
          AddNewTopicButton(
            title: S.of(context).addSubject,
            path: ImageManager.userAdd,
            onTap: onAddTap,
            padding: EdgeInsetsDirectional.symmetric(
              vertical: 6,
              horizontal: 30,
            ),
          ),
        ],
      ),
    );
  }
}
