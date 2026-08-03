import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_state.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/supervisor_assignment_card.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorAssignmentBody extends StatelessWidget {
  const SupervisorAssignmentBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSupervisorsCubit, GetSupervisorsState>(
      builder: (context, state) {
        if (state is GetSupervisorsFailure) {
          return UsersManagementFailure(
            message: state.errorMessage,
            onRetry: context.read<GetSupervisorsCubit>().getSupervisors,
          );
        }
        if (state is GetSupervisorsSuccess && state.supervisors.isEmpty) {
          return NoDataWidget(title: S.of(context).noSupervisorsFound);
        }
        final loading = state is GetSupervisorsLoading;
        final supervisors = state is GetSupervisorsSuccess
            ? state.supervisors
            : _skeletonSupervisors;
        return AppSkeletonizer(
          isLoading: loading,
          child: _SupervisorList(supervisors: supervisors),
        );
      },
    );
  }
}

class _SupervisorList extends StatelessWidget {
  const _SupervisorList({required this.supervisors});

  final List<SupervisorModel> supervisors;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
    itemCount: supervisors.length,
    separatorBuilder: (_, _) => const SizedBox(height: 16),
    itemBuilder: (_, index) =>
        SupervisorAssignmentCard(supervisor: supervisors[index]),
  );
}

const _skeletonSupervisors = [
  SupervisorModel(user: SupervisorUserModel(fullName: 'Supervisor name')),
  SupervisorModel(user: SupervisorUserModel(fullName: 'Supervisor name')),
  SupervisorModel(user: SupervisorUserModel(fullName: 'Supervisor name')),
];
