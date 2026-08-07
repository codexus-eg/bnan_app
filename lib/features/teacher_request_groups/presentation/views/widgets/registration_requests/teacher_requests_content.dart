import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_state.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_cubit.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/teacher_requests_failure.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/teacher_requests_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherRequestsContent extends StatelessWidget {
  const TeacherRequestsContent({super.key, required this.state});
  final TeacherRegistrationRequestsState state;

  @override
  Widget build(BuildContext context) {
    if (state is TeacherRequestsInitial || state is TeacherRequestsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state case TeacherRequestsFailure failure) {
      return TeacherRequestsFailureView(message: failure.message);
    }
    if (state is TeacherRequestsEmpty) return _empty(context);
    if (state case TeacherRequestsDataState data) {
      if (data.requests.isEmpty) return _empty(context);
      return TeacherRequestsList(
        requests: data.requests,
        isLoadingMore: state is TeacherRequestsLoadingMore,
        loadMoreError: state is TeacherRequestsLoadMoreFailure
            ? (state as TeacherRequestsLoadMoreFailure).message
            : null,
      );
    }
    return _empty(context);
  }

  Widget _empty(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<TeacherRegistrationRequestsCubit>().refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 500,
            child: NoDataWidget(title: S.of(context).noNewRegistrationRequests),
          ),
        ],
      ),
    );
  }
}
