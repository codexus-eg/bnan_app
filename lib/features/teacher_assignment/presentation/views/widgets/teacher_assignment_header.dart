import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentHeader extends StatelessWidget {
  const TeacherAssignmentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
      headerText: S.of(context).assignments,
      iconNeeded: false,
    );
  }
}