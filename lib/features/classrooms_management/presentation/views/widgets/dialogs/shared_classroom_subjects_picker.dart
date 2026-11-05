import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SharedClassroomSubjectsPicker extends StatelessWidget {
  const SharedClassroomSubjectsPicker({
    super.key,
    required this.subjects,
    required this.selectedIds,
    required this.onToggle,
    this.isLoading = false,
  });

  final List<AcademicSubjectModel> subjects;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
          padding: EdgeInsets.all(12), child: Center(child: CircularProgressIndicator()));
    }
    if (subjects.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).classroomSubjects, style: StylesManager.styleBold12(context)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: subjects.map((sub) {
            final sel = selectedIds.contains(sub.id);
            return FilterChip(
              label: Text(sub.name),
              selected: sel,
              selectedColor: ColorManager.blue3A,
              labelStyle: StylesManager.styleRegular12(context).copyWith(
                color: sel ? ColorManager.white : ColorManager.mainColor14,
              ),
              onSelected: (_) => onToggle(sub.id),
            );
          }).toList(),
        ),
      ],
    );
  }
}
