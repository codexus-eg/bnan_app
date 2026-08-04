import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/attendance/presentation/manager/attendance_state.dart';
import 'package:bnan_app/features/attendance/presentation/views/widgets/attendance_content.dart';
import 'package:bnan_app/features/attendance/presentation/views/widgets/attendance_filters.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AttendanceBody extends StatelessWidget {
  const AttendanceBody({super.key, required this.state});
  final AttendanceState state;

  @override
  Widget build(BuildContext context) {
    if (!state.allowed) {
      return Center(child: Text(S.of(context).errorForbidden));
    }
    return ColoredBox(
      color: ColorManager.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AttendanceFilters(state: state),
            const SizedBox(height: 18),
            Expanded(child: AttendanceContent(state: state)),
          ],
        ),
      ),
    );
  }
}
