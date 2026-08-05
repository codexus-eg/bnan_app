import 'package:bnan_app/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    return GestureDetector(
      onTap: isLoading ? null : _download,
      behavior: HitTestBehavior.opaque,
      child: isLoading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : SvgPicture.asset(
              ImageManager.downloadIcon,
              height: 20,
              width: 20,
              fit: BoxFit.contain,
            ),
    );
  }

  Future<void> _download() async {
    setState(() => isLoading = true);
    await widget.onTap();
    if (mounted) setState(() => isLoading = false);
  }
}
