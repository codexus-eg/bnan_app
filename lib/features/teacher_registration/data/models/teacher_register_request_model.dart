import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class TeacherRegisterRequestModel {
  const TeacherRegisterRequestModel({
    required this.fields,
    required this.curriculum,
    required this.additionalCurriculums,
    required this.cv,
    required this.certificate,
    required this.identityDocument,
    required this.stableInternetProof,
    this.experienceCertificates = const [],
  });

  final Map<String, dynamic> fields;
  final String curriculum;
  final List<String> additionalCurriculums;
  final File cv, certificate, identityDocument, stableInternetProof;
  final List<File> experienceCertificates;

  String get introVideoUrl => fields['introVideoUrl'] as String? ?? '';

  Future<FormData> toFormData() async {
    final data = FormData.fromMap({
      ...fields,
      'curriculum': curriculum,
      'additionalCurriculums': jsonEncode(additionalCurriculums),
      'cv': await MultipartFile.fromFile(cv.path),
      'certificate': await MultipartFile.fromFile(certificate.path),
      'identityDocument': await MultipartFile.fromFile(identityDocument.path),
      'stableInternetProof': await MultipartFile.fromFile(
        stableInternetProof.path,
      ),
    });
    for (final file in experienceCertificates) {
      data.files.add(
        MapEntry(
          'experienceCertificates',
          await MultipartFile.fromFile(file.path),
        ),
      );
    }
    return data;
  }
}
