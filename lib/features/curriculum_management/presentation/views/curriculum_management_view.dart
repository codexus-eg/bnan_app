import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/curriculum_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CurriculumManagementView extends StatelessWidget {
  const CurriculumManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).curriculums),
      body: const CurriculumManagementBody(),
    );
  }
}
