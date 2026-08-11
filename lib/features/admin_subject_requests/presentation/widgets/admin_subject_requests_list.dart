import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_model.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/widgets/admin_subject_request_card.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_list_footer.dart';
import 'package:flutter/material.dart';

class AdminSubjectRequestsList extends StatelessWidget {
  const AdminSubjectRequestsList({
    super.key,
    required this.controller,
    required this.requests,
    required this.onRefresh,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.onRetryLoadMore,
  });
  final ScrollController controller;
  final List<AdminSubjectRequestModel> requests;
  final Future<void> Function() onRefresh;
  final bool isLoadingMore;
  final String? loadMoreError;
  final Future<void> Function()? onRetryLoadMore;

  @override
  Widget build(BuildContext context) {
    final hasFooter = isLoadingMore || loadMoreError != null;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
        itemCount: requests.length + (hasFooter ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) => index == requests.length
            ? RegistrationRequestsListFooter(
                isLoading: isLoadingMore,
                errorMessage: loadMoreError,
                onRetry: onRetryLoadMore,
              )
            : AdminSubjectRequestCard(request: requests[index]),
      ),
    );
  }
}
