import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CreateAssignmentErrorMessage extends StatelessWidget {
  const CreateAssignmentErrorMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorManager.redFFF,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: ColorManager.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: StylesManager.styleRegular14(
                context,
              ).copyWith(color: ColorManager.red),
            ),
          ),
        ],
      ),
    );
  }
}
