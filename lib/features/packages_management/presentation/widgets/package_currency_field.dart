import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class PackageCurrencyField extends StatelessWidget {
  const PackageCurrencyField({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
        CustomDropdown(
          label: '',
          value: value,
          hintStyle: StylesManager.styleRegular12(
            context,
          ).copyWith(color: ColorManager.mainColor14),
          valueStyle: StylesManager.styleRegular12(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
          items: const ['EGP', 'SAR', 'AED', 'KWD', 'QAR', 'BHD', 'OMR'],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
