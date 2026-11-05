import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';

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
    this.coveredSubjects = const [],
    this.purchasedHours = 0,
    this.remainingHours = 0,
    this.usedHoursValue,
    this.status = '',
    this.computedStatus = '',
    this.isActive,
    this.startDate,
    this.endDate,
    this.gracePeriodEndsAt,
    this.renewalDueDate,
    this.price,
    this.currency,
    this.canRenew = false,
    this.hasPendingRenewal = false,
    this.planKind = '',
    this.remainingValue,
    this.hasRemainingHours = false,
    this.hasPurchasedHours = false,
    this.hasUsedHours = false,
  });

  final String id, packageId, packageName, curriculumId;
  final String accessScope, packageType, status, computedStatus;
  final bool? isActive;
  final ParentSubscriptionSubjectModel? subject;
  final List<ParentSubscriptionSubjectModel> coveredSubjects;
  final num purchasedHours, remainingHours;
  final num? usedHoursValue, price;
  final String? currency;
  final DateTime? startDate, endDate, gracePeriodEndsAt, renewalDueDate;
  final bool canRenew, hasPendingRenewal;
  final String planKind;
  final num? remainingValue;
  final bool hasRemainingHours;
  final bool hasPurchasedHours, hasUsedHours;

  num get usedHours =>
      usedHoursValue ??
      (purchasedHours - remainingHours).clamp(0, double.infinity);
  bool get isHoursPlan =>
      hasRemainingHours || packageType == 'hours' || planKind == 'gulf';
  bool get isSingleSubject => accessScope == PackageAccessScope.singleSubject;
  bool get isSharedSubjects => accessScope == PackageAccessScope.sharedSubjects;
  bool get isAllSubjects => accessScope == PackageAccessScope.allSubjects;
  String get effectiveStatus =>
      computedStatus.isEmpty ? status : computedStatus;
  factory ParentChildSubscriptionModel.fromJson(
    Map<String, dynamic> json, {
    String curriculumIdFallback = '',
  }) {
    final package = _map(json['package']);
    final subject = _map(json['subject']);
    final period = _map(json['period']);
    final summary = _map(json['summary']);
    final remaining = _map(json['remaining']);
    final summarySubject = _map(summary['subject']);
    final rawCoveredSubjects =
        json['coveredSubjects'] ?? json['subjects'] ?? package['subjects'];
    final coveredSubjects = <ParentSubscriptionSubjectModel>[];
    if (rawCoveredSubjects is List) {
      coveredSubjects.addAll(
        rawCoveredSubjects.whereType<Map>().map(
          (item) => ParentSubscriptionSubjectModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        ),
      );
    } else if (subject.isNotEmpty || summarySubject.isNotEmpty) {
      coveredSubjects.add(
        ParentSubscriptionSubjectModel.fromJson(
          subject.isEmpty ? summarySubject : subject,
        ),
      );
    }
    final rawRemainingHours =
        json['remainingHours'] ?? summary['remainingHours'];
    final rawPurchasedHours =
        json['purchasedHours'] ?? package['hours'] ?? summary['totalHours'];
    final rawUsedHours = json['usedHours'] ?? summary['usedHours'];
    return ParentChildSubscriptionModel(
      id: _id(json),
      packageId: _id(package).isNotEmpty
          ? _id(package)
          : _text(json['packageId']),
      packageName: _text(
        package['name'] ?? json['packageName'] ?? summary['packageName'],
      ),
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
        json['accessScope'] ?? package['accessScope'] ?? summary['accessScope'],
        PackageAccessScope.allSubjects,
      ),
      packageType: _text(
        json['packageType'] ?? package['type'] ?? summary['packageType'],
      ),
      subject: subject.isEmpty && summarySubject.isEmpty
          ? (coveredSubjects.isNotEmpty ? coveredSubjects.first : null)
          : ParentSubscriptionSubjectModel.fromJson(
              subject.isEmpty ? summarySubject : subject,
            ),
      coveredSubjects: List.unmodifiable(coveredSubjects),
      purchasedHours: _number(rawPurchasedHours),
      hasPurchasedHours: rawPurchasedHours != null,
      remainingHours: _number(rawRemainingHours),
      hasRemainingHours: rawRemainingHours != null,
      remainingValue: _nullableNumber(remaining['value']),
      usedHoursValue: _nullableNumber(rawUsedHours),
      hasUsedHours:
          rawUsedHours != null ||
          rawPurchasedHours != null && rawRemainingHours != null,
      status: _text(json['status']),
      computedStatus: _text(json['computedStatus']),
      isActive: json['isActive'] is bool ? json['isActive'] as bool : null,
      startDate: _date(json['startDate'] ?? period['start']),
      endDate: _date(json['expiryDate'] ?? json['endDate'] ?? period['end']),
      gracePeriodEndsAt: _date(json['gracePeriodEndsAt']),
      renewalDueDate: _date(json['renewalDueDate']),
      price: _nullableNumber(json['paidPrice'] ?? json['price']),
      currency: _nullableText(json['currency'] ?? package['currency']),
      canRenew: json['canRenew'] is bool ? json['canRenew'] as bool : false,
      hasPendingRenewal: json['hasPendingRenewal'] is bool
          ? json['hasPendingRenewal'] as bool
          : false,
      planKind: _text(json['planKind'] ?? summary['planKind']),
    );
  }
}

