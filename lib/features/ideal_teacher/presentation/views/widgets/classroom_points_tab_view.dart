import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_content.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_failure.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/states/plans_classrooms_ui_state.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classrooms_source.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomPointsTabView extends StatelessWidget {
  const ClassroomPointsTabView({
    super.key,
    required this.state,
    this.scrollController,
  });

  final SupervisorIdealTeacherState state;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) => PlansClassroomsSource(
    builder: (context, source, retry) {
      if (source is PlansClassroomsFailure) {
        return IdealTeacherFailure(message: source.message, onRetry: retry);
      }
      if (source is PlansClassroomsLoading) {
        return const AppSkeletonizer(isLoading: true, child: SizedBox.expand());
      }
      final classrooms = source is PlansClassroomsSuccess
          ? source.classrooms
          : const <PlanClassroomOption>[];
      if (classrooms.isEmpty) {
        return NoDataWidget(title: S.of(context).noClassroomsAvailable);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final cubit = context.read<SupervisorIdealTeacherCubit>();
        if (!cubit.isClosed) {
          cubit.setClassrooms(classrooms);
        }
      });
      return IdealTeacherContent(
        state: state,
        classrooms: classrooms,
        scrollController: scrollController,
      );
    },
  );
}
