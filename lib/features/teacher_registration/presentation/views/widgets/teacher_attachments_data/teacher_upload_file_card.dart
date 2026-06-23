import 'dart:io';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_question_title.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeacherUploadFileCard extends StatelessWidget {
  const TeacherUploadFileCard({
    super.key,
    required this.title,
    required this.file,
    required this.onTap,
  });

  final String title;
  final File? file;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fileName = file?.path.split('/').last;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: DottedBorder(
        color: ColorManager.greyA8AF,
        strokeWidth: 1,
        dashPattern: const [2, 2],
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical:18 ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                height: 16,
                width: 16,
                ImageManager.upload,
                colorFilter: ColorFilter.mode(
                  ColorManager.greyA8AF,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 8),
              TeacherQuestionTitle(
                question: fileName ?? title,
                mainAxisAlignment: MainAxisAlignment.center,
                isRequired: true,
                style: StylesManager.styleMedium14(
                  context,
                ).copyWith(color: ColorManager.greyA8AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
