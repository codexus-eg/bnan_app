import 'package:flutter/widgets.dart';

abstract final class SubscriptionHoursFormatter {
  static String formatHours(
    num hoursValue, {
    required BuildContext context,
    bool isRemaining = false,
  }) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return formatHoursWithLocale(
      hoursValue,
      isArabic: isArabic,
      isRemaining: isRemaining,
    );
  }

  static String formatHoursWithLocale(
    num hoursValue, {
    required bool isArabic,
    bool isRemaining = false,
  }) {
    final value = hoursValue.toDouble();
    if (value <= 0) {
      if (isRemaining) return isArabic ? '0 ساعة' : '0 hr';
      return isArabic ? '0 دقيقة' : '0 min';
    }

    final totalMinutes = (value * 60).round();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return isArabic
          ? '$hours ساعة و$minutes دقيقة'
          : '$hours hr $minutes min';
    } else if (hours > 0) {
      return isArabic ? '$hours ساعة' : '$hours hr';
    } else {
      return isArabic ? '$minutes دقيقة' : '$minutes min';
    }
  }

  static String formatTotalHours(
    num hoursValue, {
    required BuildContext context,
  }) {
    if (hoursValue % 1 == 0) return hoursValue.toInt().toString();
    return formatHours(hoursValue, context: context);
  }
}
