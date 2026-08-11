import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/subject_selection_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentSubjectsStep extends StatelessWidget {
  const ParentSubjectsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final parent = context.watch<ParentAddChildCubit>();
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, lookups) => AppSkeletonizer(
        isLoading: lookups.isLoadingSubjects,
        child: SubjectSelectionList(
          subjects: lookups.subjects,
          selectedSubjectIds: parent.state.selectedSubjectIds,
          selectionMode: parent.state.isSingleSubject
              ? SubjectSelectionMode.single
              : SubjectSelectionMode.multiple,
          onChanged: (values) {
            final current = parent.state.selectedSubjectIds;
            final changed = values.firstWhere(
              (id) => !current.contains(id),
              orElse: () => current.firstWhere(
                (id) => !values.contains(id),
                orElse: () => values.firstOrNull ?? '',
              ),
            );
            if (changed.isNotEmpty) parent.toggleSubject(changed);
          },
        ),
      ),
    );
  }
}
