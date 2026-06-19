import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_profile/presentation/views/widgets/student_wigets/custom_avatar.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'student_submission_card.dart';

class StudentSubmissionHeader extends StatelessWidget {
  const StudentSubmissionHeader({
    super.key,
    required this.status,
    this.grade,
  });

  final StudentSubmissionStatus status;
  final String? grade;

  @override
  Widget build(BuildContext context) {
    final isNotSubmitted = status == StudentSubmissionStatus.notSubmitted;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAvatar(
          firstName: 'أم',
          radius: 20,
          backgroundColor: isNotSubmitted != false ? ColorManager.redFFD : null,
          textColor: isNotSubmitted != false ? ColorManager.redC7 : null,
        ),
        const SizedBox(width: 17),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أحمد محمد',
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
              const SizedBox(height: 4),
              Text(
                isNotSubmitted
                    ? S.of(context).assignmentNotSubmittedYet
                    : '${S.of(context).submissionDate} 31/5/2026',
                style: StylesManager.styleRegular14(context).copyWith(
                  color: isNotSubmitted
                      ? ColorManager.redC7
                      : ColorManager.greyA8AF,
                ),
              ),
            ],
          ),
        ),
        if (grade != null)
          Column(
            children: [
              Text(
                grade!,
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.black),
              ),
              Row(
                children: [
                  Icon(Icons.check, size: 16, color: ColorManager.greyA8AF),
                  const SizedBox(width: 4),
                  Text(
                    S.of(context).graded,
                    style: StylesManager.styleRegular14(
                      context,
                    ).copyWith(color: ColorManager.greyA8AF),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
