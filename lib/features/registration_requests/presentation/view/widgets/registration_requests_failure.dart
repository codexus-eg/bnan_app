import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class RegistrationRequestsFailure extends StatelessWidget {
  const RegistrationRequestsFailure({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: StylesManager.styleRegular14(
                context,
              ).copyWith(color: ColorManager.red),
            ),
            const SizedBox(height: 8),
            IconButton(
              onPressed: onRetry,
              color: ColorManager.mainColor14,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
