import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdealTeacherBody extends StatefulWidget {
  const IdealTeacherBody({super.key});
  @override
  State<IdealTeacherBody> createState() => _IdealTeacherBodyState();
}

class _IdealTeacherBodyState extends State<IdealTeacherBody> {
  @override
  void initState() {
    super.initState();
    context.read<SupervisorIdealTeacherCubit>().loadTeachers();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<SupervisorIdealTeacherCubit, SupervisorIdealTeacherState>(
        listener: (context, state) {
          if (state.status == SupervisorIdealTeacherStatus.success) {
            showCustomSnackBar(
              context,
              S.of(context).idealTeacherIssuedSuccessfully,
              true,
            );
          } else if (state.status == SupervisorIdealTeacherStatus.failure &&
              state.teachers.isNotEmpty) {
            showCustomSnackBar(context, state.message, false);
          }
        },
        builder: (_, state) => IdealTeacherContent(state: state),
      );
}
