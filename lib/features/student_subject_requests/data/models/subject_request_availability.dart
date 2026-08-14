import 'package:bnan_app/core/enums/registration_mode.dart';

class SubjectRequestAvailability {
  const SubjectRequestAvailability({
    required this.curriculum,
    required this.grade,
    required this.subjects,
    required this.registrationMode,
  });

  final SubjectRequestLookup curriculum;
  final SubjectRequestLookup grade;
  final List<AvailableSubject> subjects;
  final RegistrationMode registrationMode;

  factory SubjectRequestAvailability.fromJson(Map<String, dynamic> json) {
    final data = _map(json['data']);
    final curriculum = _map(data['curriculum']);
    final registrationMode = RegistrationMode.fromValue(
      curriculum['registrationMode'],
    );
    if (registrationMode == null) {
      throw const FormatException('Missing curriculum.registrationMode');
    }
    return SubjectRequestAvailability(
      curriculum: SubjectRequestLookup.fromJson(curriculum),
      grade: SubjectRequestLookup.fromJson(_map(data['grade'])),
      subjects: _list(
        data['subjects'],
      ).map((item) => AvailableSubject.fromJson(_map(item))).toList(),
      registrationMode: registrationMode,
    );
  }
}

class SubjectRequestLookup {
  const SubjectRequestLookup({required this.id, required this.name});
  final String id;
  final String name;

  factory SubjectRequestLookup.fromJson(Map<String, dynamic> json) =>
      SubjectRequestLookup(
        id: (json['id'] ?? json['_id'] ?? '').toString(),
        name: (json['name'] ?? json['fullName'] ?? json['displayName'] ?? '')
            .toString(),
      );
}

class AvailableSubject {
  const AvailableSubject({
    required this.id,
    required this.name,
    required this.isSelectable,
    this.requestStatus,
  });

  final String id;
  final String name;
  final bool isSelectable;
  final String? requestStatus;

  factory AvailableSubject.fromJson(Map<String, dynamic> json) =>
      AvailableSubject(
        id: (json['id'] ?? json['_id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        isSelectable: json['isSelectable'] == true,
        requestStatus: _text(json['requestStatus']),
      );
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : {};
List<dynamic> _list(dynamic value) => value is List ? value : const [];
String? _text(dynamic value) =>
    value?.toString().trim().isEmpty == false ? value.toString().trim() : null;
