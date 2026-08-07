import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/student_subjects/presentation/manager/get_student_subjects/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/student_subjects/presentation/manager/get_student_subjects/get_student_subjects_state.dart';
import 'package:bnan_app/features/student_subjects/presentation/views/widgets/student_subjects_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget? studentSubjectsTerminalView(
  BuildContext context,
  GetMySubjectsState state,
) {
  final retry = context.read<GetMySubjectsCubit>().retry;
  if (state is GetMySubjectsUnauthorized) {
    return StudentSubjectsFailure(
      message: S.of(context).errorUnauthorized,
      onRetry: retry,
    );
  }
  if (state is GetMySubjectsFailure) {
    return StudentSubjectsFailure(
      message: S.of(context).unableToLoadSubjects,
      onRetry: retry,
    );
  }
  if (state is GetMySubjectsEmpty) {
    return NoDataWidget(title: S.of(context).noSubjectsRegistered);
  }
  return null;
}
