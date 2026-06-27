class LoggedUserGradeModel {
  final String id;
  final String name;

  const LoggedUserGradeModel({
    required this.id,
    required this.name,
  });

  factory LoggedUserGradeModel.fromJson(Map<String, dynamic> json) {
    return LoggedUserGradeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}