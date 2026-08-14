import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_state.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/parent_subscription_renewal_body.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_checkout_launcher.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentSubscriptionRenewalView extends StatefulWidget {
  const ParentSubscriptionRenewalView({super.key});
  @override
  State<ParentSubscriptionRenewalView> createState() => _State();
}

class _State extends State<ParentSubscriptionRenewalView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<ParentSubscriptionRenewalCubit>().reconcilePayment();
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<
        ParentSubscriptionRenewalCubit,
        ParentSubscriptionRenewalState
      >(
        listenWhen: (before, after) =>
            !before.shouldOpenCheckout && after.shouldOpenCheckout,
        listener: _open,
        child: Scaffold(
          appBar: CustomAppbar(headerText: S.of(context).renewSubscription),
          body: const ParentSubscriptionRenewalBody(),
        ),
      );

  Future<void> _open(
    BuildContext context,
    ParentSubscriptionRenewalState state,
  ) async {
    final url = state.checkoutUrl;
    context.read<ParentSubscriptionRenewalCubit>().checkoutOpened();
    final cubit = context.read<ParentSubscriptionRenewalCubit>();
    final result = url == null
        ? const TamaraCheckoutLaunchResult(opened: false)
        : await TamaraCheckoutLauncher.open(
            context,
            url,
            completionStream: cubit.stream.map(
              (value) => value.phase == ParentRenewalPhase.completed,
            ),
            isCompleted: () =>
                cubit.state.phase == ParentRenewalPhase.completed,
            onOpened: cubit.reconcilePayment,
          );
    if (!context.mounted) return;
    if (!result.opened) {
      context.read<ParentSubscriptionRenewalCubit>().checkoutOpenFailed();
      showCustomSnackBar(
        context,
        S.of(context).parentUnableToOpenCheckout,
        false,
      );
      return;
    }
    await context.read<ParentSubscriptionRenewalCubit>().reconcilePayment();
  }
}
