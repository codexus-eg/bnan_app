class EgyptianRenewalRequest {
  const EgyptianRenewalRequest({
    required this.packageId,
    this.subscriptionId,
    this.subjectId,
  });
  final String packageId;
  final String? subscriptionId;
  final String? subjectId;

  Map<String, dynamic> toJson() => _has(subscriptionId)
      ? {'subscriptionId': subscriptionId!.trim(), 'packageId': packageId}
      : {
          'packageId': packageId,
          if (_has(subjectId)) 'subjectId': subjectId!.trim(),
        };

  static bool _has(String? value) => value?.trim().isNotEmpty == true;
}
