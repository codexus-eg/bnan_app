import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_subscription_renewal_model.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/widgets/admin_renewal_card.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_list_footer.dart';
import 'package:flutter/material.dart';

class AdminRenewalsList extends StatelessWidget {
  const AdminRenewalsList({
    super.key,
    required this.controller,
    required this.items,
    required this.onRefresh,
    required this.onLoadMoreRetry,
    this.loadingMore = false,
    this.loadMoreError,
  });
  final ScrollController controller;
  final List<AdminSubscriptionRenewalModel> items;
  final Future<void> Function() onRefresh, onLoadMoreRetry;
  final bool loadingMore;
  final String? loadMoreError;

  @override
  Widget build(BuildContext context) {
    final footer = loadingMore || loadMoreError != null;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
        itemCount: items.length + (footer ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) => index == items.length
            ? RegistrationRequestsListFooter(
                isLoading: loadingMore,
                errorMessage: loadMoreError,
                onRetry: onLoadMoreRetry,
              )
            : AdminRenewalCard(item: items[index]),
      ),
    );
  }
}
