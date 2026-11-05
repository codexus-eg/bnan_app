import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TeacherSearchField extends StatelessWidget {
  const TeacherSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return CustomTextField(
      controller: controller,
      hintText: isAr ? 'ابحث باسم المعلم...' : 'Search by teacher name...',
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
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear, size: 18),
              onPressed: onClear,
            )
          : null,
      onChanged: onChanged,
    );
  }
}
