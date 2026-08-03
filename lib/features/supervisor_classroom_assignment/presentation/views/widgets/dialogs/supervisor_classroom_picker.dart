import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/grade_lookup_dropdown.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorClassroomPicker extends StatelessWidget {
  const SupervisorClassroomPicker({
    super.key,
    required this.assignedClassroomIds,
  });

  final Set<String> assignedClassroomIds;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GradeLookupDropdown(),
        const SizedBox(height: 16),
        BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
          builder: (context, state) {
            final available = state.classrooms
                .where((item) => !assignedClassroomIds.contains(item.id))
                .toList(growable: false);
            return Column(
              children: [
                CustomDropdown(
                  label: S.of(context).classroom,
                  hint: state.isLoadingClassrooms
                      ? S.of(context).loading
                      : S.of(context).chooseClassroom,
                  value:
                      available.any(
                        (item) => item.id == state.selectedClassroom?.id,
                      )
                      ? state.selectedClassroom?.id
                      : null,
                  items:
                      state.selectedGrade == null || state.isLoadingClassrooms
                      ? null
                      : available.map((item) => item.id).toList(),
                  itemsLabels: {
                    for (final item in available) item.id: item.name,
                  },
                  onChanged: (id) {
                    final selected = available
                        .where((item) => item.id == id)
                        .firstOrNull;
                    context.read<AcademicLookupsCubit>().selectClassroom(
                      selected,
                    );
                  },
                ),
                if (state.selectedGrade != null &&
                    !state.isLoadingClassrooms &&
                    available.isEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 8),
                    child: Text(
                      S.of(context).noClassroomsAvailableForGrade,
                      style: StylesManager.styleRegular12(
                        context,
                      ).copyWith(color: ColorManager.red),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
