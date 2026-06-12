import 'package:bnan_app/core/shared_widget/custom_back_icon.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class RegisterAccountTypeCard extends StatelessWidget {
  const RegisterAccountTypeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.only(
          start: 17,
          top: 16,
          bottom: 16,
          end: 16,
        ),
        decoration: BoxDecoration(
          color: ColorManager.greyF8F9,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withAlpha((255 * .25).round()),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: ColorManager.mainColor14,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.asset(icon, width: 24, height: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.start,
                    style: StylesManager.styleBold16(
                      context,
                    ).copyWith(color: ColorManager.mainColor14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.start,
                    style: StylesManager.styleBold12(context),
                  ),
                ],
              ),
            ),
            CustomBackIcon(size: 18, color: ColorManager.greyA8AF),
          ],
        ),
      ),
    );
  }
}
