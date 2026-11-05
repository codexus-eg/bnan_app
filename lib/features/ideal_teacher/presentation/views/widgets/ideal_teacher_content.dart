import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_result.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/teacher_ranking_header.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdealTeacherContent extends StatelessWidget {
  const IdealTeacherContent({
    super.key,
    required this.state,
    required this.classrooms,
    this.scrollController,
  });

  final SupervisorIdealTeacherState state;
  final List<PlanClassroomOption> classrooms;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupervisorIdealTeacherCubit>();

    return Column(
      children: [
        TeacherRankingHeader(
          classrooms: classrooms,
          selectedClassroom: cubit.selectedClassroom,
          onClassroomChanged: cubit.selectClassroom,
          response: state.rankingResponse,
        ),
        Expanded(
          child: IdealTeacherResult(
            state: state,
            scrollController: scrollController,
          ),
        ),
      ],
    );
  }
}
