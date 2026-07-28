import 'registration_json_parsing.dart';

class RegistrationLookupModel {
  const RegistrationLookupModel({required this.id, required this.name});

  final String id;
  final String name;

  factory RegistrationLookupModel.fromJson(Map<String, dynamic> json) {
    return RegistrationLookupModel(
      id: registrationString(json['id'] ?? json['_id']),
      name: registrationString(json['name']),
    );
  }
}
