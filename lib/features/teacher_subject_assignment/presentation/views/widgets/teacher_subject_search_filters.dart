import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TeacherSubjectSearchFilters extends StatelessWidget {
  const TeacherSubjectSearchFilters({
    super.key,
    required this.teacherController,
    required this.subjectController,
    required this.onChanged,
  });

  final TextEditingController teacherController;
  final TextEditingController subjectController;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildField(
          context,
          controller: teacherController,
          hintText: S.of(context).searchByTeacherName,
        ),
        const SizedBox(height: 12),
        _buildField(
          context,
          controller: subjectController,
          hintText: S.of(context).searchBySubjectName,
        ),
      ],
    );
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
  }) {
    return CustomTextField(
      controller: controller,
      onChanged: onChanged,
      hintText: hintText,
      backgroundColor: ColorManager.white,
      hintStyle: StylesManager.styleRegular12(
        context,
      ).copyWith(color: ColorManager.grey7D7D),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          height: 16,
          width: 16,
          child: SvgPicture.asset(ImageManager.usersManagementSearchIcon),
        ),
      ),
    );
  }
}
