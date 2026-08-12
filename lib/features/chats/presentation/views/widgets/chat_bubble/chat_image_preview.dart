import 'package:flutter/material.dart';

class ChatImagePreview extends StatelessWidget {
  const ChatImagePreview({
    super.key,
    required this.imageUrl,
    this.headers = const {},
  });

  final String imageUrl;
  final Map<String, String> headers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Image.network(
            imageUrl,
            headers: headers,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) => progress == null
                ? child
                : const CircularProgressIndicator(color: Colors.white),
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}
