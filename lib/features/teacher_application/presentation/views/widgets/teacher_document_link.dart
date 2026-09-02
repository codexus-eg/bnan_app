import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherDocumentLink extends StatelessWidget {
  const TeacherDocumentLink({
    super.key,
    required this.label,
    required this.url,
  });
  final String label, url;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => _open(context),
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.open_in_new, color: ColorManager.mainColor15),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    ),
  );

  Future<void> _open(BuildContext context) async {
    final opened =
        FileUrlLauncher.isValidWebUrl(url) && await FileUrlLauncher.open(url);
    if (!opened && context.mounted) {
      showCustomSnackBar(context, S.of(context).failedToOpenFile, false);
    }
  }
}
