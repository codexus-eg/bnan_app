import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/classroom_management/presentation/views/widgets/classroom_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomManagementView extends StatelessWidget {
  const ClassroomManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).classRoomManagement),
      body: ClassroomManagementBody(),
    );
  }
}