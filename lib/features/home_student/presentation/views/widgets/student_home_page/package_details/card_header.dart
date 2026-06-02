import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/package_status_badge.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              S.of(context).packageDetails,
              style: StylesManager.styleRegular14(
                context,
              ).copyWith(color: ColorManager.white),
            ),
          ],
        ),
        PackageStatusBadge(text: S.of(context).active),
      ],
    );
  }
}
