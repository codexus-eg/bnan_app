import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentSubjectsFailure extends StatelessWidget {
  const StudentSubjectsFailure({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NoDataWidget(title: message),
        const SizedBox(height: 16),
        SizedBox(
          width: 150,
          child: CustomAppButton(
            text: S.of(context).retry,
            onPressed: onRetry,
          ),
        ),
      ],
    );
  }
}
