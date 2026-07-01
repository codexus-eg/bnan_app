import 'package:flutter/material.dart';

class AdminDepartmentProgressModel {
  const AdminDepartmentProgressModel({
    required this.title,
    required this.current,
    required this.total,
    required this.progress,
    required this.color,
  });

  final String title;
  final int current;
  final int total;
  final double progress;
  final Color color;
}
