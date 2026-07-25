import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackagePopularSwitch extends StatelessWidget {
  const PackagePopularSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 24,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: value
                  ? ColorManager.mainColor14
                  : ColorManager.greyA8AF,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.mainColor14,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          S.of(context).mostPopular,
          style: StylesManager.styleBold12(
            context,
          ).copyWith(
            color: ColorManager.greyA8AF,
          ),
        ),
      ],
    );
  }
}