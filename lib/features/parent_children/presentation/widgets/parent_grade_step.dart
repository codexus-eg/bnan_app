import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentGradeStep extends StatelessWidget {
  const ParentGradeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) => Column(
        children: [
          CustomDropdown(
            label: S.of(context).grade,
            hint: state.isLoadingGrades
                ? S.of(context).loading
                : S.of(context).selectGrade,
            value: state.selectedGrade?.id,
            items: state.isLoadingGrades
                ? null
                : state.grades.map((item) => item.id).toList(),
            itemsLabels: {for (final item in state.grades) item.id: item.name},
            isRequired: true,
            onChanged: (id) async {
              final selected = state.grades
                  .where((item) => item.id == id)
                  .firstOrNull;
              final parent = context.read<ParentAddChildCubit>();
              final lookups = context.read<AcademicLookupsCubit>();
              parent.selectGrade(selected);
              await lookups.selectGrade(selected);
              if (!parent.isClosed) {
                parent.setGradeSubjectIds(
                  lookups.state.subjects.map((subject) => subject.id),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
