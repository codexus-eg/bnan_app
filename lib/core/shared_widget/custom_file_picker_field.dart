import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomFilePickerField extends StatelessWidget {
  const CustomFilePickerField({
    super.key,
    required this.label,
    required this.hint,
    this.onTap,
    this.hasFile = false,
  });

  final String label;
  final String hint;
  final VoidCallback? onTap;
  final bool hasFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AbsorbPointer(
        child: CustomTextField(
          label: label,
          hintText: hint,
          readOnly: true,
          labelColor: ColorManager.mainColor14,
          hintStyle: StylesManager.styleRegular16(context).copyWith(
            color: hasFile ? ColorManager.mainColor14 : ColorManager.greyA8AF,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, end: 4),
            child: SizedBox(
              height: 16,
              width: 16,
              child: SvgPicture.asset(
                ImageManager.teacherAssignmentPaperclipIcon,
                colorFilter: const ColorFilter.mode(
                  ColorManager.greyA8AF,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
