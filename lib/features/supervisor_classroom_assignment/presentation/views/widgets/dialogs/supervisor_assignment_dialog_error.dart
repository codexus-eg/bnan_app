import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class SupervisorAssignmentDialogError extends StatelessWidget {
  const SupervisorAssignmentDialogError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        color: ColorManager.redF2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        textAlign: TextAlign.start,
        style: StylesManager.styleRegular12(
          context,
        ).copyWith(color: ColorManager.redBA),
      ),
    );
  }
}
