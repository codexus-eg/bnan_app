import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackagesCurriculumDropdown extends StatelessWidget {
  const PackagesCurriculumDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) {
        final curriculums = state.curriculums;

        final items = <String>[
          'all',
          ...curriculums.map((e) => e.id.toString()),
        ];

        final itemsLabels = <String, String>{
          'all': S.of(context).allCurriculms,
          for (final curriculum in curriculums)
            curriculum.id.toString(): curriculum.name,
        };

        return CustomDropdown(
          label: S.of(context).curriculum,
          value: value ?? 'all',
          items: items,
          itemsLabels: itemsLabels,
          isRequired: true,
          onChanged: (selectedValue) {
            if (selectedValue == 'all') {
              onChanged(null);
              return;
            }

            onChanged(selectedValue);
          },
        );
      },
    );
  }
}