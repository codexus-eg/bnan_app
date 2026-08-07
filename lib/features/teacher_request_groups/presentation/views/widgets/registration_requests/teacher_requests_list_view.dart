import 'package:bnan_app/features/teacher_request_groups/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_cubit.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/registration_request_card.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/teacher_requests_list_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherRequestsListView extends StatelessWidget {
  const TeacherRequestsListView({
    super.key,
    required this.controller,
    required this.requests,
    required this.isLoadingMore,
    this.loadMoreError,
  });
  final ScrollController controller;
  final List<RegistrationRequestModel> requests;
  final bool isLoadingMore;
  final String? loadMoreError;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: context.read<TeacherRegistrationRequestsCubit>().refresh,
    child: ListView.builder(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.all(16),
      itemCount: requests.length + 1,
      itemBuilder: (context, index) => index == requests.length
          ? TeacherRequestsListFooter(
              loading: isLoadingMore,
              error: loadMoreError,
            )
          : _card(context, requests[index]),
    ),
  );

  Widget _card(BuildContext context, RegistrationRequestModel request) {
    final cubit = context.read<TeacherRegistrationRequestsCubit>();
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
      child: RegistrationRequestCard(
        request: request,
        isAccepting: cubit.acceptingRequestId == request.requestId,
        onAccept: () => cubit.acceptRequest(request.requestId),
      ),
    );
  }
}
