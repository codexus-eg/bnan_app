import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CompletedLessonsWidget extends StatelessWidget {
  const CompletedLessonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${S.of(context).completedSessions} : 38',
          style: StylesManager.styleRegular12(
            context,
          ).copyWith(color: Colors.white),
        ),
        const Spacer(),
        Text(
          '${S.of(context).remainingSessions}: 14',
          style: StylesManager.styleBold12(
            context,
          ).copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
