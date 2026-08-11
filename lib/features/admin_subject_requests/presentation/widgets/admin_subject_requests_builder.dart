import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_model.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_requests_cubit.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_requests_state.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/widgets/admin_subject_requests_list.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_empty.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSubjectRequestsBuilder extends StatelessWidget {
  const AdminSubjectRequestsBuilder({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminSubjectRequestsCubit, AdminSubjectRequestsState>(
        builder: (context, state) {
          final cubit = context.read<AdminSubjectRequestsCubit>();
          Future<void> refresh() => cubit.load(refresh: true);
          if (state is AdminSubjectRequestsFailure) {
            return RegistrationRequestsFailure(
              message: state.message,
              onRetry: refresh,
            );
          }
          if (state is AdminSubjectRequestsInitial ||
              state is AdminSubjectRequestsLoading) {
            return AppSkeletonizer(
              isLoading: true,
              child: AdminSubjectRequestsList(
                controller: controller,
                requests: _placeholders,
                onRefresh: refresh,
              ),
            );
          }
          final success = state as AdminSubjectRequestsSuccess;
          if (success.requests.isEmpty) {
            return RegistrationRequestsEmpty(
              message: S.of(context).adminSubjectRequestsEmpty,
              onRefresh: refresh,
            );
          }
          return AdminSubjectRequestsList(
            controller: controller,
            requests: success.requests,
            onRefresh: refresh,
            isLoadingMore: success.isLoadingMore,
            loadMoreError: success.loadMoreError,
            onRetryLoadMore: cubit.loadMore,
          );
        },
      );
}

const _placeholders = [
  AdminSubjectRequestModel(
    id: '1',
    status: 'awaiting_admin_approval',
    studentName: 'Student name',
    curriculum: 'Curriculum',
    grade: 'Grade',
    subject: 'Subject',
    packageName: 'Package',
  ),
  AdminSubjectRequestModel(
    id: '2',
    status: 'awaiting_admin_approval',
    studentName: 'Student name',
    curriculum: 'Curriculum',
    subject: 'Subject',
  ),
];
