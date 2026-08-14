class AdminSubjectRequestModel {
  const AdminSubjectRequestModel({
    required this.id,
    required this.status,
    required this.studentName,
    this.studentPhone = '',
    this.curriculum,
    this.grade,
    this.subject,
    this.packageName,
    this.price,
    this.currency,
    this.notes,
    this.requestedAt,
  });

  final String id;
  final String status;
  final String studentName;
  final String studentPhone;
  final String? curriculum;
  final String? grade;
  final String? subject;
  final String? packageName;
  final num? price;
  final String? currency;
  final String? notes;
  final DateTime? requestedAt;

  factory AdminSubjectRequestModel.fromJson(Map<String, dynamic> json) {
    final student = _map(json['student']);
    final studentUser = _map(student['user']);
    final package = _map(json['package']);
    return AdminSubjectRequestModel(
      id: _text(json['subjectRequestId'] ?? json['id'] ?? json['_id']) ?? '',
      status: _text(json['status']) ?? '',
      studentName:
          _text(
            student['fullName'] ??
                student['name'] ??
                studentUser['fullName'] ??
                studentUser['name'] ??
                json['studentName'],
          ) ??
          '',
      studentPhone: _text(student['phone'] ?? json['studentPhone']) ?? '',
      curriculum: _lookupName(json['curriculum']),
      grade: _lookupName(json['grade']),
      subject: _subjectName(json),
      packageName: _text(package['name'] ?? json['packageName']),
      price: _number(package['price'] ?? json['price']),
      currency: _text(package['currency'] ?? json['currency']),
      notes: _text(json['notes']),
      requestedAt: DateTime.tryParse(
        _text(json['requestedAt'] ?? json['createdAt']) ?? '',
      ),
    );
  }
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : {};
String? _text(dynamic value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

String? _lookupName(dynamic value) =>
    value is Map ? _text(value['name']) : _text(value);
String? _subjectName(Map<String, dynamic> json) {
  final subject = _map(json['subject']);
  return _text(
    subject['name'] ?? subject['displayName'] ?? json['subjectName'],
  );
}

num? _number(dynamic value) =>
    value is num ? value : num.tryParse(value?.toString() ?? '');
