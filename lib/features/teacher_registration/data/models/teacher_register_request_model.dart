import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class TeacherRegisterRequestModel {
  const TeacherRegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.nationality,
    required this.country,
    required this.city,
    required this.degree,
    required this.specialization,
    required this.institutionName,
    required this.graduationYear,
    required this.graduationGrade,
    required this.phone,
    required this.whatsapp,
    required this.hasTeachingExperience,
    required this.hasOnlineTeachingExperience,
    required this.availableHoursPerWeek,
    required this.computerSkillLevel,
    required this.hasLaptop,
    required this.hasStableInternet,
    required this.hasMicrophone,
    required this.hasGoodCamera,
    required this.introVideoUrl,
    required this.canProvideDemoSession,
    required this.joiningReason,
    required this.weakStudentHandling,
    required this.termsAccepted,
    required this.curriculum,
    required this.teacherAssignments,
    required this.cv,
    required this.certificate,
    required this.identityDocument,
  });

  final String fullName;
  final String email;
  final String password;
  final String nationality;
  final String country;
  final String city;
  final String degree;
  final String specialization;
  final String institutionName;
  final int graduationYear;
  final String graduationGrade;
  final String phone;
  final String whatsapp;

  final bool hasTeachingExperience;
  final bool hasOnlineTeachingExperience;
  final int availableHoursPerWeek;

  final String computerSkillLevel;
  final bool hasLaptop;
  final bool hasStableInternet;
  final bool hasMicrophone;
  final bool hasGoodCamera;

  final String introVideoUrl;
  final bool canProvideDemoSession;
  final String joiningReason;
  final String weakStudentHandling;
  final bool termsAccepted;

  final String curriculum;
  final List<Map<String, dynamic>> teacherAssignments;

  final File cv;
  final File certificate;
  final File identityDocument;

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'fullName': fullName,
      'email': email,
      'password': password,
      'nationality': nationality,
      'country': country,
      'city': city,
      'degree': degree,
      'specialization': specialization,
      'institutionName': institutionName,
      'graduationYear': graduationYear,
      'graduationGrade': graduationGrade,
      'phone': phone,
      'whatsapp': whatsapp,
      'hasTeachingExperience': hasTeachingExperience.toString(),
      'hasOnlineTeachingExperience': hasOnlineTeachingExperience.toString(),
      'availableHoursPerWeek': 7,
      'computerSkillLevel': computerSkillLevel,
      'hasLaptop': hasLaptop.toString(),
      'hasStableInternet': hasStableInternet.toString(),
      'hasMicrophone': hasMicrophone.toString(),
      'hasGoodCamera': hasGoodCamera.toString(),
      'introVideoUrl': introVideoUrl,
      'canProvideDemoSession': canProvideDemoSession.toString(),
      'joiningReason': joiningReason,
      'weakStudentHandling': weakStudentHandling,
      'termsAccepted': termsAccepted.toString(),
      'curriculums': [curriculum],
      'teacherAssignments': jsonEncode(teacherAssignments),
      'cv': await MultipartFile.fromFile(cv.path),
      'certificate': await MultipartFile.fromFile(certificate.path),
      'identityDocument': await MultipartFile.fromFile(identityDocument.path),
    });
  }
}