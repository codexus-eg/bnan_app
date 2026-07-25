import 'package:flutter/material.dart';

class PackageFormControllers {
  final name = TextEditingController();
  final duration = TextEditingController();
  final oldPrice = TextEditingController();
  final newPrice = TextEditingController();
  final discountTitle = TextEditingController();
  final description = TextEditingController();

  void dispose() {
    name.dispose();
    duration.dispose();
    oldPrice.dispose();
    newPrice.dispose();
    discountTitle.dispose();
    description.dispose();
  }
}