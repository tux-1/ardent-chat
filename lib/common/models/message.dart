import 'dart:io';

import 'package:ardent_chat/common/models/message_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String text;
  final MessageType messageType;
  /// Local file when sending
  final File? attachmentFile; 
  /// URL from Firebase when receiving the [Message]
  final String? attachmentUrl;
  final List<String> seenBy;
  final Timestamp time;

  const Message({
    required this.senderId,
    required this.text,
    required this.messageType,
    this.attachmentFile, // Used only for sending
    this.attachmentUrl,  // Used for displaying received attachments
    this.seenBy = const [],
    required this.time,
  });

  // fromJson constructor for receiving a message
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'] ?? '',
      text: json['text'] ?? '',
      messageType: MessageType.values[json['messageType'] ?? 0],
      attachmentUrl: json['attachmentUrl'], // Load the URL
      seenBy: List<String>.from(json['seenBy'] ?? []),
      time: json['time'] ?? Timestamp.now(),
    );
  }

  // toJson for sending a message (attachmentFile is a File)
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'text': text,
      'messageType': messageType.index,
      'attachmentUrl': attachmentUrl, // Uploaded URL
      'seenBy': seenBy,
      'time': time,
    };
  }
}
