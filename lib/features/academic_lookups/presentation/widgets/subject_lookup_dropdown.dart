import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectLookupDropdown extends StatelessWidget {
  const SubjectLookupDropdown({super.key, required this.requiresClassroom});

  final bool requiresClassroom;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) {
        final canSelect = requiresClassroom
            ? state.selectedClassroom != null
            : state.selectedGrade != null;
        final items = !canSelect || state.isLoadingSubjects
            ? null
            : state.subjects.map((item) => item.id).toList();

        return CustomDropdown(
          label: S.of(context).subject,
          hint: state.isLoadingSubjects
              ? S.of(context).loading
              : S.of(context).chooseSubject,
          value: state.selectedSubject?.id,
          items: items,
          itemsLabels: {for (final item in state.subjects) item.id: item.name},
          onChanged: (value) {
            final selected = state.subjects
                .where((item) => item.id == value)
                .firstOrNull;
            context.read<AcademicLookupsCubit>().selectSubject(selected);
          },
        );
      },
    );
  }
}
