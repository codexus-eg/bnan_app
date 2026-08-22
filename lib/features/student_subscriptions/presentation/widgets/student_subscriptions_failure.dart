import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentSubscriptionsFailureView extends StatelessWidget {
  const StudentSubscriptionsFailureView({
    super.key,
    required this.message,
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          CustomAppButton(text: S.of(context).retry, onPressed: onRetry),
        ],
      ),
    ),
  );
}
