import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PlansClassroomsFeedback extends StatelessWidget {
  const PlansClassroomsFeedback({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: StylesManager.styleRegular14(
                context,
              ).copyWith(color: onRetry == null ? null : ColorManager.redD8),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 100,
              child: CustomAppButton(
                text: S.of(context).retry,
                height: 36,
                onPressed: onRetry,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
