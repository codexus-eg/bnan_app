import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/dialogs/teacher_assignment_dialogs.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddNewAssignmentButton extends StatelessWidget {
  const AddNewAssignmentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => TeacherAssignmentDialogs.showCreateAssignment(context),
      child: Container(
        padding: EdgeInsetsDirectional.only(
          start: 25,
          end: 18,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: ColorManager.mainColor14,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add,color: ColorManager.white,),
            const SizedBox(width: 12),
            Text(
              S.of(context).createNewAssignment,
              style: StylesManager.styleBold12(
                context,
              ).copyWith(color: ColorManager.white),
            ),
          ],
        ),
      ),
    );
  }
}
