import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/core/shared_widget/custom_chip.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/custom_user_avatar.dart';
import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({
    super.key,
    required this.name,
    required this.phone,
    required this.subtitle,
  });
  final String name, phone, subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomUserAvatar(),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
              if (phone.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: StylesManager.styleRegular14(
                    context,
                  ).copyWith(color: ColorManager.greyA8AF),
                ),
              ],
            ],
          ),
        ),
        if (subtitle.trim().isNotEmpty) Customship(subtitle),
      ],
    );
  }
}
