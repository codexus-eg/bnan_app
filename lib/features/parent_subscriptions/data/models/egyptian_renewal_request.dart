import 'dart:io';
import 'package:dio/dio.dart';

class EgyptianRenewalRequest {
  const EgyptianRenewalRequest({
    required this.studentId,
    required this.packageId,
    required this.receiptImage,
    this.subjectId,
    this.discountCode,
    this.method,
    this.referenceNumber,
  });
  final String studentId, packageId;
  final String? subjectId, discountCode, method, referenceNumber;
  final File receiptImage;

  Future<FormData> toFormData() async => FormData.fromMap({
    'studentId': studentId,
    'packageId': packageId,
    if (_has(subjectId)) 'subjectId': subjectId!.trim(),
    if (_has(discountCode)) 'discountCode': discountCode!.trim(),
    if (_has(method)) 'method': method!.trim(),
    if (_has(referenceNumber)) 'referenceNumber': referenceNumber!.trim(),
    'receiptImage': await MultipartFile.fromFile(receiptImage.path),
  });

  static bool _has(String? value) => value?.trim().isNotEmpty == true;
}
