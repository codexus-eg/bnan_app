import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/manager/admin_subscription_renewals_cubit.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/manager/admin_subscription_renewals_state.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/widgets/admin_renewal_status_tabs.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/widgets/admin_renewals_list.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_empty.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSubscriptionRenewalsBody extends StatefulWidget {
  const AdminSubscriptionRenewalsBody({super.key});
  @override
  State<AdminSubscriptionRenewalsBody> createState() =>
      _AdminSubscriptionRenewalsBodyState();
}

class _AdminSubscriptionRenewalsBodyState
    extends State<AdminSubscriptionRenewalsBody> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<
        AdminSubscriptionRenewalsCubit,
        AdminSubscriptionRenewalsState
      >(
        listenWhen: (old, next) =>
            old.actionError != next.actionError && next.actionError != null,
        listener: (context, state) =>
            showCustomSnackBar(context, state.actionError!, false),
        builder: (context, state) => Column(
          children: [
            AdminRenewalStatusTabs(
              selected: state.status,
              onChanged: context
                  .read<AdminSubscriptionRenewalsCubit>()
                  .selectStatus,
            ),
            Expanded(child: _content(context, state)),
          ],
        ),
      );

  Widget _content(BuildContext context, AdminSubscriptionRenewalsState state) {
    final cubit = context.read<AdminSubscriptionRenewalsCubit>();
    if (state.loading) return const Center(child: CircularProgressIndicator());
    if (state.error != null) {
      return RegistrationRequestsFailure(
        message: state.error!,
        onRetry: cubit.load,
      );
    }
    if (state.items.isEmpty) {
      return RegistrationRequestsEmpty(
        message: S.of(context).renewalNoRequests,
        onRefresh: cubit.load,
      );
    }
    return AdminRenewalsList(
      controller: _scroll,
      items: state.items,
      loadingMore: state.loadingMore,
      loadMoreError: state.loadMoreError,
      onRefresh: cubit.load,
      onLoadMoreRetry: cubit.loadMore,
    );
  }

  void _loadMore() {
    if (_scroll.position.extentAfter < 200) {
      context.read<AdminSubscriptionRenewalsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }
}
