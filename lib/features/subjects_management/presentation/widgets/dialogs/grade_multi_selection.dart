import 'package:bnan_app/core/shared_widget/custom_option_tile.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GradeMultiSelection extends StatelessWidget {
  const GradeMultiSelection({
    super.key,
    required this.selectedIds,
    required this.onChanged,
    this.labelStyle,
  });

  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) {
        if (state.isLoadingGrades) return Text(S.of(context).loading);
        if (state.selectedCurriculum != null &&
            state.errorMessage == null &&
            state.grades.isEmpty) {
          return Text(
            S.of(context).noGradesAvailableForCurriculum,
            style: StylesManager.styleRegular12(
              context,
            ).copyWith(color: ColorManager.red),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).selectGrade, style: labelStyle),
            const SizedBox(height: 8),
            ...state.grades.map((grade) {
              return CustomOptionTile(
                title: grade.name,
                isSelected: selectedIds.contains(grade.id),
                onTap: () {
                  final values = {...selectedIds};
                  values.contains(grade.id)
                      ? values.remove(grade.id)
                      : values.add(grade.id);
                  onChanged(values);
                },
              );
            }),
          ],
        );
      },
    );
  }
}
