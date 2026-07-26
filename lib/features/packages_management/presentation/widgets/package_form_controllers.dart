import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:flutter/material.dart';

class PackageFormControllers {
  final name = TextEditingController();
  final duration = TextEditingController();
  final oldPrice = TextEditingController();
  final newPrice = TextEditingController();
  final discountTitle = TextEditingController();
  final description = TextEditingController();

  void fillFromPackage(PackageModel package) {
    name.text = package.name ?? '';
    duration.text = package.type == 'monthly'
        ? package.months?.toString() ?? ''
        : package.hours?.toString() ?? '';
    oldPrice.text = package.oldPrice?.toString() ?? '';
    newPrice.text = package.price?.toString() ?? '';
    discountTitle.text = package.discountTitle ?? '';
    description.text = package.description ?? '';
  }

  void dispose() {
    name.dispose();
    duration.dispose();
    oldPrice.dispose();
    newPrice.dispose();
    discountTitle.dispose();
    description.dispose();
  }
}
