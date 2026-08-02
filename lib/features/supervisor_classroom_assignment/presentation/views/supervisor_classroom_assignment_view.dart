import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/supervisor_assignment_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SupervisorClassroomAssignmentView extends StatelessWidget {
  const SupervisorClassroomAssignmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: CustomAppbar(headerText: S.of(context).supervisorAssignment),
      body: const SupervisorAssignmentBody(),
    );
  }
}
