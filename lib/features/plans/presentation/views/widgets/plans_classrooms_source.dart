import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_state.dart';
import 'package:bnan_app/features/plans/presentation/mappers/plan_classroom_options_mapper.dart';
import 'package:bnan_app/features/plans/presentation/states/plans_classrooms_ui_state.dart';
import 'package:bnan_app/features/student_groups/presentation/manager/get_my_enrollments/get_my_enrollments_cubit.dart';
import 'package:bnan_app/features/student_groups/presentation/manager/get_my_enrollments/get_my_enrollments_state.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_cubit.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';

typedef PlansClassroomsBuilder =
    Widget Function(
      BuildContext context,
      PlansClassroomsUiState state,
      VoidCallback onRetry,
    );

class PlansClassroomsSource extends StatelessWidget {
  const PlansClassroomsSource({
    super.key,
    required this.builder,
    this.policy,
  });

  final PlansClassroomsBuilder builder;
  final PlansAccessPolicy? policy;

  @override
  Widget build(BuildContext context) {
    return switch (SessionManager.instance.userRole?.trim().toLowerCase()) {
      'teacher' =>
        BlocBuilder<GetTeacherClassroomsCubit, GetTeacherClassroomsState>(
          builder: (context, state) => _teacher(context, state),
        ),
      'student' =>
        policy?.isGulfStudent == true
            ? BlocBuilder<GulfScheduleCubit, GulfScheduleState>(
                builder: (context, state) => _gulfStudent(context, state),
              )
            : BlocBuilder<GetMyEnrollmentsCubit, GetMyEnrollmentsState>(
                builder: (context, state) => _student(context, state),
              ),
      'supervisor' =>
        BlocBuilder<GetSupervisorClassroomsCubit, GetSupervisorClassroomsState>(
          builder: (context, state) => _supervisor(context, state),
        ),
      'admin' => BlocBuilder<ClassroomsCubit, ClassroomsState>(
        builder: (context, state) => _admin(context, state),
      ),
      _ => builder(context, const PlansClassroomsSuccess([]), () {}),
    };
  }

  Widget _gulfStudent(BuildContext context, GulfScheduleState state) {
    final uiState = switch (state.status) {
      GulfScheduleLoadStatus.ready => PlansClassroomsSuccess(
        mapGulfScheduleToPlanOptions(state.classrooms),
      ),
      GulfScheduleLoadStatus.failure => PlansClassroomsFailure(
        state.loadError ?? S.of(context).unexpectedError,
      ),
      _ => const PlansClassroomsLoading(),
    };
    return builder(context, uiState, context.read<GulfScheduleCubit>().load);
  }

  Widget _teacher(BuildContext context, GetTeacherClassroomsState state) {
    final uiState = switch (state) {
      GetTeacherClassroomsSuccess() => PlansClassroomsSuccess(
        mapTeacherClassroomsToPlanOptions(state.classrooms.classrooms),
      ),
      GetTeacherClassroomsFailure() => PlansClassroomsFailure(
        state.errorMessage,
      ),
      _ => const PlansClassroomsLoading(),
    };
    return builder(
      context,
      uiState,
      context.read<GetTeacherClassroomsCubit>().getMyClassrooms,
    );
  }

  Widget _student(BuildContext context, GetMyEnrollmentsState state) {
    final uiState = switch (state) {
      GetMyEnrollmentsSuccess() => PlansClassroomsSuccess(
        mapStudentEnrollmentsToPlanOptions(state.enrollments),
      ),
      GetMyEnrollmentsFailure() => PlansClassroomsFailure(state.errorMessage),
      _ => const PlansClassroomsLoading(),
    };
    return builder(
      context,
      uiState,
      context.read<GetMyEnrollmentsCubit>().getMyEnrollments,
    );
  }

  Widget _supervisor(BuildContext context, GetSupervisorClassroomsState state) {
    final uiState = switch (state) {
      GetSupervisorClassroomsSuccess() => PlansClassroomsSuccess(
        mapSupervisorClassroomsToPlanOptions(state.response.data),
      ),
      GetSupervisorClassroomsFailure() => PlansClassroomsFailure(
        state.errorMessage,
      ),
      _ => const PlansClassroomsLoading(),
    };
    return builder(
      context,
      uiState,
      context.read<GetSupervisorClassroomsCubit>().getMyClassrooms,
    );
  }

  Widget _admin(BuildContext context, ClassroomsState state) {
    final uiState = switch (state) {
      ClassroomsSuccess() => PlansClassroomsSuccess(
        mapAdminClassroomsToPlanOptions(state.response.data),
      ),
      ClassroomsFailure() => PlansClassroomsFailure(state.message),
      _ => const PlansClassroomsLoading(),
    };
    return builder(
      context,
      uiState,
      context.read<ClassroomsCubit>().getClassrooms,
    );
  }
}
