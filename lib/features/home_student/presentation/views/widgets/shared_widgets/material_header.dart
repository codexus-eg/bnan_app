import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class MaterialsHeader extends StatelessWidget {
  const MaterialsHeader({super.key, required this.onViewAllTap, required this.header});

  final VoidCallback onViewAllTap;
  final String header;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          header,
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.black),
        ),
        const Spacer(),
        TextButton(
          onPressed: onViewAllTap,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(
            S.of(context).viewAll,
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
        ),
      ],
    );
  }
}
