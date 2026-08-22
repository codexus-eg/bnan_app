import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationTime extends StatelessWidget {
  const NotificationTime({super.key, required this.value});
  final DateTime? value;
  @override
  Widget build(BuildContext context) => Text(
    _format(context),
    style: StylesManager.styleRegular14(
      context,
    ).copyWith(color: ColorManager.greyA8AF),
  );
  String _format(BuildContext context) {
    final date = value?.toLocal();
    if (date == null) return '';
    final difference = DateTime.now().difference(date);
    if (difference.inMinutes < 1) {
      return S.of(context).notificationNow;
    }
    if (difference.inMinutes < 60) {
      return S.of(context).notificationMinutesAgo(difference.inMinutes);
    }
    if (difference.inHours < 2) {
      return S.of(context).notificationHourAgo;
    }
    if (difference.inHours < 24) {
      return S.of(context).notificationHoursAgo(difference.inHours);
    }
    if (difference.inDays == 1) {
      return S.of(context).yesterday;
    }
    return DateFormat.yMMMd(
      Localizations.localeOf(context).languageCode,
    ).format(date);
  }
}
