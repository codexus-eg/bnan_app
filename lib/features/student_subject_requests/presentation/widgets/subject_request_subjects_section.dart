import 'package:bnan_app/core/shared_widget/custom_option_tile.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_availability.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/widgets/subject_request_status_label.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectRequestSubjectsSection extends StatelessWidget {
  const SubjectRequestSubjectsSection({
    super.key,
    required this.subjects,
    required this.selectedId,
    required this.onSelected,
  });
  final List<AvailableSubject> subjects;
  final String? selectedId;
  final ValueChanged<AvailableSubject> onSelected;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        S.of(context).subjects,
        style: StylesManager.styleBold14(
          context,
        ).copyWith(color: ColorManager.mainColor15),
      ),
      const SizedBox(height: 8),
      ...subjects.map(
        (subject) => CustomOptionTile(
          title: subject.name,
          subtitle: subject.requestStatus != null
              ? subjectRequestStatusLabel(S.of(context), subject.requestStatus)
              : null,
          isSelected: selectedId == subject.id,
          isEnabled: subject.isSelectable,
          onTap: () => onSelected(subject),
        ),
      ),
    ],
  );
}
