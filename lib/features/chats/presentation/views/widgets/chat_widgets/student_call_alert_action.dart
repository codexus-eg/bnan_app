import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/attendance/data/repo/attendance_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentCallAlertAction extends StatefulWidget {
  const StudentCallAlertAction({
    super.key,
    required this.studentId,
    this.color = ColorManager.white,
  });
  final String studentId;
  final Color color;

  @override
  State<StudentCallAlertAction> createState() => _StudentCallAlertActionState();
}

class _StudentCallAlertActionState extends State<StudentCallAlertAction> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: S.of(context).callStudentAlert,
    onPressed: _loading ? null : _call,
    icon: _loading
        ? SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: widget.color,
            ),
          )
        : Icon(Icons.call_outlined, color: widget.color),
  );

  Future<void> _call() async {
    debugPrint('[ChatRing] phone icon tapped');
    setState(() => _loading = true);
    final result = await getIt<AttendanceRepo>().callStudent(widget.studentId);
    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() => _loading = false);
        showCustomSnackBar(context, failure.message, false);
      },
      (_) {
        debugPrint('[ChatRing] ring request sent');
        setState(() => _loading = false);
        showCustomSnackBar(context, S.of(context).studentCallAlertSent, true);
      },
    );
  }
}