class ParentChildSubscriptionsModel {
  const ParentChildSubscriptionsModel({
    required this.studentId,
    required this.studentName,
    required this.subscriptions,
    this.curriculumId = '',
    this.registrationMode,
    this.subjects = const [],
  });
  final String studentId, studentName, curriculumId;
  final String? registrationMode;
  final List<ParentChildSubscriptionModel> subscriptions;
  final List<ParentSubscriptionSubjectModel> subjects;

  factory ParentChildSubscriptionsModel.fromJson(Map<String, dynamic> json) {
    final student = _map(json['student'] ?? json['child']);
    final source = student.isEmpty ? json : student;
    final curriculumId = _nestedId(
      json['curriculumId'] ??
          json['curriculum'] ??
          source['curriculumId'] ??
          source['curriculum'],
    );
    final rawList = json['subscriptions'];
    final listSubscriptions = rawList is List
        ? rawList
              .whereType<Map>()
              .map(
                (item) => ParentChildSubscriptionModel.fromJson(
                  Map<String, dynamic>.from(item),
                  curriculumIdFallback: curriculumId,
                ),
              )
              .toList()
        : <ParentChildSubscriptionModel>[];
    final subscriptions = listSubscriptions;
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
      for (final s in subscription.coveredSubjects) {
        if (!subjects.any((item) => item.id == s.id)) {
          subjects.add(s);
        }
      }
      final subject = subscription.subject;
      if (subject != null && !subjects.any((item) => item.id == subject.id)) {
        subjects.add(subject);
      }
    }
    return ParentChildSubscriptionsModel(
      studentId: _id(source),
      studentName: _text(source['fullName'] ?? source['name']),
      curriculumId: curriculumId,
      registrationMode: _registrationMode(json['registrationMode']),
      subscriptions: List.unmodifiable(subscriptions),
      subjects: List.unmodifiable(subjects.where((item) => item.id.isNotEmpty)),
    );
  }

  factory ParentChildSubscriptionsModel.fromStudentHome(
    Map<String, dynamic> json, {
    List<ParentSubscriptionSubjectModel> subjects = const [],
  }) {
    final data = _map(json['data']);
    final student = _map(data['student']);
    final studentCurriculum = _map(student['curriculum']);
    final parsed = ParentChildSubscriptionsModel.fromJson({
      'student': student,
      'subscriptions': data['subscriptions'],
    });
    return ParentChildSubscriptionsModel(
      studentId: parsed.studentId,
      studentName: parsed.studentName,
      curriculumId: parsed.curriculumId,
      registrationMode: _registrationMode(
        student['registrationMode'] ?? studentCurriculum['registrationMode'],
      ),
      subscriptions: parsed.subscriptions,
      subjects: subjects.isEmpty
          ? parsed.subjects
          : List.unmodifiable(subjects),
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

String? _registrationMode(dynamic value) =>
    switch (_nullableText(value)?.toLowerCase()) {
      'gulf' => 'gulf',
      'egyptian' => 'egyptian',
      _ => null,
    };

num _number(dynamic value) =>
    value is num ? value : num.tryParse(_text(value)) ?? 0;
num? _nullableNumber(dynamic value) => value == null ? null : _number(value);
DateTime? _date(dynamic value) => DateTime.tryParse(_text(value));
