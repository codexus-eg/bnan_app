class IdealSupervisorRequest {
  const IdealSupervisorRequest({
    required this.supervisorIds,
    required this.signerName,
  });

  final List<String> supervisorIds;
  final String signerName;

  Map<String, dynamic> toJson() => {
    'supervisorIds': supervisorIds,
    'signerName': signerName.trim(),
  };
}
