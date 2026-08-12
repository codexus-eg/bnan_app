import 'dart:async';

import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/curriculum_lookup_dropdown.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentCurriculumField extends StatelessWidget {
  const ParentCurriculumField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AcademicLookupsCubit, AcademicLookupsState>(
      listenWhen: (before, after) =>
          before.selectedCurriculum?.id != after.selectedCurriculum?.id,
      listener: (context, state) {
        final curriculum = state.selectedCurriculum;
        context.read<ParentAddChildCubit>().selectCurriculum(curriculum);
        if (curriculum != null) {
          unawaited(
            context.read<GetPackagesCubit>().getPackagesByCurriculum(
              curriculum.id,
            ),
          );
        }
      },
      child: const CurriculumLookupDropdown(),
    );
  }
}
