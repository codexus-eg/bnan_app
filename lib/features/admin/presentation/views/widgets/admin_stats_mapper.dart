import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<HomeStateModel> adminDashboardStats(
  BuildContext context,
  AdminDashboardStatisticsModel data,
  VoidCallback onRequests,
  VoidCallback onReceipts,
) {
  final s = S.of(context);
  HomeStateModel stat(
    String icon,
    Object value,
    String title,
    Color color, [
    VoidCallback? onTap,
  ]) {
    return HomeStateModel(
      icon: icon,
      value: '$value',
      title: title,
      iconColor: color,
      onTap: onTap,
    );
  }

  String formatRevenue(double amount) {
    if (!amount.isFinite) return '0';
    if (amount == amount.roundToDouble()) return amount.toInt().toString();
    final fixed = amount.toStringAsFixed(2);
    return fixed.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  return [
    stat(
      ImageManager.userProfileGroupIcon,
      data.totalStudents,
      s.totalStudents,
      ColorManager.mainColor14,
    ),
    stat(
      ImageManager.teacherBookTwoIcon,
      data.pendingStudentRegistrations,
      s.pendingRegisterRequests,
      ColorManager.secondaryColor,
      onRequests,
    ),
    stat(
      ImageManager.adminWindowBulletListAddIcon,
      data.totalTeachers,
      s.teachers,
      ColorManager.secondaryColor,
    ),
    stat(
      ImageManager.teacherUserProfileGroupIcon,
      data.activeSubscriptions,
      s.activeSubscriptions,
      ColorManager.orangeE4,
    ),
    stat(
      ImageManager.calendarIcon,
      data.todaySessions,
      s.todayClasses,
      ColorManager.redD8,
    ),
    stat(
      ImageManager.adminDollarSignIcon,
      data.expiredSubscriptions,
      s.expiredSubscriptions,
      ColorManager.redD5,
    ),
    stat(
      ImageManager.adminDollarSignIcon,
      data.pendingReceipts,
      s.pendingReceipts,
      ColorManager.secondaryColor,
      onReceipts,
    ),
    stat(
      ImageManager.wallet,
      formatRevenue(data.totalPaidEgp),
      s.revenueEgp,
      ColorManager.green33B,
    ),
    stat(
      ImageManager.wallet,
      formatRevenue(data.totalPaidSar),
      s.revenueSar,
      ColorManager.green33B,
    ),
  ];
}
