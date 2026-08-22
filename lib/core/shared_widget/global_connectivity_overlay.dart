import 'package:bnan_app/core/connectivity/connectivity_cubit.dart';
import 'package:bnan_app/core/connectivity/connectivity_state.dart';
import 'package:bnan_app/core/shared_widget/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalConnectivityOverlay extends StatelessWidget {
  const GlobalConnectivityOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            child,
            if (state is ConnectivityDisconnected)
              NoInternetWidget(
                isChecking: false,
                onRetry: context.read<ConnectivityCubit>().checkConnection,
              ),
          ],
        );
      },
    );
  }
}
