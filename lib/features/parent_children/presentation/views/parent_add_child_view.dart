import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_state.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_add_child_body.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_checkout_launcher.dart';
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
      context.read<ParentAddChildCubit>().reconcilePayment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParentAddChildCubit, ParentAddChildState>(
      listenWhen: (before, after) =>
          !before.shouldOpenCheckout && after.shouldOpenCheckout,
      listener: _openCheckout,
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
    final result = await TamaraCheckoutLauncher.open(
      context,
      url,
      completionStream: cubit.stream.map(
        (value) => value.phase == ParentAddChildPhase.completed,
      ),
      isCompleted: () => cubit.state.phase == ParentAddChildPhase.completed,
    );
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
    await context.read<ParentAddChildCubit>().reconcilePayment();
  }
}
