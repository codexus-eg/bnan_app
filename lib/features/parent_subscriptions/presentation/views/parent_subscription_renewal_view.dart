import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_flow_result.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/diagnostics/gulf_renewal_trace.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_state.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/parent_subscription_renewal_body.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_state.dart';
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
      GulfRenewalTrace.log('reconcile triggered', details: 'source=lifecycle');
      context.read<ParentSubscriptionRenewalCubit>().reconcilePayment();
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<GetPackagesCubit, GetPackagesState>(
        listener: (context, state) {
          if (state is GetPackagesSuccess) {
            context
                .read<ParentSubscriptionRenewalCubit>()
                .selectAutomaticMonthlyPackage(state.packages);
          }
        },
        child:
            BlocListener<
              ParentSubscriptionRenewalCubit,
              ParentSubscriptionRenewalState
            >(
              listenWhen: (before, after) {
                if (after.isGulf) {
                  return !before.shouldOpenCheckout && after.shouldOpenCheckout;
                }
                return before.phase == ParentRenewalPhase.submitting &&
                    (after.phase == ParentRenewalPhase.pending ||
                        after.phase == ParentRenewalPhase.editing &&
                            after.errorMessage != null);
              },
              listener: _onState,
              child: Scaffold(
                appBar: CustomAppbar(
                  headerText: S.of(context).renewSubscription,
                ),
                body: const ParentSubscriptionRenewalBody(),
              ),
            ),
      );

  Future<void> _onState(
    BuildContext context,
    ParentSubscriptionRenewalState state,
  ) async {
    if (state.isGulf) {
      return _open(context, state);
    }
    if (state.phase == ParentRenewalPhase.pending) {
      MyNavigator.pop(context, ParentFlowResult.pendingReview);
      return;
    }
    showCustomSnackBar(context, state.errorMessage!, false);
  }

  Future<void> _open(
    BuildContext context,
    ParentSubscriptionRenewalState state,
  ) async {
    final url = state.checkoutUrl;
    context.read<ParentSubscriptionRenewalCubit>().checkoutOpened();
    final cubit = context.read<ParentSubscriptionRenewalCubit>();
    GulfRenewalTrace.log('navigation executed', details: 'target=tamara');
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
            onOpened: () {
              GulfRenewalTrace.log(
                'reconcile triggered',
                details: 'source=checkout-opened',
              );
              return cubit.reconcilePayment();
            },
          );
    GulfRenewalTrace.log(
      'Tamara returned',
      details: 'opened=${result.opened} outcome=${result.outcome?.name}',
    );
    if (!context.mounted || cubit.isClosed) return;
    if (!result.opened) {
      cubit.checkoutOpenFailed();
      showCustomSnackBar(
        context,
        S.of(context).parentUnableToOpenCheckout,
        false,
      );
      return;
    }
    GulfRenewalTrace.log(
      'reconcile triggered',
      details: 'source=tamara-returned',
    );
    await cubit.reconcilePayment();
  }
}
