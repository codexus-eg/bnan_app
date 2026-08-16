import 'dart:async';

import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/attendance/data/repo/attendance_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentCallAlertAction extends StatefulWidget {
  const StudentCallAlertAction({super.key, required this.studentId});
  final String studentId;

  @override
  State<StudentCallAlertAction> createState() => _StudentCallAlertActionState();
}

class _StudentCallAlertActionState extends State<StudentCallAlertAction> {
  Timer? _timer;
  bool _loading = false, _coolingDown = false;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: S.of(context).callStudentAlert,
    onPressed: _loading || _coolingDown ? null : _call,
    icon: _loading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorManager.white,
            ),
          )
        : const Icon(Icons.call_outlined, color: ColorManager.white),
  );

  Future<void> _call() async {
    setState(() => _loading = true);
    final result = await getIt<AttendanceRepo>().callStudent(widget.studentId);
    if (!mounted) return;
    result.fold(
      (failure) {
        final cooldown =
            failure.statusCode == 429 &&
            failure.code?.toUpperCase() == 'CALL_ALERT_COOLDOWN_ACTIVE';
        if (cooldown) _startCooldown();
        if (!cooldown) setState(() => _loading = false);
        showCustomSnackBar(
          context,
          cooldown ? S.of(context).studentCallAlertCooldown : failure.message,
          false,
        );
      },
      (_) {
        _startCooldown();
        showCustomSnackBar(context, S.of(context).studentCallAlertSent, true);
      },
    );
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() {
      _loading = false;
      _coolingDown = true;
    });
    _timer = Timer(const Duration(seconds: 60), () {
      if (mounted) setState(() => _coolingDown = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
