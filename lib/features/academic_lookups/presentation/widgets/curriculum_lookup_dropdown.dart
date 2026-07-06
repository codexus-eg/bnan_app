import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurriculumLookupDropdown extends StatelessWidget {
  const CurriculumLookupDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) {
        final items = state.isLoadingCurriculums
            ? null
            : state.curriculums.map((item) => item.id).toList();

        return CustomDropdown(
          label: S.of(context).curriculum,
          hint: state.isLoadingCurriculums
              ? S.of(context).loading
              : S.of(context).curriculum,
          value: state.selectedCurriculum?.id,
          items: items,
          itemsLabels: {
            for (final item in state.curriculums) item.id: item.name,
          },
          onChanged: (value) {
            final selected = state.curriculums
                .where((item) => item.id == value)
                .firstOrNull;
            context.read<AcademicLookupsCubit>().selectCurriculum(selected);
          },
        );
      },
    );
  }
}
