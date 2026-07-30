import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_subject_ui_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PlanSubjectCell extends StatelessWidget {
  const PlanSubjectCell({
    super.key,
    required this.subject,
    required this.width,
  });

  final PlanSubjectUiModel? subject;
  final double width;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 54),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 5,
        vertical: 6,
      ),
      decoration: const BoxDecoration(
        border: BorderDirectional(
          end: BorderSide(color: ColorManager.greyE8E9),
          bottom: BorderSide(color: ColorManager.greyE8E9),
        ),
      ),
      child: subject == null
          ? const SizedBox.shrink()
          : Text.rich(
              TextSpan(
                children: [
                  _label(s.lessonLabel),
                  TextSpan(text: subject!.lesson),
                  const TextSpan(text: '\n'),
                  _label(s.homeworkLabel),
                  TextSpan(text: subject!.homework),
                ],
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: StylesManager.styleRegular10(
                context,
              ).copyWith(color: ColorManager.mainColor14, height: 1.35),
            ),
    );
  }

  TextSpan _label(String text) {
    return TextSpan(
      text: '$text: ',
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
