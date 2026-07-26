import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_state.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/curriculum_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurriculumListBlocBuilder extends StatelessWidget {
  const CurriculumListBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCurriculumsCubit, GetCurriculumsState>(
      builder: (context, state) {
        final isLoading =
            state is GetCurriculumsInitial || state is GetCurriculumsLoading;

        final curriculums = state is GetCurriculumsSuccess
            ? state.curriculums.reversed.toList()
            : CurriculumModel.placeholderList;

        if (state is GetCurriculumsFailure) {
          return const NoDataWidget();
        }

        if (!isLoading && curriculums.isEmpty) {
          return const NoDataWidget();
        }

        return AppSkeletonizer(
          isLoading: isLoading,
          child: CurriculumList(curriculums: curriculums),
        );
      },
    );
  }
}
