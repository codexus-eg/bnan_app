import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/student_auth/data/models/curriculum_model.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculums_cubit/get_curriculums_state.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcademicCurriculumDropdown extends StatelessWidget {
  const AcademicCurriculumDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RegisterCubit>();
    return BlocBuilder<GetCurriculumsCubit, GetCurriculumsState>(
      builder: (context, state) {
        final list = state is GetCurriculumsSuccess
            ? state.curriculums
            : <CurriculumModel>[];
        final items = list.map((item) => item.name).toList();
        return CustomDropdown(
          label: S.of(context).curriculum,
          value: cubit.selectedCurriculumName ??
              (cubit.curriculumName.isNotEmpty ? cubit.curriculumName : null),
          hint: S.of(context).selectCurriculum,
          items: items,
          isRequired: true,
          onChanged: (name) {
            if (name == null) return;
            final item = list.firstWhere((c) => c.name == name);
            cubit.selectCurriculum(item);
            context.read<GetGradesCubit>().getCurriculumGrades(
                  curriculumId: item.id,
                  isGulf: cubit.isGulf,
                );
            context.read<GetPackagesCubit>().getPackagesByCurriculum(item.id);
          },
        );
      },
    );
  }
}
