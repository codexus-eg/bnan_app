part of 'chat_input_bar.dart';

class _ChatSelectedFilesPreview extends StatelessWidget {
  const _ChatSelectedFilesPreview({
    required this.files,
    required this.isImageFile,
    required this.onRemove,
  });

  final List<PlatformFile> files;
  final bool Function(PlatformFile file) isImageFile;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.only(start: 8, end: 8, bottom: 12),
        itemCount: files.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          return _ChatSelectedFileItem(
            file: files[index],
            isImage: isImageFile(files[index]),
            onRemove: () => onRemove(index),
          );
        },
      ),
    );
  }
}
