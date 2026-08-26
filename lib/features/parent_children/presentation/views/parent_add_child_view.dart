import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_state.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_add_child_body.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/presentation/views/payment_checkout_launcher.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_sdk_checkout_view.dart';
import 'package:bnan_app/features/student_auth/data/models/otp_flow_args.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentAddChildView extends StatefulWidget {
  const ParentAddChildView({super.key});

  @override
  State<ParentAddChildView> createState() => _ParentAddChildViewState();
}

class _ParentAddChildViewState extends State<ParentAddChildView>
    with WidgetsBindingObserver {
  bool _tamaraOpen = false;
  bool _externalReturnPending = false;

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
    if (state == AppLifecycleState.resumed &&
        mounted &&
        _externalReturnPending &&
        !_tamaraOpen) {
      _externalReturnPending = false;
      context.read<ParentAddChildCubit>().checkoutClosed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParentAddChildCubit, ParentAddChildState>(
      listenWhen: (before, after) =>
          (!before.shouldOpenCheckout && after.shouldOpenCheckout) ||
          (before.phase != after.phase &&
              (after.phase == ParentAddChildPhase.pendingReview ||
                  after.phase == ParentAddChildPhase.completed)),
      listener: (context, state) {
        if (state.phase == ParentAddChildPhase.pendingReview ||
            state.phase == ParentAddChildPhase.completed) {
          MyNavigator.goToOffAll(
            context,
            Routes.forgetPassword,
            extra: OtpFlowArgs.accountVerification(state.email),
          );
          return;
        }
        _openCheckout(context, state);
      },
      child: Scaffold(
        appBar: CustomAppbar(headerText: S.of(context).parentAddChildTitle),
        body: const ParentAddChildBody(),
      ),
    );
  }

  Future<void> _openCheckout(
    BuildContext context,
    ParentAddChildState state,
  ) async {
    final url = state.checkoutUrl;
    context.read<ParentAddChildCubit>().checkoutOpened();
    if (url == null) {
      context.read<ParentAddChildCubit>().checkoutOpenFailed();
      showCustomSnackBar(
        context,
        S.of(context).parentUnableToOpenCheckout,
        false,
      );
      return;
    }
    final cubit = context.read<ParentAddChildCubit>();
    _tamaraOpen = true;
    late final PaymentCheckoutLaunchResult result;
    try {
      result = await PaymentCheckoutLauncher.open(
        context: context,
        provider: state.selectedProvider,
        checkoutUrl: url,
        completionStream: cubit.stream.map(
          (value) => value.phase == ParentAddChildPhase.completed,
        ),
        isCompleted: () => cubit.state.phase == ParentAddChildPhase.completed,
      );
    } finally {
      _tamaraOpen = false;
    }
    if (!context.mounted) return;
    if (!result.opened) {
      context.read<ParentAddChildCubit>().checkoutOpenFailed();
      showCustomSnackBar(
        context,
        S.of(context).parentUnableToOpenCheckout,
        false,
      );
      return;
    }
    if (state.selectedProvider == GulfPaymentProvider.paymob) {
      await cubit.checkoutClosed();
      return;
    }
    if (result.tamaraOutcome == null) {
      _externalReturnPending = true;
      return;
    }
    if (result.tamaraOutcome == TamaraSdkOutcome.cancel ||
        result.tamaraOutcome == TamaraSdkOutcome.failure) {
      await cubit.checkoutClosed();
      if (!context.mounted) return;
      showCustomSnackBar(context, S.of(context).parentPaymentFailed, false);
      return;
    }
    await context.read<ParentAddChildCubit>().verifyPaymentSuccess();
  }
}
