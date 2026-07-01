import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/admin/data/models/admin_quick_action_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<AdminQuickActionModel> adminQuickActions(BuildContext context) {
  final s = S.of(context);
  return [
    AdminQuickActionModel(
      title: s.pendingPayments,
      subtitle: s.reviewPaidRequests,
      icon: ImageManager.cardLogoPayment,
    ),
    AdminQuickActionModel(
      title: s.registrationRequests,
      subtitle: s.reviewNewStudents,
      icon: ImageManager.bookIcon,
    ),
    AdminQuickActionModel(
      title: s.classesManagement,
      subtitle: s.manageStudentsAndClasses,
      icon: ImageManager.teacherBookTwoIcon,
    ),
  ];
}
