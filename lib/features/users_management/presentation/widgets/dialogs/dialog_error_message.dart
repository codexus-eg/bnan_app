import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class DialogErrorMessage extends StatelessWidget {
  const DialogErrorMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          message,
          style: StylesManager.styleRegular12(
            context,
          ).copyWith(color: Colors.red),
        ),
      ),
    );
  }
}
