import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/grades_management/presentation/views/widgets/grades_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class GradesManagementView extends StatelessWidget {
  const GradesManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).classRoomManagement),
      body: GradesManagementBody(),
    );
  }
}