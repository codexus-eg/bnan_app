import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/classes_management/presentation/views/widgets/classes_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassesManagementView extends StatelessWidget {
  const ClassesManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).classesManagement),
      body: ClassesManagementBody(),
    );
  }
}