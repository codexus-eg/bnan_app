import 'registration_json_parsing.dart';

class RegistrationRequestsPaginationModel {
  const RegistrationRequestsPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  factory RegistrationRequestsPaginationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RegistrationRequestsPaginationModel(
      currentPage: registrationInt(json['currentPage']),
      perPage: registrationInt(json['perPage']),
      total: registrationInt(json['total']),
      lastPage: registrationInt(json['lastPage']),
    );
  }
}
