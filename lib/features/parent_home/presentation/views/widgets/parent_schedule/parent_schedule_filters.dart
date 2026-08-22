import 'package:flutter/material.dart';

class ParentScheduleFilters extends StatelessWidget {
  const ParentScheduleFilters({super.key, required this.childSelector});

  final Widget childSelector;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
    child: childSelector,
  );
}
