import 'package:flutter/material.dart';

class HomeStateModel {
  const HomeStateModel({
    required this.icon,
    required this.value,
    required this.title,
    this.iconColor,
    this.onTap,
  });

  final String icon;
  final String value;
  final String title;
  final Color? iconColor;
  final VoidCallback? onTap;
}
