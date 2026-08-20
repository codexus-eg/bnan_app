import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';

abstract final class PackageDisplayFormatter {
  static String name(BuildContext context, String value) {
    final s = S.of(context);
    return switch (value.trim().toLowerCase()) {
      'monthly package' => s.monthlyPackage,
      'hours package' => s.packageHoursType,
      'all subjects' => s.allSubjects,
      'single subject' => s.singleSubject,
      _ => value,
    };
  }
}
