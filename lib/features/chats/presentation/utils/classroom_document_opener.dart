import 'package:bnan_app/core/helper/file_url_launcher.dart';

enum DocumentOpenResult { opened, missing, invalid, failed, busy }

abstract class ClassroomDocumentLauncher {
  Future<bool> open(String url);
}

class SystemClassroomDocumentLauncher implements ClassroomDocumentLauncher {
  const SystemClassroomDocumentLauncher();

  @override
  Future<bool> open(String url) => FileUrlLauncher.open(url);
}

class ClassroomDocumentOpener {
  ClassroomDocumentOpener(this.launcher);

  final ClassroomDocumentLauncher launcher;
  bool _opening = false;

  Future<DocumentOpenResult> open(String? url) async {
    final value = url?.trim();
    if (value == null || value.isEmpty) {
      return DocumentOpenResult.missing;
    }
    if (!FileUrlLauncher.isValidWebUrl(value)) {
      return DocumentOpenResult.invalid;
    }
    if (_opening) return DocumentOpenResult.busy;
    _opening = true;
    try {
      return await launcher.open(value)
          ? DocumentOpenResult.opened
          : DocumentOpenResult.failed;
    } catch (_) {
      return DocumentOpenResult.failed;
    } finally {
      _opening = false;
    }
  }
}

final defaultClassroomDocumentOpener = ClassroomDocumentOpener(
  const SystemClassroomDocumentLauncher(),
);
