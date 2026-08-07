import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';
import 'package:flutter/material.dart';

class StudentSubjectCard extends StatelessWidget {
  const StudentSubjectCard({super.key, required this.subject});

  final StudentSubjectModel subject;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Row(
        children: [
          CustomIconBox(imagePath: ImageManager.bookIcon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              subject.name.isEmpty ? '-' : subject.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StylesManager.styleBold16(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),
          ),
        ],
      ),
    );
  }
}
