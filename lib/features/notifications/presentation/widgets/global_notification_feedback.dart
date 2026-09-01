import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_empty_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class GlobalNotificationFeedback extends StatelessWidget {
  const GlobalNotificationFeedback({super.key, required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomEmptyState(
          title: S.of(context).globalNotificationUnavailable,
          subtitle: S.of(context).globalNotificationTryAgain,
          icon: Icons.notifications_off_outlined,
        ),
        const SizedBox(height: 24),
        CustomAppButton(text: S.of(context).retry, onPressed: onRetry),
      ],
    ),
  );
}
