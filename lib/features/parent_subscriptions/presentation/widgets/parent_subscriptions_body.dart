import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_child_selector.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/get_parent_subscriptions_cubit/get_parent_subscriptions_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/get_parent_subscriptions_cubit/get_parent_subscriptions_state.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/parent_subscription_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentSubscriptionsBody extends StatelessWidget {
  const ParentSubscriptionsBody({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        CustomAppbar(
          headerText: S.of(context).childrenSubscriptions,
          iconNeeded: false,
        ),
        Expanded(
          child:
              BlocBuilder<
                GetParentSubscriptionsCubit,
                GetParentSubscriptionsState
              >(builder: _build),
        ),
      ],
    ),
  );

  Widget _build(BuildContext context, GetParentSubscriptionsState state) {
    if (state is GetParentSubscriptionsFailure) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.message),
            const SizedBox(height: 12),
            SizedBox(
              width: 160,
              child: CustomAppButton(
                text: S.of(context).retry,
                onPressed: context.read<GetParentSubscriptionsCubit>().load,
              ),
            ),
          ],
        ),
      );
    }
    if (state is GetParentSubscriptionsSuccess) {
      if (state.children.isEmpty) return const Center(child: NoDataWidget());
      final child = state.selectedChild;
      return Column(
        children: [
          ParentChildSelector(
            selectorKey: const Key('parentSubscriptionsChildSelector'),
            children: state.children
                .map(
                  (item) => ParentChildSelectorItem(
                    id: item.studentId,
                    name: item.studentName,
                  ),
                )
                .toList(),
            selectedChildId: state.selectedChildId,
            onChanged: context.read<GetParentSubscriptionsCubit>().selectChild,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: child == null || child.subscriptions.isEmpty
                ? const Center(child: NoDataWidget())
                : RefreshIndicator(
                    onRefresh: context.read<GetParentSubscriptionsCubit>().load,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: child.subscriptions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) => ParentSubscriptionCard(
                        child: child,
                        subscription: child.subscriptions[index],
                        onRenewed: context
                            .read<GetParentSubscriptionsCubit>()
                            .load,
                      ),
                    ),
                  ),
          ),
        ],
      );
    }
    return const AppSkeletonizer(
      isLoading: true,
      child: Center(child: NoDataWidget()),
    );
  }
}
