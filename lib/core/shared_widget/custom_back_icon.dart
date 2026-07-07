import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBackIcon extends StatelessWidget {
  const CustomBackIcon({
    super.key,
    this.onTap,
    this.size,
    this.color,
  });

  final VoidCallback? onTap;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return InkWell(
      onTap: onTap ?? () => MyNavigator.pop(context),
      borderRadius: BorderRadius.circular(24),
      child: Icon(
        _getBackIcon(isRtl: isRtl, isIOS: isIOS),
        size: size,
        color: color,
      ),
    );
  }

  IconData _getBackIcon({
    required bool isRtl,
    required bool isIOS,
  }) {
    if (isIOS) {
      return isRtl
          ? CupertinoIcons.chevron_back
          : CupertinoIcons.chevron_back;
    }

    return isRtl ? Icons.arrow_back : Icons.arrow_back;
  }
}