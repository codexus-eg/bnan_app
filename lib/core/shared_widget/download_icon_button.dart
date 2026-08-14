import 'package:bnan_app/core/shared_widget/app_top_feedback/app_top_feedback.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/device_file_saver.dart';
import 'package:bnan_app/core/utils/download_save_result.dart';
import 'package:bnan_app/core/utils/file_downloader.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DownloadIconButton extends StatefulWidget {
  const DownloadIconButton({
    super.key,
    required this.url,
    this.fileName,
    this.enabled = true,
  });

  final String url;
  final String? fileName;
  final bool enabled;

  @override
  State<DownloadIconButton> createState() => _DownloadIconButtonState();
}

class _DownloadIconButtonState extends State<DownloadIconButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: S.of(context).download,
    onPressed: _isLoading || !widget.enabled || widget.url.trim().isEmpty
        ? null
        : _download,
    icon: SvgPicture.asset(
      ImageManager.downloadIcon,
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(
        ColorManager.mainColor14,
        BlendMode.srcIn,
      ),
    ),
  );

  Future<void> _download() async {
    setState(() => _isLoading = true);
    final certificate = (widget.fileName ?? widget.url).toLowerCase().contains(
      'certificate',
    );
    final s = S.of(context);
    final feedback = AppTopFeedback.show(
      context,
      type: AppTopFeedbackType.loading,
      title: certificate ? s.savingCertificate : s.savingFile,
      dedupKey: 'file-download',
      showClose: false,
    );
    final result = await FileDownloader.download(
      url: widget.url,
      fileName: widget.fileName ?? _nameFrom(widget.url),
    );
    if (!mounted) {
      AppTopFeedback.dismiss(feedback);
      return;
    }
    setState(() => _isLoading = false);
    if (result.status == DownloadSaveStatus.cancelled) {
      AppTopFeedback.dismiss(feedback);
      return;
    }
    final success = result.status == DownloadSaveStatus.saved;
    AppTopFeedback.replace(
      context,
      feedback,
      title: success
          ? certificate
                ? s.certificateSavedSuccessfully
                : s.fileSavedSuccessfully
          : s.unableToDownloadFile,
      type: success ? AppTopFeedbackType.success : AppTopFeedbackType.error,
      body: success ? result.location : s.tryAgain,
      actionLabel: s.openAction,
      onAction: success && result.canOpen ? () => _open(result) : null,
    );
  }

  Future<void> _open(DownloadSaveResult result) async {
    final opened = await DeviceFileSaver.open(result);
    if (!mounted || opened) return;
    AppTopFeedback.show(
      context,
      title: S.of(context).unableToOpenFile,
      body: S.of(context).tryAgain,
      type: AppTopFeedbackType.error,
    );
  }

  String _nameFrom(String value) {
    final segments = Uri.tryParse(value)?.pathSegments;
    return segments?.isNotEmpty == true ? segments!.last : 'downloaded_file';
  }
}
