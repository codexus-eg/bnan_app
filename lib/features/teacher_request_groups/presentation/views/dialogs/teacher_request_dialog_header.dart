import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherRequestDialogHeader extends StatelessWidget {
  const TeacherRequestDialogHeader({super.key, required this.studentName});

  final String studentName;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${S.of(context).acceptStudentRequest} $studentName',
      textAlign: TextAlign.center,
      style: StylesManager.styleBold16(
        context,
      ).copyWith(color: ColorManager.black),
    );
  }
}
