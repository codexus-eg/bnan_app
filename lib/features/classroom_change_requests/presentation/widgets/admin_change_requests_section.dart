import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_request_model.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_requests_cubit.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_requests_state.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/admin_change_requests_list.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_empty.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminChangeRequestsSection extends StatelessWidget {
  const AdminChangeRequestsSection({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminChangeRequestsCubit, AdminChangeRequestsState>(
        builder: (context, state) {
          final cubit = context.read<AdminChangeRequestsCubit>();
          if (state is AdminChangeRequestsFailure) {
            return RegistrationRequestsFailure(
              message: state.message,
              onRetry: cubit.load,
            );
          }
          if (state is AdminChangeRequestsInitial ||
              state is AdminChangeRequestsLoading) {
            return AppSkeletonizer(
              isLoading: true,
              child: AdminChangeRequestsList(
                requests: _placeholders,
                onRefresh: cubit.load,
              ),
            );
          }
          final requests = (state as AdminChangeRequestsSuccess).requests;
          if (requests.isEmpty) {
            return RegistrationRequestsEmpty(
              message: S.of(context).changeRequestsEmpty,
              onRefresh: cubit.load,
            );
          }
          return AdminChangeRequestsList(
            requests: requests,
            onRefresh: cubit.load,
          );
        },
      );
}

const _placeholders = [
  ClassroomChangeRequestModel(
    id: '1',
    status: 'pending',
    requesterName: 'Requester',
    requesterType: 'student',
    classroomName: 'Classroom',
    subjectName: 'Subject',
    notes: 'Reason',
    requestType: 'change_teacher',
  ),
];
