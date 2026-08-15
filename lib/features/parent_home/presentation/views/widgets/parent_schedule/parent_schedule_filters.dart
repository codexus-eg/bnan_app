import 'package:flutter/material.dart';

class ParentScheduleFilters extends StatelessWidget {
  const ParentScheduleFilters({
    super.key,
    required this.childSelector,
    required this.weekSelector,
  });

  final Widget childSelector, weekSelector;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: childSelector),
        const SizedBox(width: 12),
        Expanded(child: weekSelector),
      ],
    ),
  );
}
