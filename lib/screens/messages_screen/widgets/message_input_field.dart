import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../common/models/chat_model.dart';
import '../../../common/helpers/messages_helper.dart';
import '../../../common/models/message.dart';
import '../../../common/models/message_type.dart';
import 'image_preview.dart';

class MessageInputField extends StatefulWidget {
  final Chat chat;
  final TextEditingController messageController;
  final Function(String text, File? image, File? file) onSendMessage;

  const MessageInputField({
    super.key,
    required this.chat,
    required this.messageController,
    required this.onSendMessage,
  });

  @override
  _MessageInputFieldState createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  File? selectedImage;
  File? selectedFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        _showPreviewDialog(); // Show dialog when image is picked
      });
    }
  }

  Future<void> pickFile() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        selectedFile = File(file.path);
        _showPreviewDialog(); // Show dialog when file is picked
      });
    }
  }

  void _removePreview() {
    setState(() {
      selectedImage = null;
      selectedFile = null;
    });
  }

  void _sendMessage(String caption) {
    final text = widget.messageController.text.trim();
    if (text.isNotEmpty || selectedImage != null || selectedFile != null) {
      MessagesHelper.sendMessage(
        msg: Message(
          senderId: FirebaseAuth.instance.currentUser!.uid,
          text: text.isNotEmpty ? text : caption,
          messageType: selectedImage != null
              ? MessageType.image
              : selectedFile != null
              ? MessageType.image
              : MessageType.text,
          time: Timestamp.now(),
          attachmentFile: selectedImage ?? selectedFile,
        ),
        chatId: widget.chat.chatId,
      );
      widget.messageController.clear();
      _removePreview();
    }
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImagePreview(
          selectedImage: selectedImage,
          selectedFile: selectedFile,
          onClose: () {
            Navigator.pop(context);
            _removePreview();
          },
          onSend: (caption) {
            Navigator.pop(context);
            _sendMessage(caption);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).colorScheme.secondary,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.messageController,
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                          left: 9,
                          top: 7,
                          bottom: 7,
                        ),
                        fillColor: Theme.of(context).colorScheme.secondary,
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(
                    height: 55,
                    child: VerticalDivider(
                      width: 1,
                      indent: 17,
                      endIndent: 17,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.attach_file_outlined,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        onPressed: pickFile,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        onPressed: pickImage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
            onPressed: () {
              _sendMessage(widget.messageController.text.trim());
            },
          ),
        ],
      ),
    );
  }
}
