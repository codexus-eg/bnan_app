import 'package:bnan_app/core/shared_widget/custom_option_tile.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

enum SubjectSelectionMode { multiple, single }

class SubjectSelectionList extends StatelessWidget {
  const SubjectSelectionList({
    super.key,
    required this.subjects,
    required this.selectedSubjectIds,
    required this.selectionMode,
    required this.onChanged,
  });

  final List<AcademicSubjectModel> subjects;
  final List<String> selectedSubjectIds;
  final SubjectSelectionMode selectionMode;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return Text(
        S.of(context).noSubjectsAvailable,
        style: StylesManager.styleRegular14(
          context,
        ).copyWith(color: ColorManager.grey7D7D),
      );
    }
    return Column(
      children: subjects.map((subject) {
        final selected = selectedSubjectIds.contains(subject.id);
        return CustomOptionTile(
          title: subject.name,
          isSelected: selected,
          onTap: () {
            if (selectionMode == SubjectSelectionMode.single) {
              onChanged([subject.id]);
              return;
            }
            final values = [...selectedSubjectIds];
            selected ? values.remove(subject.id) : values.add(subject.id);
            onChanged(values);
          },
        );
      }).toList(),
    );
  }
}
