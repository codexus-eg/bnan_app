import 'dart:io';

import 'package:dio/dio.dart';

class UpdateCurriculumRequestModel {
  const UpdateCurriculumRequestModel({
    required this.name,
    required this.description,
    required this.registrationMode,
    this.icon,
  });

  final String name;
  final String description;
  final String registrationMode;
  final File? icon;

  Future<FormData> toFormData() async => FormData.fromMap({
    'name': name.trim(),
    'description': description.trim(),
    'registrationMode': registrationMode.trim(),
    if (icon != null) 'icon': await MultipartFile.fromFile(icon!.path),
  });
}
