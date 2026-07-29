import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonsManagementView extends StatelessWidget {
  const LessonsManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        headerText: S.of(context).lessonsManagement,
        iconNeeded: true,
      ),
      body: LessonsManagementBody(),
    );
  }
}
