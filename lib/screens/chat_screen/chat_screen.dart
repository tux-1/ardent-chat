import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/models/chat_model.dart';
import '../../common/models/message_type.dart';

class ChatScreen extends StatelessWidget {
  final List<Chat> chats;

  ChatScreen({required this.chats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: TextField(
                    showCursor: false,
                    decoration: InputDecoration(
                      hintText: 'Search message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(Icons.edit_square, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Container(
            padding: const EdgeInsets.all(10),
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(chat.profileImageUrl),
                    radius: 25,
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 6,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: chat.isOnline
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                chat.name,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: _buildMessageContent(chat.message),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat.Hm().format(chat.time),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Spacer(flex: 1),
                  if (chat.unreadCount > 0)
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFF703eff),
                      child: Text(
                        chat.unreadCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  Spacer(flex: 1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }}






Widget _buildMessageContent(MessageType messageType) {
  switch (messageType) {
    case MessageType.text:
      return Text(
        'This is a text message that will not overflow',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[700]),
      );
    case MessageType.image:
      return Row(
        children: [
          Icon(Icons.image, color: Colors.grey),
          SizedBox(width: 5),
          Text('Image'),
        ],
      );
    case MessageType.audio:
      return Row(
        children: [
          Icon(Icons.audiotrack, color: Colors.grey),
          SizedBox(width: 5),
          Text('Audio'),
        ],
      );
    case MessageType.video:
      return Row(
        children: [
          Icon(Icons.videocam, color: Colors.grey),
          SizedBox(width: 5),
          Text('Video'),
        ],
      );
    case MessageType.gif:
      return Row(
        children: [
          Icon(Icons.gif, color: Colors.grey),
          SizedBox(width: 5),
          Text('GIF'),
        ],
      );
    default:
      return Text(
        'Unknown Message Type',
        overflow: TextOverflow.ellipsis,
      );
  }
}
