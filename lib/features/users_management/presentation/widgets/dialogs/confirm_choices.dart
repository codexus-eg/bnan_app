import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/choice_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ConfirmChoices extends StatelessWidget {
  const ConfirmChoices({
    super.key,
    required this.onYes,
    required this.onNo,
    required this.isLoading,
  });

  final VoidCallback? onYes;
  final VoidCallback? onNo;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 14),
      child: Row(
        children: [
          Expanded(
            child: ChoiceButton(
              text: s.yes,
              onPressed: onYes,
              isLoading: isLoading,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ChoiceButton(text: s.no, onPressed: onNo),
          ),
        ],
      ),
    );
  }
}
