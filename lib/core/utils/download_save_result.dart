enum DownloadSaveStatus { saved, cancelled, failed }

class DownloadSaveResult {
  const DownloadSaveResult({
    required this.status,
    this.location,
    this.reference,
    this.mimeType,
    this.canOpen = false,
  });

  const DownloadSaveResult.failed() : this(status: DownloadSaveStatus.failed);

  final DownloadSaveStatus status;
  final String? location;
  final String? reference;
  final String? mimeType;
  final bool canOpen;
}
