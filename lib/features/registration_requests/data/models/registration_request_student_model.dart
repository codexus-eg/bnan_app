import 'registration_json_parsing.dart';
import 'registration_lookup_model.dart';
import 'registration_parent_model.dart';
import 'registration_payment_model.dart';

class RegistrationRequestStudentModel {
  const RegistrationRequestStudentModel({
    required this.studentId,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.registrationDate,
    required this.curriculum,
    required this.grade,
    required this.subjects,
    required this.parent,
    required this.accountStatus,
    required this.registrationStatus,
    required this.reviewedBy,
    required this.reviewedAt,
    required this.payment,
  });

  final String studentId;
  final String userId;
  final String fullName;
  final String email;
  final DateTime? registrationDate;
  final RegistrationLookupModel? curriculum;
  final RegistrationLookupModel? grade;
  final List<RegistrationLookupModel> subjects;
  final RegistrationParentModel? parent;
  final String accountStatus;
  final String registrationStatus;
  final String reviewedBy;
  final DateTime? reviewedAt;
  final RegistrationPaymentModel? payment;

  factory RegistrationRequestStudentModel.fromJson(Map<String, dynamic> json) {
    return RegistrationRequestStudentModel(
      studentId: registrationString(json['studentId'] ?? json['id']),
      userId: registrationString(json['userId']),
      fullName: registrationString(json['fullName']),
      email: registrationString(json['email']),
      registrationDate: parseRegistrationDate(json['registrationDate']),
      curriculum: _lookup(json['curriculum']),
      grade: _lookup(json['grade']),
      subjects: registrationMapList(
        json['subjects'],
      ).map(RegistrationLookupModel.fromJson).toList(),
      parent: _parent(json['parent']),
      accountStatus: registrationString(json['accountStatus']),
      registrationStatus: registrationString(json['registrationStatus']),
      reviewedBy: registrationString(json['reviewedBy']),
      reviewedAt: parseRegistrationDate(json['reviewedAt']),
      payment: _payment(json['payment']),
    );
  }

  bool get isApproved => registrationStatus == 'approved';
  bool get isRejected => registrationStatus == 'rejected';
  bool get isPaymentConfirmed => payment?.status == 'confirmed';
}

RegistrationLookupModel? _lookup(Object? value) {
  final map = registrationMap(value);
  return map == null ? null : RegistrationLookupModel.fromJson(map);
}

RegistrationParentModel? _parent(Object? value) {
  final map = registrationMap(value);
  return map == null ? null : RegistrationParentModel.fromJson(map);
}

RegistrationPaymentModel? _payment(Object? value) {
  final map = registrationMap(value);
  return map == null ? null : RegistrationPaymentModel.fromJson(map);
}
