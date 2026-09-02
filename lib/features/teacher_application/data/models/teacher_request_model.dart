import 'package:bnan_app/features/teacher_application/data/models/teacher_curriculum_model.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_user_model.dart';

class TeacherRequestResponseModel {
  final bool success;
  final int? length;
  final List<TeacherRequestModel> data;

  TeacherRequestResponseModel({
    required this.success,
    this.length,
    required this.data,
  });

  factory TeacherRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherRequestResponseModel(
      success: json['success'] ?? false,
      length: json['length'],
      data: (json['data'] as List? ?? [])
          .map((e) => TeacherRequestModel.fromJson(e))
          .toList(),
    );
  }
}

class TeacherDetailsResponseModel {
  final bool success;
  final TeacherRequestModel data;

  TeacherDetailsResponseModel({required this.success, required this.data});

  factory TeacherDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherDetailsResponseModel(
      success: json['success'] ?? false,
      data: TeacherRequestModel.fromJson(json['data']),
    );
  }
}

class TeacherRequestModel {
  final String id;
  final TeacherUserModel user;
  final String phone;
  final String whatsapp;
  final String nationality;
  final String country;
  final String city;
  final String degree;
  final String dateOfBirth;
  final String specialization;
  final int graduationYear;
  final String graduationGrade;
  final bool hasTeachingExperience;
  final bool hasOnlineTeachingExperience;
  final List<TeacherCurriculumModel> curriculums;
  final List<TeacherCurriculumModel> additionalCurriculums;
  final int availableHoursPerWeek;
  final String computerSkillLevel;
  final bool hasLaptop;
  final bool hasStableInternet;
  final bool hasGoodCamera;
  final bool hasMicrophone;
  final bool canProvideDemoSession;
  final String introVideoUrl;
  final String joiningReason;
  final String weakStudentHandling;
  final String cv;
  final String certificate;
  final String identityDocument;
  final String stableInternetProof;
  final List<String> experienceCertificates;
  final bool termsAccepted;
  final String termsAcceptedAt;
  final int termsVersion;
  final int pricePerSession;
  final int excellencePoints;
  final int totalSessions;
  final bool isAvailable;
  final String status;
  final String createdAt;
  final String updatedAt;

  TeacherRequestModel({
    required this.id,
    required this.user,
    required this.phone,
    required this.whatsapp,
    required this.nationality,
    required this.country,
    required this.city,
    required this.degree,
    required this.dateOfBirth,
    required this.specialization,
    required this.graduationYear,
    required this.graduationGrade,
    required this.hasTeachingExperience,
    required this.hasOnlineTeachingExperience,
    required this.curriculums,
    required this.additionalCurriculums,
    required this.availableHoursPerWeek,
    required this.computerSkillLevel,
    required this.hasLaptop,
    required this.hasStableInternet,
    required this.hasGoodCamera,
    required this.hasMicrophone,
    required this.canProvideDemoSession,
    required this.introVideoUrl,
    required this.joiningReason,
    required this.weakStudentHandling,
    required this.cv,
    required this.certificate,
    required this.identityDocument,
    required this.stableInternetProof,
    required this.experienceCertificates,
    required this.termsAccepted,
    required this.termsAcceptedAt,
    required this.termsVersion,
    required this.pricePerSession,
    required this.excellencePoints,
    required this.totalSessions,
    required this.isAvailable,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherRequestModel.fromJson(Map<String, dynamic> json) {
    return TeacherRequestModel(
      id: json['_id'] ?? '',
      user: TeacherUserModel.fromJson(json['user'] ?? {}),
      phone: json['phone'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      nationality: json['nationality'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      degree: json['degree'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      specialization: json['specialization'] ?? '',
      graduationYear: json['graduationYear'] ?? 0,
      graduationGrade: json['graduationGrade'] ?? '',
      hasTeachingExperience: json['hasTeachingExperience'] ?? false,
      hasOnlineTeachingExperience: json['hasOnlineTeachingExperience'] ?? false,
      curriculums: (json['curriculums'] as List? ?? [])
          .map((e) => TeacherCurriculumModel.fromJson(e))
          .toList(),
      additionalCurriculums: (json['additionalCurriculums'] as List? ?? [])
          .map((e) => TeacherCurriculumModel.fromJson(e))
          .toList(),
      availableHoursPerWeek: json['availableHoursPerWeek'] ?? 0,
      computerSkillLevel: json['computerSkillLevel'] ?? '',
      hasLaptop: json['hasLaptop'] ?? false,
      hasStableInternet: json['hasStableInternet'] ?? false,
      hasGoodCamera: json['hasGoodCamera'] ?? false,
      hasMicrophone: json['hasMicrophone'] ?? false,
      canProvideDemoSession: json['canProvideDemoSession'] ?? false,
      introVideoUrl: json['introVideoUrl'] ?? '',
      joiningReason: json['joiningReason'] ?? '',
      weakStudentHandling: json['weakStudentHandling'] ?? '',
      cv: json['cv'] ?? '',
      certificate: json['certificate'] ?? '',
      identityDocument: json['identityDocument'] ?? '',
      stableInternetProof: json['stableInternetProof'] ?? '',
      experienceCertificates: (json['experienceCertificates'] as List? ?? [])
          .map((item) => item.toString())
          .toList(),
      termsAccepted: json['termsAccepted'] ?? false,
      termsAcceptedAt: json['termsAcceptedAt'] ?? '',
      termsVersion: json['termsVersion'] ?? 0,
      pricePerSession: json['pricePerSession'] ?? 0,
      excellencePoints: json['excellencePoints'] ?? 0,
      totalSessions: json['totalSessions'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
