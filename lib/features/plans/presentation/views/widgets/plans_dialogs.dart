import 'package:bnan_app/core/helper/app_dialogs.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/utils/plans_file_picker.dart';
import 'package:bnan_app/features/plans/presentation/manager/plans_actions/plans_actions_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_details_cubit/classroom_details_cubit.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/add_daily_plan_dialog.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/upload_study_plan_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PlansDialogs {
  static Future<bool?> showAdd(
    BuildContext context,
    PlansAccessPolicy policy, {
    required PlanClassroomOption classroom,
    required int selectedWeek,
  }) {
    if (!policy.canAddDailyPlan) return Future.value(false);
    return AppDialogs.show<bool>(
      context: context,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<PlansActionsCubit>()),
          BlocProvider.value(value: context.read<GetClassroomSubjectsCubit>()),
          BlocProvider.value(
            value: context.read<GetTeacherAssignedSubjectsCubit>(),
          ),
          BlocProvider.value(value: context.read<ClassroomDetailsCubit>()),
        ],
        child: AddDailyPlanDialog(
          policy: policy,
          classroom: classroom,
          selectedWeek: selectedWeek,
        ),
      ),
    );
  }

  static Future<String?> showUpload(
    BuildContext context,
    PlansAccessPolicy policy, {
    required List<PlanClassroomOption> classrooms,
    PlanClassroomOption? initialClassroom,
    PlansFilePicker? filePicker,
  }) {
    if (!policy.canUploadPlan) return Future.value();
    return AppDialogs.show<String>(
      context: context,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<PlansActionsCubit>()),
          BlocProvider.value(value: context.read<GetClassroomSubjectsCubit>()),
          BlocProvider.value(
            value: context.read<GetTeacherAssignedSubjectsCubit>(),
          ),
        ],
        child: UploadStudyPlanDialog(
          policy: policy,
          classrooms: classrooms,
          initialClassroom: initialClassroom,
          filePicker: filePicker,
        ),
      ),
    );
  }
}
