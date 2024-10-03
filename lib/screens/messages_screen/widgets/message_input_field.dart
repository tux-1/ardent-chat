import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../common/models/chat_model.dart';
import '../../../common/helpers/messages_helper.dart';
import '../../../common/models/message.dart';
import '../../../common/models/message_type.dart';

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
      });
    }
  }

  Future<void> pickFile() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        selectedFile = File(file.path);
      });
    }
  }

  void _removePreview() {
    setState(() {
      selectedImage = null;
      selectedFile = null;
    });
  }

  void _sendMessage() {
    final text = widget.messageController.text.trim();
    if (text.isNotEmpty || selectedImage != null || selectedFile != null) {
      MessagesHelper.sendMessage(
        msg: Message(
          senderId: FirebaseAuth.instance.currentUser!.uid,
          text: text,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (selectedImage != null || selectedFile != null)
          Container(

            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Stack(

              children: [

                if (selectedImage != null)
                  Image.file(
                    selectedImage!,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                if (selectedFile != null)
                  Image.file(
                    selectedFile!,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    onPressed: _removePreview,
                  ),
                ),
              ],
            ),
          ),
        Container(
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
                        controller: widget.messageController,
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
                      Positioned(
                        right: 10,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt_outlined),
                            onPressed: pickImage,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 50,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.attach_file_outlined),
                            onPressed: pickFile,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
