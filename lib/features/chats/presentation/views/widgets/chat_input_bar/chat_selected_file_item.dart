part of 'chat_input_bar.dart';

class _ChatSelectedFileItem extends StatelessWidget {
  const _ChatSelectedFileItem({
    required this.file,
    required this.isImage,
    required this.onRemove,
  });

  final PlatformFile file;
  final bool isImage;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 80,
          height: 75,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorManager.black.withAlpha(30)),
          ),
          child: _buildContent(),
        ),
        PositionedDirectional(
          top: -6,
          end: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: const CircleAvatar(
              radius: 11,
              backgroundColor: Colors.red,
              child: Icon(Icons.close, color: Colors.white, size: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (isImage && file.path != null) {
      return Image.file(
        File(file.path!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFileInfo(),
      );
    }

    return _buildFileInfo();
  }

  Widget _buildFileInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.insert_drive_file_outlined, size: 30),
        Text(
          file.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
