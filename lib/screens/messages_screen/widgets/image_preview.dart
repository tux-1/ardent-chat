import 'package:flutter/material.dart';
import 'dart:io';

class ImagePreview extends StatelessWidget {
  final File? selectedImage;
  final File? selectedFile;
  final Function() onClose;
  final Function(String caption) onSend;
  final TextEditingController controller;

  const ImagePreview({
    super.key,
    required this.controller,
    required this.selectedImage,
    required this.selectedFile,
    required this.onClose,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: selectedImage != null
                  ? Image.file(
                      selectedImage!,
                      fit: BoxFit.contain,
                    )
                  : selectedFile != null
                      ? Image.file(
                          selectedFile!,
                          fit: BoxFit.contain,
                        )
                      : const SizedBox(),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.6),
                  shape: const CircleBorder(),
                ),
                onPressed: onClose,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Add a caption...',
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          maxLines: null,
                          onSubmitted: (caption) {
                            onSend(caption);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30,
                        ),
                        onPressed: () {
                          onSend(controller.text);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
