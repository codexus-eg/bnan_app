import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class PackagePriceField extends StatelessWidget {
  const PackagePriceField({
    super.key,
    required this.title,
    required this.controller,
    required this.hintText,
  });

  final String title, hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 42,
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: StylesManager.styleBold14(context).copyWith(
              color: ColorManager.mainColor14
            ),
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          hintText: hintText,
          hintStyle: StylesManager.styleRegular12(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
