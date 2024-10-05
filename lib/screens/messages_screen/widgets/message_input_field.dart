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

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Positioned.fill(
                child: selectedImage != null
                    ? Image.file(
                        selectedImage!,
                        fit: BoxFit.fill,
                      )
                    : selectedFile != null
                        ? Image.file(
                            selectedFile!,
                            fit: BoxFit.fill,
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
                  onPressed: () {
                    Navigator.pop(context);
                    _removePreview();
                  },
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: widget.messageController,
                            decoration: InputDecoration(
                              hintText: 'Add a caption...',
                              hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            maxLines: null,
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
                            Navigator.pop(context);
                            _sendMessage();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
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
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        onPressed: pickFile,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        onPressed: pickImage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
