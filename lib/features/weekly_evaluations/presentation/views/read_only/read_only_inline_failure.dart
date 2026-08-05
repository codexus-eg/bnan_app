import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class ReadOnlyInlineFailure extends StatelessWidget {
  const ReadOnlyInlineFailure({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(
    key: const Key('readOnlyInlineFailure'),
    width: double.infinity,
    padding: const EdgeInsetsDirectional.all(10),
    decoration: BoxDecoration(
      color: ColorManager.redFFF,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(message, textAlign: TextAlign.start),
  );
}
