import 'package:bnan_app/core/shared_widget/custom_chip.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class IdealTeacherMeta extends StatelessWidget {
  const IdealTeacherMeta({
    super.key,
    required this.label,
    required this.values,
  });
  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: StylesManager.styleRegular12(context)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: values.map((value) => Customship(value)).toList(),
          ),
        ],
      ),
    );
  }
}
