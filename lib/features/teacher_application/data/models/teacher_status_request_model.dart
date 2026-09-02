class TeacherStatusRequestModel {
  final String status;

  TeacherStatusRequestModel({required this.status});

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}
