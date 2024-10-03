import 'package:flutter/material.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSendMessage;

  const MessageInputField({
    super.key,
    required this.messageController,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              blurRadius: 30.0,
            ),
          ],
        ),

      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const Positioned(
                    right: 10,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Icon(
                        size: 25,
                        Icons.camera_alt_outlined,
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 50,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Icon(
                        size: 25,
                        Icons.attach_file_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: onSendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
