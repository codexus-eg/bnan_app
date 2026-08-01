import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_state.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_state.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classrooms_feedback.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/term_plans/term_plans_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermPlansClassroomFilter extends StatelessWidget {
  const TermPlansClassroomFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassroomsCubit, ClassroomsState>(
      builder: (context, classroomsState) {
        final classrooms = classroomsState is ClassroomsSuccess
            ? classroomsState.response.data
            : const <ClassroomModel>[];
        return BlocBuilder<GetTermPlansCubit, GetTermPlansState>(
          builder: (context, _) => Column(
            children: [
              TermPlansDropdown(classrooms: classrooms),
              if (classroomsState is ClassroomsFailure)
                PlansClassroomsFeedback(
                  message: classroomsState.message,
                  onRetry: context.read<ClassroomsCubit>().getClassrooms,
                ),
            ],
          ),
        );
      },
    );
  }
}
