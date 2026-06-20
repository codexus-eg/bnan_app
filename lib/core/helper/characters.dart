import 'package:flutter/material.dart';

String getInitials(String fullName) {
  final names = fullName.trim().split(RegExp(r'\s+'));

  if (names.isEmpty || names.first.isEmpty) return '';

  if (names.length == 1) {
    return names.first.characters.first;
  }

  return names
      .take(2)
      .map((name) => name.characters.first)
      .join();
}