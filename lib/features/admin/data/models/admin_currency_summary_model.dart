import 'package:flutter/material.dart';

class AdminCurrencySummaryModel {
  const AdminCurrencySummaryModel({required this.title, required this.rows});

  final String title;
  final List<AdminCurrencySummaryRow> rows;
}

class AdminCurrencySummaryRow {
  const AdminCurrencySummaryRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;
}
