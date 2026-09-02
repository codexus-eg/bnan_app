import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';

abstract class TeacherDegreeLabels {
  static Map<String, String> of(BuildContext context) {
    final s = S.of(context);
    return {
      'bachelor-student': s.bachelorStudent,
      'bachelor': s.bachelor,
      'master-student': s.masterStudent,
      'master': s.master,
      'phd-student': s.phdStudent,
      'phd': s.phd,
    };
  }

  static String label(BuildContext context, String value) {
    return of(context)[value] ?? value;
  }
}
