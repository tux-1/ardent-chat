import 'package:ardent_chat/common/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_type.dart';

class Chat {
  // Other contact's data
  final Contact contact;

  // Message related data
  final MessageType messageType;
  final String text;
  final int unreadCount;
  final Timestamp time;
  // attachment ??

  Chat({
    required this.contact,
    required this.messageType,
    required this.text,
    required this.time,
    required this.unreadCount,
  });
}


