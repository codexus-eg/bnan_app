import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/manager/admin_ideal_supervisor_cubit.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/manager/admin_ideal_supervisor_state.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/policies/ideal_supervisor_error_mapper.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/views/widgets/ideal_supervisor_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdealSupervisorBody extends StatefulWidget {
  const IdealSupervisorBody({super.key});
  @override
  State<IdealSupervisorBody> createState() => _IdealSupervisorBodyState();
}

class _IdealSupervisorBodyState extends State<IdealSupervisorBody> {
  @override
  void initState() {
    super.initState();
    context.read<AdminIdealSupervisorCubit>().load();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<AdminIdealSupervisorCubit, AdminIdealSupervisorState>(
        listener: (context, state) {
          if (state.status == AdminIdealSupervisorStatus.success) {
            showCustomSnackBar(
              context,
              S.of(context).idealSupervisorIssuedSuccessfully,
              true,
            );
          } else if (state.status == AdminIdealSupervisorStatus.failure &&
              state.supervisors.isNotEmpty) {
            showCustomSnackBar(
              context,
              idealSupervisorError(
                S.of(context),
                state.errorCode,
                state.message,
              ),
              false,
            );
          }
        },
        builder: (_, state) => IdealSupervisorContent(state: state),
      );
}
