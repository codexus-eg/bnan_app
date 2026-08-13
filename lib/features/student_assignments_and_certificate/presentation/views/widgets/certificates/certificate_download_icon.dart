import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/assignments/assignment_action_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CertificateDownloadIcon extends StatefulWidget {
  const CertificateDownloadIcon({super.key, required this.onTap});

  final Future<void> Function() onTap;

  @override
  State<CertificateDownloadIcon> createState() =>
      _CertificateDownloadIconState();
}

class _CertificateDownloadIconState extends State<CertificateDownloadIcon> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 36,
      child: isLoading
          ? const Center(
              child: SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : AssignmentActionButton(
              text: S.of(context).download,
              icon: ImageManager.downloadIcon,
              onTap: _download,
            ),
    );
  }

  Future<void> _download() async {
    setState(() => isLoading = true);
    await widget.onTap();
    if (mounted) setState(() => isLoading = false);
  }
}
