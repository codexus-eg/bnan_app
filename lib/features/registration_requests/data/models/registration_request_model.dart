import 'registration_json_parsing.dart';

part 'registration_requests_mock_data.dart';

class RegistrationRequestModel {
  const RegistrationRequestModel({
    required this.studentId,
    required this.studentName,
    required this.parentName,
    required this.parentPhone,
    required this.curriculum,
    required this.grade,
    required this.subjects,
    required DateTime? registrationDate,
    required this.registrationStatus,
    required this.paymentStatus,
    this.paymentAmount,
  }) : registrationDateValue = registrationDate;

  final String studentId;
  final String studentName;
  final String parentName;
  final String parentPhone;
  final String curriculum;
  final String grade;
  final List<String> subjects;
  final DateTime? registrationDateValue;
  final String registrationStatus;
  final String paymentStatus;
  final num? paymentAmount;

  factory RegistrationRequestModel.fromJson(Map<String, dynamic> json) {
    final payment = registrationMap(json['payment']);

    return RegistrationRequestModel(
      studentId: registrationString(json['studentId']),
      studentName: registrationString(json['studentName']),
      parentName: registrationString(json['parentName']),
      parentPhone: registrationString(json['parentPhone']),
      curriculum: registrationString(json['curriculum']),
      grade: registrationString(json['grade']),
      subjects: registrationStringList(json['subjects']),
      registrationDate: parseRegistrationDate(json['registrationDate']),
      registrationStatus: registrationString(json['registrationStatus']),
      paymentStatus: registrationString(json['paymentStatus']),
      paymentAmount: registrationNum(
        json['amount'] ?? json['paymentAmount'] ?? payment?['amount'],
      ),
    );
  }

  String get name => studentName;
  String get phone => parentPhone;
  String get customerType => registrationStatus;
  int get childrenCount => 1;
  List<String> get className => grade.isEmpty ? const [] : [grade];
  List<String> get subject => subjects;
  String get registrationDate =>
      registrationDateValue?.toIso8601String().split('T').first ?? '';
  num? get amount => paymentAmount;
  String get paymentActionText => paymentStatus;
  bool get isPaymentConfirmed => paymentStatus == 'confirmed';
  bool get isPendingRegistration => registrationStatus == 'pending';
  String get subjectsText => subjects.join('، ');
}
