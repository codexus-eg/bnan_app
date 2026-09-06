import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/classrooms_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomsManagementView extends StatelessWidget {
  const ClassroomsManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).classesManagement),
      body: ClassroomsManagementBody(),
    );
  }
}
