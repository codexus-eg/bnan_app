part of 'chat_input_bar.dart';

class _ChatRecordingWidget extends StatelessWidget {
  const _ChatRecordingWidget({required this.duration, required this.onCancel});

  final String duration;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 52,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withAlpha(60)),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onCancel,
              child: const Icon(Icons.delete_outline, color: Colors.red),
            ),
            const Spacer(),
            const CircleAvatar(radius: 4.5, backgroundColor: Colors.red),
            const SizedBox(width: 8),
            Text(
              duration,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 8),
            const Text('جاري التسجيل', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
