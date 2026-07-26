import 'dart:io';

import 'package:dio/dio.dart';

class CreateCurriculumRequestModel {
  const CreateCurriculumRequestModel({
    required this.name,
    required this.description,
    required this.registrationMode,
    required this.icon,
  });

  final String name;
  final String description;
  final String registrationMode;
  final File icon;

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'name': name.trim(),
      'description': description.trim(),
      'registrationMode': registrationMode.trim(),
      'icon': await MultipartFile.fromFile(icon.path),
    });
  }
}
