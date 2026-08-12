import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_result.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdealTeacherContent extends StatelessWidget {
  const IdealTeacherContent({super.key, required this.state});
  final SupervisorIdealTeacherState state;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            S.of(context).selectIdealTeacher,
            style: StylesManager.styleBold16(context),
          ),
        ),
      ),
      Expanded(child: IdealTeacherResult(state: state)),
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
        child: CustomAppButton(
          text: S.of(context).issueCertificate,
          isLoading: state.isSubmitting,
          onPressed: state.selectedTeacherIds.isEmpty || state.isSubmitting
              ? null
              : context.read<SupervisorIdealTeacherCubit>().submitIdealTeachers,
        ),
      ),
    ],
  );
}
