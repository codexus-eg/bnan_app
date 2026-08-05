import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ReadOnlyEvaluationMeta extends StatelessWidget {
  const ReadOnlyEvaluationMeta({
    super.key,
    required this.label,
    required this.value,
  });
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: StylesManager.styleBold12(context)),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: StylesManager.styleRegular12(
                context,
              ).copyWith(color: ColorManager.mainColor15),
            ),
          ),
        ],
      ),
    );
  }
}
