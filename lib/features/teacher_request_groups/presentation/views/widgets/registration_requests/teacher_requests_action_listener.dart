import 'dart:async';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_cubit.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_cubit.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_state.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_request_action_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void handleTeacherRequestsAction(
  BuildContext context,
  TeacherRegistrationRequestsState state,
) {
  final s = S.of(context);
  if (state is TeacherRequestAccepted) {
    Navigator.of(context).pop();
    showCustomSnackBar(context, s.teacherRequestAcceptedSuccess, true);
    unawaited(context.read<GetTeacherClassroomsCubit>().getMyClassrooms());
  } else if (state is TeacherRequestAlreadyAssigned) {
    _closeAndRefresh(context, s.teacherRequestAlreadyAssigned);
  } else if (state is TeacherRequestNotEligible) {
    _closeAndRefresh(context, s.teacherRequestNotEligible);
  } else if (state is TeacherRequestNotFound) {
    Navigator.of(context).pop();
    unawaited(context.read<TeacherRegistrationRequestsCubit>().refresh());
  } else if (state is TeacherRequestAcceptFailure) {
    showCustomSnackBar(context, state.message, false);
  }
}

void _closeAndRefresh(BuildContext context, String message) {
  Navigator.of(context).pop();
  showCustomSnackBar(context, message, false);
  unawaited(context.read<TeacherRegistrationRequestsCubit>().refresh());
}
