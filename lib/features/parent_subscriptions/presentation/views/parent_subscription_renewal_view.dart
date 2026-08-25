import 'dart:async';

import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_flow_result.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_state.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/parent_subscription_renewal_body.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_state.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_checkout_launcher.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_sdk_checkout_view.dart';
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
  bool _tamaraOpen = false;
  bool _tamaraReturned = false;
  bool _successNavigationExecuted = false;
  bool _isLeaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _markLeaving();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isLeaving &&
        state == AppLifecycleState.resumed &&
        mounted &&
        _tamaraReturned &&
        !_tamaraOpen) {
      _tamaraReturned = false;
      unawaited(
        context.read<ParentSubscriptionRenewalCubit>().checkoutClosed(),
      );
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
              listenWhen: _shouldListen,
              listener: _onState,
              child: PopScope(
                onPopInvokedWithResult: (didPop, _) {
                  if (didPop) _markLeaving();
                },
                child: Scaffold(
                  appBar: CustomAppbar(
                    headerText: S.of(context).renewSubscription,
                    onBackTap: _leave,
                  ),
                  body: const ParentSubscriptionRenewalBody(),
                ),
              ),
            ),
      );

  bool _shouldListen(
    ParentSubscriptionRenewalState before,
    ParentSubscriptionRenewalState after,
  ) {
    if (after.isGulf) {
      return !before.shouldOpenCheckout && after.shouldOpenCheckout ||
          before.phase != ParentRenewalPhase.completed &&
              after.phase == ParentRenewalPhase.completed;
    }
    return before.phase == ParentRenewalPhase.submitting &&
        (after.phase == ParentRenewalPhase.pending ||
            after.phase == ParentRenewalPhase.editing &&
                after.errorMessage != null);
  }

  Future<void> _onState(
    BuildContext context,
    ParentSubscriptionRenewalState state,
  ) async {
    if (_isLeaving) return;
    if (state.isGulf) {
      if (state.phase == ParentRenewalPhase.completed) {
        return _finishGulf(context);
      }
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
    if (_isLeaving) return;
    final url = state.checkoutUrl;
    context.read<ParentSubscriptionRenewalCubit>().checkoutOpened();
    final cubit = context.read<ParentSubscriptionRenewalCubit>();
    _tamaraReturned = false;
    _tamaraOpen = true;
    late final TamaraCheckoutLaunchResult result;
    try {
      result = url == null
          ? const TamaraCheckoutLaunchResult(opened: false)
          : await TamaraCheckoutLauncher.open(context, url);
    } finally {
      _tamaraOpen = false;
    }
    if (_isLeaving || !context.mounted || cubit.isClosed) return;
    if (!result.opened) {
      _tamaraReturned = false;
      cubit.checkoutOpenFailed();
      showCustomSnackBar(
        context,
        S.of(context).parentUnableToOpenCheckout,
        false,
      );
      return;
    }
    if (result.outcome == null) {
      _tamaraReturned = true;
      return;
    }
    _tamaraReturned = false;
    if (result.outcome == TamaraSdkOutcome.success) {
      await cubit.reconcilePayment();
      return;
    }
    await cubit.checkoutClosed();
  }

  void _finishGulf(BuildContext context) {
    if (_isLeaving || _successNavigationExecuted || !context.mounted) return;
    _successNavigationExecuted = true;
    MyNavigator.pop(context, ParentFlowResult.completed);
  }

  void _leave() {
    if (_isLeaving || !mounted) return;
    _markLeaving();
    MyNavigator.pop(context);
  }

  void _markLeaving() {
    _isLeaving = true;
    _tamaraReturned = false;
  }
}
