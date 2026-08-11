class ParentAddChildSubmission {
  const ParentAddChildSubmission({required this.status});

  final String status;

  factory ParentAddChildSubmission.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final data = raw is Map ? Map<String, dynamic>.from(raw) : json;
    return ParentAddChildSubmission(
      status: data['status']?.toString() ?? 'pending_review',
    );
  }
}
