import 'package:bnan_app/features/plans/presentation/views/widgets/term_plans/term_plans_classroom_filter.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/term_plans/term_plans_content.dart';
import 'package:flutter/material.dart';

class TermPlansBody extends StatelessWidget {
  const TermPlansBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
            child: TermPlansClassroomFilter(),
          ),
          SizedBox(height: 16),
          Expanded(child: TermPlansContent()),
        ],
      ),
    );
  }
}
