import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UsersManagementSearch extends StatelessWidget {
  const UsersManagementSearch({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      onChanged: onChanged,
      hintText: S.of(context).searchByNameOrPhone,
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
