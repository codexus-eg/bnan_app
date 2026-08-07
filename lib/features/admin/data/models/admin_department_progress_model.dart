import 'package:flutter/material.dart';

class AdminDepartmentProgressModel {
  const AdminDepartmentProgressModel({
    required this.title,
    required this.current,
    required this.total,
    required this.percentage,
    required this.color,
  });

  final String title;
  final int current;
  final int total;
  final double percentage;
  final Color color;

  double get progress => (percentage / 100).clamp(0.0, 1.0);

  String get percentageLabel {
    return percentage.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
