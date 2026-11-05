import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SharedClassroomBadge extends StatelessWidget {
  const SharedClassroomBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: ColorManager.blue3A.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        S.of(context).sharedClassroom,
        style: StylesManager.styleBold10(context).copyWith(
          color: ColorManager.blue3A,
        ),
      ),
    );
  }
}
