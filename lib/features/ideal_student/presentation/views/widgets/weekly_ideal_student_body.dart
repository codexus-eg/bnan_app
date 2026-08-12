import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/ideal_student/data/models/ideal_student_skeleton_data.dart';
import 'package:bnan_app/features/ideal_student/presentation/manager/ideal_student_cubit.dart';
import 'package:bnan_app/features/ideal_student/presentation/manager/ideal_student_state.dart';
import 'package:bnan_app/features/ideal_student/presentation/views/widgets/ideal_students_ranked_list.dart';
import 'package:bnan_app/features/ideal_student/presentation/views/widgets/top_ideal_student_card.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/states/plans_classrooms_ui_state.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classrooms_source.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyIdealStudentBody extends StatefulWidget {
  const WeeklyIdealStudentBody({super.key});

  @override
  State<WeeklyIdealStudentBody> createState() => _WeeklyIdealStudentBodyState();
}

class _WeeklyIdealStudentBodyState extends State<WeeklyIdealStudentBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
  }

  void _loadMore() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 160) {
      context.read<IdealStudentCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlansClassroomsSource(
      builder: (context, source, retry) {
        if (source is PlansClassroomsFailure) {
          return WeeklyEvaluationsFailure(
            message: source.message,
            onRetry: retry,
          );
        }
        final sourceEmpty = source is PlansClassroomsEmpty;
        final classrooms = source is PlansClassroomsSuccess
            ? source.classrooms
            : sourceEmpty
            ? const <PlanClassroomOption>[]
            : null;
        if (classrooms != null) _syncClassrooms(classrooms);
        return _content(
          classrooms,
          source is PlansClassroomsLoading,
          sourceEmpty,
        );
      },
    );
  }

  Widget _content(
    List<PlanClassroomOption>? classrooms,
    bool sourceLoading,
    bool sourceEmpty,
  ) {
    return BlocConsumer<IdealStudentCubit, IdealStudentState>(
      listener: (context, state) {
        if (state is IdealStudentRefreshFailure ||
            state is IdealStudentLoadMoreFailure) {
          final message = state is IdealStudentRefreshFailure
              ? state.message
              : (state as IdealStudentLoadMoreFailure).message;
          showCustomSnackBar(context, message, false);
        }
      },
      builder: (context, state) => Padding(
        padding: const EdgeInsetsDirectional.only(top: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _classroomFilter(classrooms),
            ),
            const SizedBox(height: 8),
            Expanded(child: _result(state, sourceLoading, sourceEmpty)),
          ],
        ),
      ),
    );
  }

  Widget _classroomFilter(List<PlanClassroomOption>? classrooms) {
    final cubit = context.read<IdealStudentCubit>();
    return CustomDropdown(
      label: S.of(context).classRoom,
      hint: S.of(context).selectClassroom,
      value: cubit.selectedClassroom?.id,
      items: classrooms?.map((item) => item.id).toList(),
      itemsLabels: {
        for (final item in classrooms ?? const <PlanClassroomOption>[])
          item.id: item.name,
      },
      backgroundColor: ColorManager.white,
      onChanged: (id) => cubit.selectClassroom(
        classrooms?.where((item) => item.id == id).firstOrNull,
      ),
    );
  }

  Widget _result(
    IdealStudentState state,
    bool sourceLoading,
    bool sourceEmpty,
  ) {
    final cubit = context.read<IdealStudentCubit>();
    if (sourceEmpty) return const NoDataWidget();
    if (state is IdealStudentFailure) {
      return WeeklyEvaluationsFailure(
        message: state.message,
        onRetry: cubit.retry,
      );
    }
    if (state is IdealStudentEmpty) return const NoDataWidget();
    final loading = sourceLoading || state is IdealStudentLoading;
    final winner = loading ? idealStudentSkeleton : cubit.idealStudent;
    if (!loading && winner == null) return const NoDataWidget();
    final students = loading ? idealStudentRankingSkeleton : cubit.ranking;
    return AppSkeletonizer(
      isLoading: loading,
      child: RefreshIndicator(
        onRefresh: cubit.refresh,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              TopIdealStudentCard(student: winner!),
              IdealStudentsRankedList(students: students),
              if (state is IdealStudentLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _syncClassrooms(List<PlanClassroomOption> classrooms) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<IdealStudentCubit>().setClassrooms(classrooms);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
