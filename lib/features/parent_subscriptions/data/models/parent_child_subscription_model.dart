import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_type.dart';

class ParentSubscriptionSubjectModel {
  const ParentSubscriptionSubjectModel({required this.id, required this.name});
  final String id;
  final String name;

  factory ParentSubscriptionSubjectModel.fromJson(Map<String, dynamic> json) =>
      ParentSubscriptionSubjectModel(id: _id(json), name: _text(json['name']));
}

class ParentChildSubscriptionModel {
  const ParentChildSubscriptionModel({
    required this.id,
    required this.packageId,
    required this.packageName,
    required this.curriculumId,
    this.accessScope = PackageAccessScope.allSubjects,
    this.packageType = '',
    this.subject,
    this.purchasedHours = 0,
    this.remainingHours = 0,
    this.usedHoursValue,
    this.status = '',
    this.startDate,
    this.endDate,
    this.price,
    this.currency,
    this.renewalAllowed,
  });

  final String id, packageId, packageName, curriculumId;
  final String accessScope, packageType, status;
  final ParentSubscriptionSubjectModel? subject;
  final num purchasedHours, remainingHours;
  final num? usedHoursValue, price;
  final String? currency;
  final DateTime? startDate, endDate;
  final bool? renewalAllowed;

  num get usedHours =>
      usedHoursValue ??
      (purchasedHours - remainingHours).clamp(0, double.infinity);
  bool get isSingleSubject => accessScope == PackageAccessScope.singleSubject;
  bool get canRenew {
    if (renewalAllowed != null) return renewalAllowed!;
    if (packageType == PackageType.hours) return remainingHours <= 0;
    if (packageType == PackageType.monthly) {
      return endDate != null && !endDate!.isAfter(DateTime.now());
    }
    return status == 'expired' || status == 'completed';
  }

  factory ParentChildSubscriptionModel.fromJson(
    Map<String, dynamic> json, {
    String curriculumIdFallback = '',
  }) {
    final package = _map(json['package']);
    final subject = _map(json['subject']);
    final period = _map(json['period']);
    return ParentChildSubscriptionModel(
      id: _id(json),
      packageId: _id(package).isNotEmpty
          ? _id(package)
          : _text(json['packageId']),
      packageName: _text(package['name'] ?? json['packageName']),
      curriculumId:
          _nestedId(
            json['curriculum'] ?? json['curriculumId'] ?? package['curriculum'],
          ).isNotEmpty
          ? _nestedId(
              json['curriculum'] ??
                  json['curriculumId'] ??
                  package['curriculum'],
            )
          : curriculumIdFallback,
      accessScope: _text(
        json['accessScope'] ?? package['accessScope'],
        PackageAccessScope.allSubjects,
      ),
      packageType: _text(json['packageType'] ?? package['type']),
      subject: subject.isEmpty
          ? null
          : ParentSubscriptionSubjectModel.fromJson(subject),
      purchasedHours: _number(json['purchasedHours'] ?? package['hours']),
      remainingHours: _number(json['remainingHours']),
      usedHoursValue: _nullableNumber(json['usedHours']),
      status: _text(json['status']),
      startDate: _date(json['startDate'] ?? period['start']),
      endDate: _date(json['expiryDate'] ?? json['endDate'] ?? period['end']),
      price: _nullableNumber(json['paidPrice'] ?? json['price']),
      currency: _nullableText(json['currency'] ?? package['currency']),
      renewalAllowed: json['renewalAllowed'] is bool
          ? json['renewalAllowed'] as bool
          : null,
    );
  }
}

class ParentChildSubscriptionsModel {
  const ParentChildSubscriptionsModel({
    required this.studentId,
    required this.studentName,
    required this.subscriptions,
    this.registrationMode,
    this.subjects = const [],
  });
  final String studentId, studentName;
  final String? registrationMode;
  final List<ParentChildSubscriptionModel> subscriptions;
  final List<ParentSubscriptionSubjectModel> subjects;

  factory ParentChildSubscriptionsModel.fromJson(Map<String, dynamic> json) {
    final student = _map(json['student'] ?? json['child']);
    final source = student.isEmpty ? json : student;
    final curriculumId = _nestedId(
      source['curriculum'] ?? source['curriculumId'] ?? json['curriculum'],
    );
    final rawList = json['subscriptions'];
    final listSubscriptions = rawList is List
        ? rawList
              .map(
                (item) => ParentChildSubscriptionModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                  curriculumIdFallback: curriculumId,
                ),
              )
              .toList()
        : <ParentChildSubscriptionModel>[];
    final subscriptions = listSubscriptions.isNotEmpty
        ? listSubscriptions
        : json['subscription'] is Map
        ? [
            ParentChildSubscriptionModel.fromJson(
              Map<String, dynamic>.from(json['subscription'] as Map),
              curriculumIdFallback: curriculumId,
            ),
          ]
        : <ParentChildSubscriptionModel>[];
    final subjects = <ParentSubscriptionSubjectModel>[];
    final rawSubjects = source['subjects'];
    if (rawSubjects is List) {
      subjects.addAll(
        rawSubjects.whereType<Map>().map(
          (item) => ParentSubscriptionSubjectModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        ),
      );
    }
    for (final subscription in subscriptions) {
      final subject = subscription.subject;
      if (subject != null && !subjects.any((item) => item.id == subject.id)) {
        subjects.add(subject);
      }
    }
    return ParentChildSubscriptionsModel(
      studentId: _id(source),
      studentName: _text(source['fullName'] ?? source['name']),
      registrationMode: _nullableText(
        source['registrationMode'] ??
            json['registrationMode'] ??
            _map(source['curriculum'])['registrationMode'] ??
            _map(json['curriculum'])['registrationMode'],
      ),
      subscriptions: List.unmodifiable(subscriptions),
      subjects: List.unmodifiable(subjects.where((item) => item.id.isNotEmpty)),
    );
  }
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : {};
String _id(Map<String, dynamic> json) => _text(json['id'] ?? json['_id']);
String _nestedId(dynamic value) =>
    value is Map ? _id(Map<String, dynamic>.from(value)) : _text(value);
String _text(dynamic value, [String fallback = '']) {
  final result = value?.toString().trim() ?? '';
  return result.isEmpty ? fallback : result;
}

String? _nullableText(dynamic value) {
  final result = _text(value);
  return result.isEmpty ? null : result;
}

num _number(dynamic value) =>
    value is num ? value : num.tryParse(_text(value)) ?? 0;
num? _nullableNumber(dynamic value) => value == null ? null : _number(value);
DateTime? _date(dynamic value) => DateTime.tryParse(_text(value));
