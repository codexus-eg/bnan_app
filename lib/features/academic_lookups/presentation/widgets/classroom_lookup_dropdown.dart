import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomLookupDropdown extends StatelessWidget {
  const ClassroomLookupDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) {
        final canSelect = state.selectedGrade != null;
        final items = !canSelect || state.isLoadingClassrooms
            ? null
            : state.classrooms.map((item) => item.id).toList();

        return CustomDropdown(
          label: S.of(context).classRoom,
          hint: state.isLoadingClassrooms
              ? S.of(context).loading
              : S.of(context).chooseClassRoom,
          value: state.selectedClassroom?.id,
          items: items,
          itemsLabels: {
            for (final item in state.classrooms) item.id: item.name,
          },
          onChanged: (value) {
            final selected = state.classrooms
                .where((item) => item.id == value)
                .firstOrNull;
            context.read<AcademicLookupsCubit>().selectClassroom(selected);
          },
        );
      },
    );
  }
}
