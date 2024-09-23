import 'package:flutter/material.dart';
enum MessageType {
  text,
  image,
  audio,
  video,
  gif,
}
Widget buildMessageContent(MessageType messageType, BuildContext context) {
  switch (messageType) {
    case MessageType.text:
      return Text(
        'This is a text message that will not overflow',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      );
    case MessageType.image:
      return Row(
        children: [
          Icon(Icons.image, color: Theme.of(context).colorScheme.onSurface),
          SizedBox(width: 5),
          Text('Image'),
        ],
      );
    case MessageType.audio:
      return Row(
        children: [
          Icon(Icons.audiotrack, color: Theme.of(context).colorScheme.onSurface),
          SizedBox(width: 5),
          Text('Audio'),
        ],
      );
    case MessageType.video:
      return Row(
        children: [
          Icon(Icons.videocam, color: Theme.of(context).colorScheme.onSurface),
          SizedBox(width: 5),
          Text('Video'),
        ],
      );
    case MessageType.gif:
      return Row(
        children: [
          Icon(Icons.gif, color: Theme.of(context).colorScheme.onSurface),
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

