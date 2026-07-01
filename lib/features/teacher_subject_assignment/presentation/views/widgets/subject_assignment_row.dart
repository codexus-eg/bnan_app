import 'package:bnan_app/core/shared_widget/custom_chip.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/teacher_subject_mock_data.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/delete_assignment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubjectAssignmentRow extends StatelessWidget {
  const SubjectAssignmentRow({super.key, required this.assignment});
  final SubjectAssignmentItem assignment;

  @override
  Widget build(BuildContext context) {
    final title = '${assignment.subjectName} - ${assignment.gradeName}';
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            ImageManager.teacherBookTwoIcon,
            height: 16,
            width: 16,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: StylesManager.styleMedium14(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),
          ),
         const SizedBox(width: 5),
          Customship(assignment.curriculumName),
         const SizedBox(width: 26),
          InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (_) => DeleteAssignmentDialog(assignment: assignment),
            ),
            child: SvgPicture.asset(ImageManager.trash,height: 24,width: 4,)
          ),
        ],
      ),
    );
  }
}
