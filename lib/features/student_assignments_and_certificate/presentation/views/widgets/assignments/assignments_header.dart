import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AssignmentsHeader extends StatelessWidget {
  const AssignmentsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Row(
      children: [
        IconButton(
          onPressed: () => MyNavigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            isRtl ? Icons.arrow_forward : Icons.arrow_back,
            color: ColorManager.mainColor14,
            size: 22,
          ),
        ),
        const Spacer(),
        Text(
          S.of(context).assignments,
          style: StylesManager.styleBold18(context).copyWith(
            color: ColorManager.mainColor14,
          ),
        ),
      ],
    );
  }
}