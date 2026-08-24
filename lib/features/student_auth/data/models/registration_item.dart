class RegistrationItem {
  const RegistrationItem({required this.subjectId, required this.packageId});

  final String subjectId;
  final String packageId;

  Map<String, dynamic> toJson() => {
    'subjectId': subjectId,
    'packageId': packageId,
  };
}
