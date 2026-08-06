import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DocumentsFailureView extends StatelessWidget {
  const DocumentsFailureView({
    super.key,
    required this.message,
    required this.retry,
  });
  final String message;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 240, child: NoDataWidget(title: message)),
        SizedBox(
          width: 180,
          child: CustomAppButton(text: S.of(context).retry, onPressed: retry),
        ),
      ],
    ),
  );
}
