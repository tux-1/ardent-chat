import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_type.dart';

class Chat {
  final String name;
  final MessageType messageType;
  final Timestamp time;
  final int unreadCount;
  final String profileImageUrl;
  final bool isOnline;

  Chat({
    required this.name,
    required this.messageType,
    required this.time,
    required this.unreadCount,
    required this.profileImageUrl,
    required this.isOnline,
  });
}

List<Chat> chatList = [
  Chat(
    name: 'Sebastian Rudiger',
    messageType: MessageType.text,
    time: Timestamp.now(),
    unreadCount: 0,
    profileImageUrl: 'assets/images/welcome (1).png',
    isOnline: true,
  ),
  Chat(
    name: 'Caroline Varsaha',
    messageType: MessageType.gif,
    time: Timestamp.now(),
    unreadCount: 2,
    profileImageUrl: 'assets/images/welcome (1).png',
    isOnline: false,
  ),
  Chat(
    name: 'Caroline Varsaha',
    messageType: MessageType.video,
    time: Timestamp.now(),
    unreadCount: 2,
    profileImageUrl: 'assets/images/welcome (1).png',
    isOnline: true,
  ),
  Chat(
    name: 'Caroline Varsaha',
    messageType: MessageType.audio,
    time: Timestamp.now(),
    unreadCount: 2,
    profileImageUrl: 'assets/images/welcome (1).png',
    isOnline: false,
  ),
  Chat(
    name: 'Caroline Varsaha',
    messageType: MessageType.image,
    time: Timestamp.now(),
    unreadCount: 2,
    profileImageUrl: 'assets/images/welcome (1).png',
    isOnline: true,
  ),
];
