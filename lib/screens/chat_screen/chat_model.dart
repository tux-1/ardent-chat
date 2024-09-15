
import 'message_type.dart';

class Chat {
  final String name;
  final MessageType message;
  final DateTime time;
  final int unreadCount;
  final String profileImageUrl;
  final bool isOnline;

  Chat({
    required this.name,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.profileImageUrl,
    required this.isOnline,
  });
}

List<Chat> chatList = [
  Chat(
    name: 'Sebastian Rudiger',
    message: MessageType.text,
    time: DateTime.now(),
    unreadCount: 0,
    profileImageUrl: 'images/welcome (1).png',
    isOnline: true,
  ),
  Chat(
    name: 'Caroline Varsaha',
    message: MessageType.gif,
    time: DateTime.now(),
    unreadCount: 2,
    profileImageUrl: 'images/welcome (1).png',
    isOnline: false,
  ),
  Chat(
    name: 'Caroline Varsaha',
    message: MessageType.video,
    time: DateTime.now(),
    unreadCount: 2,
    profileImageUrl: 'images/welcome (1).png',
    isOnline: true,
  ),
  Chat(
    name: 'Caroline Varsaha',
    message: MessageType.audio,
    time: DateTime.now(),
    unreadCount: 2,
    profileImageUrl: 'images/welcome (1).png',
    isOnline: false,
  ),
  Chat(
    name: 'Caroline Varsaha',
    message: MessageType.image,
    time: DateTime.now(),
    unreadCount: 2,
    profileImageUrl: 'images/welcome (1).png',
    isOnline: true,
  ),
];