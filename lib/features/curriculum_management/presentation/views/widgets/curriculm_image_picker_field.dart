import 'dart:io';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CurriculumImagePickerField extends StatelessWidget {
  const CurriculumImagePickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.onTap,
    this.file,
  });

  final String label;
  final String hint;
  final File? file;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fileName = file?.path.split(Platform.pathSeparator).last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.mainColor15),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 48,
            width: double.infinity,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: ColorManager.borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.attach_file,
                  size: 20,
                  color: ColorManager.greyA8AF,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fileName ?? hint,
                    style: StylesManager.styleRegular16(context).copyWith(
                      color: fileName == null
                          ? ColorManager.greyA8AF
                          : ColorManager.mainColor15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
