import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class RegistrationRequestsListFooter extends StatelessWidget {
  const RegistrationRequestsListFooter({
    super.key,
    required this.isLoading,
    this.errorMessage,
    this.onRetry,
  });

  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      children: [
        Text(
          errorMessage ?? '',
          textAlign: TextAlign.center,
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: ColorManager.red),
        ),
        IconButton(
          onPressed: onRetry,
          color: ColorManager.mainColor14,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
