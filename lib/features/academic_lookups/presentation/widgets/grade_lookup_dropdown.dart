import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GradeLookupDropdown extends StatelessWidget {
  const GradeLookupDropdown({super.key, this.hint});

  final String? hint;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) {
        final canSelect = state.selectedCurriculum != null;
        final items = !canSelect || state.isLoadingGrades
            ? null
            : state.grades.map((item) => item.id).toList();

        final isEmpty =
            canSelect &&
            !state.isLoadingGrades &&
            state.errorMessage == null &&
            state.grades.isEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown(
              label: S.of(context).grade,
              hint: state.isLoadingGrades
                  ? S.of(context).loading
                  : hint ?? S.of(context).grade,
              value: state.selectedGrade?.id,
              items: items,
              itemsLabels: {
                for (final item in state.grades) item.id: item.name,
              },
              onChanged: (value) {
                final selected = state.grades
                    .where((item) => item.id == value)
                    .firstOrNull;
                context.read<AcademicLookupsCubit>().selectGrade(selected);
              },
            ),
            if (isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                S.of(context).noGradesAvailableForCurriculum,
                style: StylesManager.styleRegular12(
                  context,
                ).copyWith(color: ColorManager.red),
              ),
            ],
          ],
        );
      },
    );
  }
}
