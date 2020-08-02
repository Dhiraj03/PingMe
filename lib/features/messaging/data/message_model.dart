import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Message {
  final String sender;
  final String receiver;
  final String message;
  Timestamp  timestamp;
  final String photoUrl;
  final int  type;  // 0 - Plain text message, 1 - Image, 2 - Image with text
  Message({
   @required this.sender,
   @required this.receiver,
   @required this.message,
    this.timestamp,
   @required this.type,
    this.photoUrl
  });
  
  factory Message.fromJson(Map<String, dynamic> message)
  {
    final Message messageres = Message(
    message: message
        ['message'],
    sender: message
        ['sender'],
    receiver: message
        ['receiver'],
    timestamp: message
        ['timestamp'],
    type: message
        ['type']);
    return messageres;
  }

}
