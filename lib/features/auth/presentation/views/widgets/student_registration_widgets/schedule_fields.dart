import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ScheduleFields extends StatelessWidget {
  const ScheduleFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(S.of(context).preferredDays),
        const SizedBox(height: 6),
        Text(S.of(context).preferredDaysHint, textAlign: TextAlign.end),
        const SizedBox(height: 12),
        CustomAuthTextField(label: S.of(context).notes, hintText: S.of(context).notesHint),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: CustomAuthTextField(label: S.of(context).availableDay, hintText: 'mm/dd/yy')),
            const SizedBox(width: 8),
            Expanded(child: CustomAuthTextField(label: S.of(context).from, hintText: '--:--')),
            const SizedBox(width: 8),
            Expanded(child: CustomAuthTextField(label: S.of(context).to, hintText: '--:--')),
          ],
        ),
      ],
    );
  }
}