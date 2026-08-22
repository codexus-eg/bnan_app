class EgyptianRenewalRequest {
  const EgyptianRenewalRequest({required this.packageId, this.subjectId});
  final String packageId;
  final String? subjectId;

  Map<String, dynamic> toJson() => {
    'packageId': packageId,
    if (_has(subjectId)) 'subjectId': subjectId!.trim(),
  };

  static bool _has(String? value) => value?.trim().isNotEmpty == true;
}
