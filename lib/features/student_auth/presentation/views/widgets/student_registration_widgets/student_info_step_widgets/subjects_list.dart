import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_auth/data/models/subject_model.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_state.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';
import 'package:bnan_app/core/shared_widget/custom_option_tile.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectsList extends StatelessWidget {
  const SubjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    final registerCubit = RegisterCubit.get(context);

    return BlocBuilder<GetCurriculmSubjectsCubit, GetCurriculmSubjectsState>(
      builder: (context, state) {
        final isLoading = state is GetSubjectsLoading;

        if (state is GetSubjectsInitial) {
          return Text(
            S.of(context).selectGrade,
            style: StylesManager.styleRegular14(
              context,
            ).copyWith(color: ColorManager.grey7D7D),
          );
        }

        if (state is GetSubjectsFailure) {
          return Text(
            state.errorMessage,
            style: StylesManager.styleRegular14(
              context,
            ).copyWith(color: Colors.red),
          );
        }

        final subjects = state is GetSubjectsSuccess
            ? state.subjects
            : SubjectModel.placeholderList();

        if (state is GetSubjectsSuccess && subjects.isEmpty) {
          return Text(
            S.of(context).noSubjectsAvailable,
            style: StylesManager.styleRegular14(
              context,
            ).copyWith(color: ColorManager.grey7D7D),
          );
        }

        return AppSkeletonizer(
          isLoading: isLoading,
          child: BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, registerState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.of(context).subjects,
                        style: StylesManager.styleBold14(
                          context,
                        ).copyWith(color: ColorManager.mainColor15),
                      ),
                      const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...subjects.map((subject) {
                    final isSelected = registerCubit.selectedSubjectIds
                        .contains(subject.id);

                    return CustomOptionTile(
                      title: subject.name,
                      isSelected: isSelected,
                      onTap: () {
                        if (isLoading) return;
                        registerCubit.toggleSubject(subject.id);
                      },
                    );
                  }),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
