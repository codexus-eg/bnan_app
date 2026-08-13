import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/manager/admin_ideal_supervisor_cubit.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/manager/admin_ideal_supervisor_state.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/views/widgets/ideal_supervisor_result.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdealSupervisorContent extends StatelessWidget {
  const IdealSupervisorContent({super.key, required this.state});
  final AdminIdealSupervisorState state;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            S.of(context).selectIdealSupervisor,
            style: StylesManager.styleBold16(context),
          ),
        ),
      ),
      Expanded(child: IdealSupervisorResult(state: state)),
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
        child: CustomAppButton(
          text: S.of(context).issueCertificate,
          isLoading: state.isSubmitting,
          onPressed: state.selectedIds.isEmpty || state.isSubmitting
              ? null
              : () => context.read<AdminIdealSupervisorCubit>().submit(
                  SessionManager.instance.userName ?? '',
                ),
        ),
      ),
    ],
  );
}
