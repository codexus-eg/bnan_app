import 'dart:convert';
import 'dart:io';

import 'package:bnan_app/features/parent_children/data/models/parent_child_student_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ParentAddChildEgyptianRequest {
  const ParentAddChildEgyptianRequest({
    required this.student,
    required this.curriculumId,
    required this.packageId,
    required this.receiptImage,
    this.discountCode,
    this.method,
    this.referenceNumber,
  });

  final ParentChildStudentRequest student;
  final String curriculumId;
  final String packageId;
  final File receiptImage;
  final String? discountCode;
  final String? method;
  final String? referenceNumber;

  Future<FormData> toFormData() async {
    _log(
      'multipart creation started; receiptExists=${receiptImage.existsSync()}',
    );
    final receipt = await MultipartFile.fromFile(receiptImage.path);
    _log('receipt MultipartFile ready');
    final formData = FormData.fromMap({
      'student': jsonEncode(student.toJson()),
      'curriculum': curriculumId,
      'packageId': packageId,
      if (_has(discountCode)) 'discountCode': discountCode!.trim(),
      if (_has(method)) 'method': method!.trim(),
      if (_has(referenceNumber)) 'referenceNumber': referenceNumber!.trim(),
      'receiptImage': receipt,
    });
    _log('FormData ready');
    return formData;
  }

  static bool _has(String? value) => value?.trim().isNotEmpty == true;

  static void _log(String message) {
    if (kDebugMode) debugPrint('[ParentAddChildEgyptianRequest] $message');
  }
}
