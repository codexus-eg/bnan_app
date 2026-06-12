import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentNotesWidget extends StatelessWidget {
  const StudentNotesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).studentUsesItForDashboard,
          style: StylesManager.styleBold12(
            context,
          ).copyWith(color: ColorManager.grey7D7D),
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: S.of(context).studentNotesAndSchedule,
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.mainColor15),
              ),
              TextSpan(
                text: ' (${S.of(context).optional})',
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.grey9D9D),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            S.of(context).studentNotesAndScheduleHint,
            textAlign: TextAlign.center,
            style: StylesManager.styleRegular12(
              context,
            ).copyWith(color: ColorManager.mainColor15),
          ),
        ),
        const SizedBox(height: 8),
        CustomAuthTextField(
          hintText: S.of(context).studentNotesExample,
          maxLine: 5,
        ),
      ],
    );
  }
}
