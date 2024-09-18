import 'package:flutter/material.dart';

enum MessageType {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  final String type;

  const MessageType(this.type);
}

